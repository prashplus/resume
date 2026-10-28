#import "templates/lib.typ": load-resume
#import "templates/classic.typ": classic
#import "templates/modern.typ": modern

#let variant = sys.inputs.at("variant", default: "fullstack-1page")
#let cfg = yaml("/variants/" + variant + ".yaml")
#let data = load-resume(cfg)

#let templates = (classic: classic, modern: modern)
#(templates.at(cfg.at("template", default: "classic")))(data, cfg)
