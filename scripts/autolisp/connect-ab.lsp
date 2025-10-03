(vl-load-com)

(defun mt:effective-name (ent / obj)
  (if (and ent (eq (type ent) 'ENAME))
    (progn
      (setq obj (vlax-ename->vla-object ent))
      (cond
        ((vlax-property-available-p obj 'EffectiveName)
         (strcase (vla-get-EffectiveName obj)))
        (t (strcase (cdr (assoc 2 (entget ent)))))))))

(defun mt:get-inserts ( / ss)
  (setq ss (ssget "X" '((0 . "INSERT"))))
  ss)

(defun mt:ss->list (ss)
  (if ss (mapcar '(lambda (i) (ssname ss i)) (vl-number-seq 0 (1- (sslength ss))))))

(defun mt:filter-by-name (ents name)
  (setq name (strcase name))
  (vl-remove-if-not
    (function (lambda (e) (equal (mt:effective-name e) name)))
    ents))

(defun mt:get-rot (ent) (or (cdr (assoc 50 (entget ent))) 0.0))
(defun mt:get-inspt (ent) (cdr (assoc 10 (entget ent))))

(defun mt:get-att (ent tag / obj val)
  (setq tag (strcase tag))
  (setq obj (vlax-ename->vla-object ent))
  (if (vlax-method-applicable-p obj 'GetAttributes)
    (vlax-for att (vlax-invoke obj 'GetAttributes)
      (if (= (strcase (vla-get-TagString att)) tag)
        (setq val (vla-get-TextString att)))))
  val)

(defun mt:parse-num (s) (if (and s (/= s "")) (atof s) 0.0))

(defun mt:rot-offset (dx dy ang)
  (list
    (- (* dx (cos ang)) (* dy (sin ang)))
    (+ (* dx (sin ang)) (* dy (cos ang)))))

(defun mt:add-pt (p off) (list (+ (car p) (car off)) (+ (cadr p) (cadr off))))

(defun mt:get-conn-pt (ent prefix / ins ang dx dy)
  (setq ins (mt:get-inspt ent))
  (setq ang (mt:get-rot ent))
  (setq dx (mt:parse-num (mt:get-att ent (strcat prefix "_DX"))))
  (setq dy (mt:parse-num (mt:get-att ent (strcat prefix "_DY"))))
  (mt:add-pt ins (mt:rot-offset dx dy ang)))

(defun mt:nearest (pt cand) ; cand = list of (ent . pt)
  (car (vl-sort cand '(lambda (a b) (< (distance pt (cdr a)) (distance pt (cdr b)))))))

(defun c:CONNECT_AB ( / aName bName maxd all entsA entsB bList eA aPt nearestB)
  (vl-load-com)
  (setq aName (getstring T "\nBlock name for A <A_BLOCK>: "))
  (if (= aName "") (setq aName "A_BLOCK"))
  (setq bName (getstring T "\nBlock name for B <B_BLOCK>: "))
  (if (= bName "") (setq bName "B_BLOCK"))
  (setq maxd (getreal "\nMax connect distance <1000>: "))
  (if (null maxd) (setq maxd 1000.0))

  (setq all (mt:ss->list (mt:get-inserts)))
  (setq entsA (mt:filter-by-name all aName))
  (setq entsB (mt:filter-by-name all bName))

  (if (or (null entsA) (null entsB))
    (progn (prompt "\nNothing to do: missing A or B instances.") (princ))
    (progn
      (setq bList (mapcar '(lambda (eB) (cons eB (mt:get-conn-pt eB "B"))) entsB))
      (foreach eA entsA
        (setq aPt (mt:get-conn-pt eA "A"))
        (setq nearestB (mt:nearest aPt bList))
        (if (and nearestB (<= (distance aPt (cdr nearestB)) maxd))
          (entmake (list (cons 0 "LINE") (cons 10 aPt) (cons 11 (cdr nearestB))))))
      (prompt "\nCONNECT_AB: done.") (princ))))
