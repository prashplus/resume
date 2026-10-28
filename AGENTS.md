# AGENTS.md

Guide for AI agents (and humans) editing this resume repo.

## How it works
- **Content** lives once in `data/*.yaml`. Never put resume text in templates.
- **Variants** (`variants/<name>.yaml`) choose template, profile, photo, tag filter, limits, section order, colour.
- **Templates** (`templates/*.typ`, Typst) only handle layout. `main.typ` loads the variant given by `--input variant=<name>`.
- **Build**: `./build.sh` (all) or `./build.sh <variant> ...` → `out/YYYY-MM-DD/Prashant_Piprotar_<variant>_YYYY-MM-DD.pdf`.
  Same-day rebuilds overwrite. `out/` is committed to git on purpose (download by date).
- Typst 0.13.1 is required (`typst` on PATH; locally it may be at `~/.local/bin/typst`).

## Common edits
| Task | Where |
|---|---|
| Contact info / links / photo | `data/basics.yaml`, `assets/photo.jpg` |
| Headline + summary per role | `data/profiles.yaml` (keys: `fullstack`, `backend`, `ai-ml`) |
| Job bullets | `data/experience.yaml` |
| Projects | `data/projects.yaml` |
| Skills | `data/skills.yaml` |
| Education / certs / awards / languages | `data/education.yaml`, `certifications.yaml`, `awards.yaml`, `languages.yaml` |
| New tailored resume | copy a file in `variants/`, edit, run `./build.sh <name>` |
| New profile (e.g. `frontend`) | add key in `profiles.yaml`, tag bullets/projects with it, create variant(s) |

## Tagging rules
- Bullets in `experience.yaml` and entries in `projects.yaml` have `tags`.
- A variant's `tags: [backend]` shows only items tagged `backend` **or** `core`; `tags: []` shows everything.
- `core` = always shown. Order in YAML = order on the page (put strongest bullets first; `max_bullets_per_role` truncates from the end).
- Skills categories without `tags` always show; with `tags` they follow the same filter.
- Education entries with `minor: true` (school) only show when the variant sets `include_school: true`.

## Writing style (ATS-friendly)
- Bullets: strong past-tense verb → what you built → measurable result. One sentence, ~1–2 lines.
- Use full titles ("Senior Software Engineer", not "Sr.") and spell out acronyms once (e.g. "Bill of Materials (BOM)").
- Name concrete technologies in bullets/skills so keyword matching works. Never invent metrics or skills; ask the user.
- Avoid filler ("significantly", "rigorous", "spearheaded"), tables/columns for key content, and text inside images.
- Keep standard section names: Professional Summary, Work Experience, Skills, Projects, Education, Certifications.

## Verify after every change
1. `./build.sh` succeeds without errors.
2. Page counts: `*-1page` must be exactly 1 page, `*-2page*` exactly 2:
   `for f in out/$(date +%F)/*.pdf; do echo "$f $(mdls -raw -name kMDItemNumberOfPages "$f")"; done`
   If a 1-page overflows: lower `max_bullets_per_role` / `max_projects` / `max_bullets_per_project` or `font_size` (min 9) in the variant.
3. Optionally render PNGs to eyeball layout: `typst compile --root . --input variant=<name> main.typ /tmp/<name>-{p}.png`.
4. Stage regenerated PDFs together with the source changes.
