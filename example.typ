#import "usyd_polylux_theme.typ": *

#show: usyd-theme.with(
  short-author: "Juraph",
  short-title: "Demo of Typst capabilities",
  short-date: "24th Jul, 2024"
)
#set text(font: "Arial", fallback: false)

#set par(justify: true)

#title-slide(
  authors: [Juraph, author2, author3, author4],
  title: "University of Sydney Typst Presentation theme",
  subtitle: "Powered by Polylux",
  // date: datetime.today().display() // Use this to display current date
  date: "24th July 2024"
)

#usyd-pres-outline()

#slide(new-section: "Example maths")[
  Demonstrating some mathematics:
  $frac(d, d t) (frac(partial L, partial dot(q)_i)) - frac(partial L, partial q_i) = tau$
  $ overline(delta) = 1/2 z_"b"(t_"bt") + (m_"b" g)/k - ((m_"b" + m_"l")^2)/(k m_"b" z_"b"(t_"bt")) g h $
    $ mat(delim: "[", dot.double(x); dot.double(theta)) =
    mat(delim: "[", (m_p sin(theta) (l dot(theta)^2 + g cos(theta))) / (m_c + m_p sin^2(theta)) ;
  (-f_x cos(theta) - m_p l dot(theta)^2 cos(theta) sin(theta) - (m_c + m_p) g sin(theta)) / (l (m_c + m_p sin^2(theta)))
) + mat(delim: "[", 1; 0) f_x $
]

#slide(title: "Example title", new-section: "Demonstration of blocks")[
  #usyd-info-block(title: "Info", "info block")
    #usyd-example-block(title: "Example", "example block")
    #usyd-alert-block(title: "Alert", "alert block")
    Blocks are schemed to usyd themes.
]

#new-section-slide("Break slide to introduce new section")

#slide(title: "Continuation of new section")[
    Note the progress of sections in the header
]

#slide(title: "Example title",new-section: "sect 3")[
    Blank slides to show progress bar in header
]
#slide(title: "Example title", new-section: "sect 4")[
    Blank slides to show progress bar in header
]
#slide(new-section: "sect 5")[
    Blank slides to show progress bar in header
]
#slide(new-section: "sect 6")[
    Blank slides to show progress bar in header
]
#slide(new-section: "sect 7")[
    Blank slides to show progress bar in header
]

#focus-slide[
    Thanks for checking this theme out!
    #parbreak()
    Please feel free to propose changes/improvements.
]
