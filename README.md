# AutoCAD Automation

Open-source repository for automating AutoCAD workflows with scripts, reusable blocks, templates, and plugins.  
The goal is to provide repeatable, efficient, and scalable CAD automation solutions using AutoLISP, Python, and .NET extensions.


# AutoCAD Automation Toolkit

A structured repository for AutoCAD automation (scripts, blocks, templates) and supporting code (e.g., Python/.NET/AutoLISP).

## Quick start

```bash
# 1) Create the repo on GitHub (empty repo, **no** README/.gitignore/license)
# 2) Initialize locally
git init
git remote add origin <YOUR_REPO_URL>

# 3) Install Git LFS (one time on each machine)
#    Download from https://git-lfs.com/ or use your package manager
git lfs install

# 4) Track AutoCAD binaries with LFS
git lfs track "*.dwg" "*.dwt" "*.dws" "*.dxf" "*.rvt" "*.nwd" "*.nwf" "*.nwc" "*.iam" "*.ipt" "*.idw" "*.sv$" "*.bak"

# 5) Add & commit
git add .gitattributes .gitignore README.md /blocks /templates /scripts /docs /samples
git commit -m "chore: bootstrap AutoCAD automation repo"
git branch -M main
git push -u origin main
```

> ⚠️ **IP caution**: If your work is for an employer/client, verify what can be published. Use a private repo if needed.

## Repo layout

```
.
├─ blocks/           # Reusable DWG/DWT blocks, dynamic blocks, attributed blocks
├─ templates/        # CAD templates (DWT), standards files (DWS), title blocks
├─ scripts/          # Automation code
│  ├─ autolisp/      # .lsp, .fas
│  ├─ python/        # PyAutoCAD/COM, CAD APIs, CLI tools
│  ├─ .net/          # C# plugins (Acad .NET), source & build scripts
│  └─ bluebeam/      # (optional) Bluebeam scripts/macros supporting workflow
├─ docs/             # Screenshots, GIFs, specs, how-tos
├─ samples/          # Sample drawings to test automation
├─ tests/            # Unit/integration tests for code (where applicable)
├─ dist/             # Built plugins/installers (artifacts, ignored by git)
└─ tools/            # Helper utilities, fonts, linestyles, plot styles (.ctb/.stb)
```

## Scripts & automation

- **AutoLISP**: place `.lsp` in `scripts/autolisp/`. Add load instructions to `docs/Usage.md`.
- **Python**: COM/PyAutoCAD scripts live in `scripts/python/`. See `scripts/python/requirements.txt`.
- **.NET**: C# plugin projects in `scripts/.net/`. Provide a `build.ps1` that emits to `dist/`.

## Conventions

- **Branches**: `main` (stable), `develop` (integration), feature branches `feat/<short-name>`.
- **Commits**: Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:` ...).
- **CAD standards**: Store CTB/STB, fonts, linetypes in `tools/` and reference from templates.

## Ignore rules

Large/binary CAD and generated files are ignored, with LFS for specific binaries. See `.gitignore` and `.gitattributes`.

## Releasing

1. Update `CHANGELOG.md`.
2. Build plugins/scripts to `dist/`.
3. Tag a release:
   ```bash
   git tag -a vX.Y.Z -m "Release notes"
   git push origin --tags
   ```

## Security & secrets

- **Never** commit API keys or server addresses. Use `.env` files or GitHub Secrets.
- If you accidentally commit secrets, rotate them immediately and use `git filter-repo` or GitHub's secret scanning guidance to purge history.

## License

This starter uses the MIT License by default. Change it if needed.
