// Two-column layout: coloured sidebar (photo, contact, skills, education) + main column.
#import "lib.typ": *

#let modern(data, cfg) = {
  let accent = rgb(cfg.at("accent_color", default: "#1f4e79"))
  let b = data.basics
  let sidebar-w = 6cm
  set document(title: b.name + " — Resume", author: b.name)
  set page(
    paper: cfg.at("paper", default: "a4"),
    margin: (left: sidebar-w + 0.8cm, right: 1.2cm, y: 1.2cm),
    background: place(left + top, rect(width: sidebar-w, height: 100%, fill: accent.lighten(90%))),
  )
  set text(font: cfg.at("font", default: "Helvetica"), size: cfg.at("font_size", default: 9.5) * 1pt, lang: "en")
  set par(leading: 0.5em)
  show link: set text(fill: accent)

  let side-sections = cfg.at("sidebar_sections", default: ("skills", "education", "certifications", "awards"))
  let sidebar = {
    set text(size: 8.5pt)
    if cfg.at("photo", default: false) {
      align(center, box(clip: true, radius: 50%, image(b.photo, width: 3.4cm, height: 3.4cm, fit: "cover")))
      v(6pt)
    }
    text(size: 10pt, weight: "bold", fill: accent, "CONTACT")
    v(-4pt)
    for c in contact-items(b) { block(below: 4pt, c) }
    for s in side-sections {
      if s == "skills" {
        section("Skills", accent)
        for sk in data.skills { block(below: 5pt)[*#sk.category* \ #sk.items.join(", ")] }
      } else if s == "education" {
        section("Education", accent)
        for e in data.education { block(below: 6pt)[*#e.degree* \ #e.org \ #text(style: "italic", (dates(e), e.at("score", default: "")).filter(x => x != "").join(" · "))] }
      } else if s == "certifications" {
        section("Certifications", accent)
        for c in data.certifications { block(below: 5pt)[*#c.name* \ #c.issuer #c.at("date", default: "")] }
      } else if s == "awards" {
        section("Awards", accent)
        for a in data.awards { block(below: 5pt)[*#a.name* \ #a.at("date", default: "")] }
      }
    }
  }
  // Sidebar is placed on the first page only; the main column flows across pages.
  place(left + top, dx: -sidebar-w - 0.4cm, dy: 0cm, block(width: sidebar-w - 0.8cm, sidebar))

  text(size: 24pt, weight: "bold", b.name)
  linebreak()
  text(size: 13pt, fill: accent, data.profile.headline)
  v(4pt)
  let main = cfg.at("sections", default: default-sections).filter(s => not side-sections.contains(s))
  for s in main { render-section(s, data, accent) }
}
