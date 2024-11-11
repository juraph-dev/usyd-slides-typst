#import "@preview/polylux:0.3.1": *

// University of Sydney Typst Polylux theme
//
// By Juraph (github.com/juraph)
//
// Please feel free to improve this theme
// by submitting a PR.

#let s-white = rgb("#ffffff")
#let s-half-white = rgb("#E68673")
#let s-black = rgb("#000000")
#let s-ochre = rgb("#e64626")
#let s-charcoal = rgb("#424242")
#let s-sandstone = rgb("#FCEDE2")
#let s-light-gray = rgb("#F1F1F1")
#let s-rose = rgb("#DAA8A2")
#let s-jacaranda = rgb("#8F9EC9")
#let s-navy = rgb("#1A345E")
#let s-eucalypt = rgb("#71A399")

#let uni-short-title = state("uni-short-title", none)
#let uni-short-author = state("uni-short-author", none)
#let uni-short-date = state("uni-short-date", none)
#let uni-progress-bar = state("uni-progress-bar", true)


#set page(paper: "presentation-16-9")

#let usyd-outline(
  enum-args: (:),
  padding: 0pt,
  min-window-size: 3,
  max-length: 90pt,
) = locate(loc => { let sections = utils.sections-state.final(loc)
  let current-section = utils.sections-state.get()
  if current-section.len() == 0 {
    return
  }
  let current-index = sections.position(s => s == current-section.at(-1))

  // Calculate the window size based on section lengths. Kinda overkill
  // for a glorified powerpoint
  let window-size = sections.len()
  let total-length = sections
    .slice(0, window-size)
    .map(s => measure(s.body).width)
    .sum()

  while window-size > min-window-size and total-length > max-length {
    let start = calc.max(0, current-index - window-size / 2 + 1)
    let end = int(calc.min(sections.len(), start + window-size))
    start = calc.floor(calc.max(0, end - window-size))

    total-length = sections.slice(start, end).map(s => measure(s.body).width).sum()
    if total-length > max-length {
      window-size -= 1
    }
  }
  let start = calc.max(0, current-index - window-size / 2 + 1)
  let end = int(calc.min(sections.len(), start + window-size))
  start = calc.floor(calc.max(0, end - window-size))

  let visible-sections = sections.slice(start, end)

  pad(
    padding,
    box(
      width: 100%,
      align(center + horizon)[
        #grid(
          columns: visible-sections.len(),
          gutter: 1fr,
          ..visible-sections.enumerate().map(((i, section)) => {
            if section == current-section.at(-1) {
              text(fill: s-white, link(section.loc, section.body))
            } else {
              text(fill: s-half-white, link(section.loc, section.body))
            }
          })
        )
      ],
    ),
  )
})
)

#let usyd-rounded-block(radius: 3mm, body) = {
  block(
    radius: (
      bottom-left: radius,
      bottom-right: radius,
    ),
    clip: true,
    body,
  )
}

#let usyd-color-block(title: [], colour: [], body) = {
  usyd-rounded-block()[
    #block(
      width: 100%,
      inset: (x: 0.5em, top: 0.3em, bottom: 0.4em),
      fill: gradient.linear(
        (s-ochre, 0%),
        (s-ochre, 10%),
        (s-ochre, 100%),
        dir: ttb,
      ),
      text(fill: s-white, title),
    )
    #block(
      inset: 0.5em,
      above: 0pt,
      fill: colour,
      width: 100%,
        text(fill: s-black, body),
    )
  ]
}

#let usyd-info-block(title: [], body) = {
  usyd-color-block(title: title, colour: s-eucalypt, body)
}

#let usyd-example-block(title: [], body) = {
  usyd-color-block(title: title, colour: s-jacaranda, body)
}

#let usyd-alert-block(title: [], body) = {
  usyd-color-block(title: title, colour: s-rose, body)
}


#let usyd-theme(
  aspect-ratio: "16-9",
  short-title: none,
  short-author: none,
  short-date: none,
  progress-bar: true,
  body,
) = {
  set page(
    paper: "presentation-" + aspect-ratio,
    margin: 0em,
    header: none,
    footer: none,
  )

  show footnote.entry: set text(size: .9em, fill: s-charcoal)

  uni-progress-bar.update(progress-bar)
  uni-short-title.update(short-title)
  uni-short-author.update(short-author)
  if short-date != none {
    uni-short-date.update(short-date)
  } else {
    uni-short-date.update(datetime.today().display())
  }

  body
}

#let title-slide(
  title: [],
  subtitle: none,
  authors: (),
  date: none,
  logo: none,
  title_image: none,
) = {
  let authors = if type(authors) == "array" {
    authors
  } else {
    (authors,)
  }

    let bck_img = if title_image != none {
        title_image
    } else {
        "./figures/usyd.jpg"
    }

  let content = locate(loc => {
    grid(
      columns: (50%, 50%),
      block(
        fill: s-ochre,
        width: 100%,
        height: 100%,
        inset: (x: 3em),
        align(
          horizon,
          {
            block(
              breakable: false,
              {
                v(55pt)
                text(size: 28pt, fill: s-white, strong(title))
                if subtitle != none {
                  v(4pt)
                  text(size: 25pt, fill: s-black, subtitle)
                }
              },
            )
            v(44pt)
            set text(size: 15pt)
            grid(
              columns: (1fr,) * calc.min(authors.len(), 3),
              column-gutter: 1em,
              row-gutter: 1em,
              ..authors.map(author => strong(text(fill: s-charcoal, author)))
            )
            v(45pt)
            if date != none {
              parbreak()
              text(size: 14pt, date, fill: s-black)
            }
            v(60pt)
            image("./figures/usyd-long.png", width: 35%)
          },
        ),
      ),
      align(center, image(bck_img, height:100%)),
    )
  })
  logic.polylux-slide(content)
}


#let slide(
  title: none,
  footer: none,
  new-section: none,
  body,
) = {
  let body = pad(y:10pt, x: 60pt, body)

  let header-text = {

    let cell(fill: none, it) = rect(
      width: 100%,
      height: 100%,
      inset: (x: 6pt),
      outset: 0mm,
      fill: s-ochre,
      stroke: none,
      align(center + horizon, text(fill: s-black, it, size: 15pt)),
    )
    if new-section != none {
      utils.register-section(new-section)
    }
    locate(loc => {
      grid(
        columns: (30%, 70%),
        inset: (y: 4.5pt),
        align(center + horizon, image("./figures/usyd-long-white.png", height: 100%)),
        cell(usyd-outline()),
      )
    })
  }

  let header = {
    grid(rows: (auto), header-text)
  }

  let footer = {
    set text(size: 12pt)
    set align(center + horizon)
    if footer != none {
      footer
    } else {
      locate(loc => {
        grid(
          columns: (30%, 35%, 35%),
          rect(
            fill: s-ochre,
            inset: (y: 25%),
            width: 100%,
            height: 60%,
            uni-short-author.display(),
          ),
          align(
            left,
            block(
              fill: s-white,
              inset: (y: 25%, x: 5%),
              width: 100%,
              height: 100%,
              text(fill: s-charcoal, uni-short-title.display()),
            ),
          ),
          align(
            right,
            block(
              fill: s-white,
              inset: (y: 25%, x: 5%),
              width: 100%,
              height: 100%,
              text(fill: s-charcoal, uni-short-date.display()),
            ),
          ),
        )
      })
    }
  }


  set page(
    margin: (top: 50pt, bottom: 28pt),
    header: header,
    footer: footer,
    footer-descent: 0.0em,
    header-ascent: 6pt,
  )

  let content = locate(loc => {
    grid(inset: (x: 55pt, y: 11pt),
      rows: (10%, auto),
      align(
        horizon,
        strong(
          text(
            size: 28pt,
            title,
            fill: s-ochre,
          ),
        ),
      ),
      align(horizon, text(size: 15pt, fill: s-charcoal, body)))
  })
  logic.polylux-slide(content)
}

#let focus-slide(background-color: none, background-img: none, body) = {
  let background-color = if background-img == none and background-color == none {
    s-navy
  } else {
    background-color
  }

  set page(fill: background-color, margin: 1em) if background-color != none
  set page(
    background: {
      set image(fit: "stretch", width: 100%, height: 100%)
      background-img
    },
    margin: 1em,
  ) if background-img != none

  set text(fill: white, size: 2em)

  logic.polylux-slide(align(center + horizon, body))
}

#let matrix-slide(columns: none, rows: none, ..bodies) = {
  let bodies = bodies.pos()

  let columns = if type(columns) == "integer" {
    (1fr,) * columns
  } else if columns == none {
    (1fr,) * bodies.len()
  } else {
    columns
  }
  let num-cols = columns.len()

  let rows = if type(rows) == "integer" {
    (1fr,) * rows
  } else if rows == none {
    let quotient = calc.quo(bodies.len(), num-cols)
    let correction = if calc.rem(bodies.len(), num-cols) == 0 {
      0
    } else {
      1
    }
    (1fr,) * (quotient + correction)
  } else {
    rows
  }
  let num-rows = rows.len()

  if num-rows * num-cols < bodies.len() {
    panic("number of rows (" + str(num-rows) + ") * number of columns (" + str(num-cols) + ") must at least be number of content arguments (" + str(
      bodies.len(),
    ) + ")")
  }

  let cart-idx(i) = (calc.quo(i, num-cols), calc.rem(i, num-cols))
  let color-body(idx-body) = {
    let (idx, body) = idx-body
    let (row, col) = cart-idx(idx)
    let color = if calc.even(row + col) {
      white
    } else {
      silver
    }
    set align(center + horizon)
    rect(inset: .5em, width: 100%, height: 100%, fill: color, body)
  }

  let content = grid(
    columns: columns, rows: rows,
    gutter: 0pt,
    ..bodies.enumerate().map(color-body)
  )

  logic.polylux-slide(content)
}

#let usyd-pres-outline() = {
  set page(fill: s-charcoal, margin: 22pt)
  let content = locate(loc => {
    place(
      top + left,
      image("./figures/usyd-long-inv.png", height: 40pt),
    )
    set align(horizon)
    {
      show par: set block(spacing: 0em)
      set text(size: 3em, fill: s-white)
      let outline = utils.polylux-outline()
      let measured = measure(outline)
      let available-height = (page.height - 380pt)
      let scale-factor = calc.min(1, available-height / measured.height) * 100%

      scale(scale-factor, outline)
    }
  })
  logic.polylux-slide(content)
}

#let new-section-slide(name) = {

  set page(fill: s-charcoal, margin: 60pt)
  let content = locate(loc => {
    utils.register-section(name)

    place(
      top + left,
      image("./figures/usyd-long-inv.png", height: 40pt),
    )

    set align(center + horizon)
    {
      show par: set block(spacing: 0em)
      set text(size: 28pt, fill: white)
      strong(name)
      parbreak()
    }
  })
  logic.polylux-slide(content)
}
