// Data loading + filtering shared by all templates.

#let matches(item-tags, wanted) = {
  if wanted == none or wanted.len() == 0 { return true }
  let t = if item-tags == none { () } else { item-tags }
  t.contains("core") or t.any(x => wanted.contains(x))
}

#let take(arr, n) = if n == none { arr } else { arr.slice(0, calc.min(n, arr.len())) }

#let load-resume(cfg) = {
  let tags = cfg.at("tags", default: ())
  let profiles = yaml("/data/profiles.yaml")
  let profile = profiles.at(cfg.at("profile", default: "fullstack"))
  let max-b = cfg.at("max_bullets_per_role", default: none)

  let experience = yaml("/data/experience.yaml").map(role => {
    role.bullets = take(role.bullets.filter(b => matches(b.at("tags", default: none), tags)).map(b => b.text), max-b)
    role
  })
  let projects = take(
    yaml("/data/projects.yaml").filter(p => matches(p.at("tags", default: none), tags)).map(p => {
      p.bullets = take(p.bullets, cfg.at("max_bullets_per_project", default: none))
      p
    }),
    cfg.at("max_projects", default: none),
  )
  let skills = yaml("/data/skills.yaml").filter(s => s.at("tags", default: none) == none or matches(s.tags, tags))
  let education = yaml("/data/education.yaml").filter(e => cfg.at("include_school", default: false) or not e.at("minor", default: false))

  (
    basics: yaml("/data/basics.yaml"),
    profile: profile,
    experience: experience,
    projects: projects,
    skills: skills,
    education: education,
    certifications: yaml("/data/certifications.yaml"),
    awards: yaml("/data/awards.yaml"),
  )
}

#let default-sections = ("summary", "experience", "skills", "projects", "education", "certifications", "awards")

#let dates(x) = {
  if "start" in x { x.start + " – " + x.end } else { x.at("date", default: "") }
}

// ---------- Shared building blocks ----------

#let section(title, accent) = block(above: 9pt, below: 5pt, sticky: true, {
  text(size: 1.15em, weight: "bold", fill: accent, upper(title))
  v(-0.75em)
  line(length: 100%, stroke: 0.6pt + accent)
})

#let entry(left-title, left-sub, right-top, right-bottom, bullets) = block(breakable: true, below: 7pt)[
  #grid(
    columns: (1fr, auto),
    row-gutter: 3pt,
    text(weight: "bold", left-title), align(right, text(size: 9pt, right-top)),
    text(style: "italic", left-sub), align(right, text(size: 9pt, style: "italic", right-bottom)),
  )
  #if bullets.len() > 0 {
    v(-2pt)
    list(spacing: 4pt, indent: 4pt, ..bullets)
  }
]

#let render-section(name, data, accent) = {
  if name == "summary" {
    section("Professional Summary", accent)
    par(justify: true, data.profile.summary)
  } else if name == "experience" {
    section("Work Experience", accent)
    for r in data.experience { entry(r.title, r.org, dates(r), r.at("location", default: ""), r.bullets) }
  } else if name == "projects" and data.projects.len() > 0 {
    section("Projects", accent)
    for p in data.projects {
      let sub = (p.at("org", default: none), p.stack).filter(x => x != none).join(" | ")
      entry(p.name, sub, p.at("date", default: ""), "", p.bullets)
    }
  } else if name == "education" {
    section("Education", accent)
    for e in data.education { entry(e.degree, e.org, dates(e), e.at("score", default: ""), ()) }
  } else if name == "skills" {
    section("Skills", accent)
    for s in data.skills { block(below: 4pt)[*#s.category:* #s.items.join(", ")] }
  } else if name == "certifications" {
    section("Certifications", accent)
    for c in data.certifications {
      block(below: 5pt, grid(columns: (1fr, auto), [*#c.name* — #c.issuer], text(size: 9pt, c.at("date", default: ""))))
    }
  } else if name == "awards" {
    section("Awards & Scholarships", accent)
    for a in data.awards { grid(columns: (1fr, auto), [*#a.name*], text(size: 9pt, a.at("date", default: ""))) }
  }
}

#let contact-items(b) = {
  (link("mailto:" + b.email, b.email), b.phone, b.location) + b.links.map(l => link(l.url, l.label))
}
