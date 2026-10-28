# Resume

Modular resume: content lives once in `data/*.yaml`, each PDF variant is a small file in `variants/`, rendered with [Typst](https://typst.app).

## Build
```bash
# install typst: https://github.com/typst/typst/releases (or `brew install typst`)
./build.sh                    # all variants -> out/YYYY-MM-DD/ (re-running same day overwrites)
./build.sh fullstack-1page    # one variant
typst watch --root . --input variant=fullstack-1page main.typ out/preview.pdf   # live preview
```

## Layout
| Path | Purpose |
|---|---|
| `data/basics.yaml` | name, contact, links, photo |
| `data/profiles.yaml` | headline + summary per profile (`fullstack`, `backend`, `ai-ml`) |
| `data/experience.yaml`, `projects.yaml` | entries; bullets/projects carry `tags` used for filtering (`core` = always shown) |
| `data/skills.yaml`, `education.yaml`, `certifications.yaml`, `awards.yaml` | other sections |
| `templates/classic.typ` | single-column, ATS-friendly |
| `templates/modern.typ` | two-column sidebar, optional photo |
| `variants/*.yaml` | one file per PDF |

## Variant options
```yaml
template: classic | modern
profile: fullstack            # key in data/profiles.yaml
photo: true | false
tags: [backend]               # [] = include everything
max_bullets_per_role: 3
max_projects: 2
max_bullets_per_project: 2
include_school: false         # include X / XII
sections: [summary, experience, skills, projects, education, certifications, awards]
sidebar_sections: [skills, education, certifications, awards]   # modern only
accent_color: "#1f4e79"
font: Helvetica
font_size: 9.5
paper: a4 | us-letter
```
New tailored resume = copy a variant, tweak a few fields, run `./build.sh <name>`.
