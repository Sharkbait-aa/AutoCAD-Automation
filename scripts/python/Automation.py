from pyautocad import Autocad, APoint

acad = Autocad(create_if_not_exists=True)
p = APoint(0, 0)
acad.model.AddPoint(p)
t = acad.model.AddText("Hello Mason", APoint(0, 5), 2.5)
print("Inserted:", p, t)
