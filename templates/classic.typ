// Single-column, ATS-friendly layout.
#import "lib.typ": *

#let classic(data, cfg) = {
  let accent = rgb(cfg.at("accent_color", default: "#1f4e79"))
  let b = data.basics
  set document(title: b.name + " — Resume", author: b.name)
  set page(paper: cfg.at("paper", default: "a4"), margin: (x: 1.3cm, y: 1cm))
  set text(font: cfg.at("font", default: "Helvetica"), size: cfg.at("font_size", default: 9.5) * 1pt, lang: "en")
  set par(leading: 0.5em)
  show link: set text(fill: accent)

  let header-text = {
    block(below: 6pt, text(size: 22pt, weight: "bold", b.name))
    block(below: 6pt, text(size: 12pt, fill: accent, data.profile.headline))
    text(size: 8.5pt, contact-items(b).join("  |  "))
  }
  if cfg.at("photo", default: false) {
    grid(columns: (auto, 1fr), column-gutter: 14pt, align: horizon,
      box(clip: true, radius: 50%, image(b.photo, width: 2.3cm, height: 2.3cm, fit: "cover")),
      header-text)
  } else {
    align(center, header-text)
  }

  for s in cfg.at("sections", default: default-sections) { render-section(s, data, accent) }
}
