

updateCheckboxInputs <- function(session, inputIds, value = NULL) {
  inputIds %>% walk(~ updateCheckboxInput(session = session, value = value, inputId = .))
}

disable_all <- function(ids) {
  ids %>% walk(disable)
}

enable_all <- function(ids) {
  ids %>% walk(enable)
}



js_die <- function(n) {
  parity <- if((n %% 2) == 0) {
    "even"
  } else {
    "odd"
  }
  tagList(
    checkboxInput(paste0("lock", n), "", width = "0px"),
  tags$ol(class = paste0("die-list ", parity, "-roll"), `data-roll` = "1", id = paste0("die-", n),
    tags$li(class = "die-item", `data-side` = "1",
      tags$span(class = "dot")
    ),
    tags$li(class = "die-item", `data-side` = "2",
      tags$span(class = "dot"),
      tags$span(class = "dot")
    ),
    tags$li(class = "die-item", `data-side` = "3",
      tags$span(class = "dot"),
      tags$span(class = "dot"),
      tags$span(class = "dot")
    ),
    tags$li(class = "die-item", `data-side` = "4",
      tags$span(class = "dot"),
      tags$span(class = "dot"),
      tags$span(class = "dot"),
      tags$span(class = "dot")
    ),
    tags$li(class = "die-item", `data-side` = "5",
      tags$span(class = "dot"),
      tags$span(class = "dot"),
      tags$span(class = "dot"),
      tags$span(class = "dot"),
      tags$span(class = "dot")
    ),
    tags$li(class = "die-item", `data-side` = "6",
      tags$span(class = "dot"),
      tags$span(class = "dot"),
      tags$span(class = "dot"),
      tags$span(class = "dot"),
      tags$span(class = "dot"),
      tags$span(class = "dot")
    )
  )
  )
}
