# Usage

1) In AutoCAD, run APPLOAD → load `scripts/autolisp/mt-hello.lsp`
2) In the command line, type `MTHELLO`
3) You should see: “Hello from Mason's AutoCAD automation!”

## Load AutoLISP
1. In AutoCAD, open **APPLOAD**.
2. Browse to `scripts/autolisp/yourfile.lsp` and load.
3. Optionally add to Startup Suite for auto-load.

## Python (COM/PyAutoCAD)
```
pip install -r scripts/python/requirements.txt
python scripts/python/example.py
```

## .NET Plugin
- Open the solution in `scripts/.net/` and build. Artifacts should land in `dist/`.
