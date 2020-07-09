ui <- fluidPage(
  useShinyjs(),
  includeCSS("www/style.css"),
  tags$script(src = "app.js"),
  tags$script(src = "fanfare.js"),
  
  titlePanel("Yahtzee!"),
  
  hidden(uiOutput("final_scores")),
  
  textInput("player_name", "Enter your name"),
  actionButton("ready", "Ready"),
  disabled(actionButton("start", "Start")),
  
  textOutput("all_players"),
  textOutput("player_turn"),
  
  # fluidRow(
  #   column(12, align = "center",
  #          disabled(
  #            checkboxGroupInput("dice_locks", NULL, inline = TRUE,
  #                               choiceValues = 1:5, choiceNames = c("", "", "", "", ""))
  #          )
  #   )
  # ),
  
  br(),
  
  # fluidRow(
  #   column(12, align = "center",
  #          h1(textOutput("lock_indication"))
  #   )
  # ),
  
  # fluidRow(
  #   column(12, align = "center",
  #          h1(textOutput("current_rolls"))
  #   )
  # ),
  
  br(),
  br(),
  
  fluidRow(id = "dice-box",
    #column(10, align = "center", offset = 1,
      tags$div(class = "dice",
               tags$div(js_die(1), class = "dice-div", id = "die1-div"),
               tags$div(js_die(2), class = "dice-div", id = "die2-div"),
               tags$div(js_die(3), class = "dice-div", id = "die3-div"),
               tags$div(js_die(4), class = "dice-div", id = "die4-div"),
               tags$div(js_die(5), class = "dice-div", id = "die5-div")
      #),
      
    )
  ),
  
  tags$script(src = "draggable.js"),
  
  
  br(),
  
  fluidRow(
    column(12, align = "center",
           disabled(actionButton("roll_dice", "Roll!"))
    )
  ),
  
  fluidRow(
    column(12, align = "center",
           textOutput("rolls_remaining")
    )
  ),
  
  #radioButtons("choose_score", NULL, 
  #             choices = c("Aces", "Twos", "Threes", "Fours", "Fives", "Sixes",
  #                         "Three of a Kind", "Four of a Kind", "Full House",
  #                         "Low Straight", "High Straight", "Yahtzee", "Chance")),
  
  br(),
  hr(),
  
  fluidRow(
    column(6, align = "center", disabled(checkboxInput("aces", "Aces"))),
    column(6, align = "center", textOutput("aces_score"))
  ),
  fluidRow(
    column(6, align = "center", disabled(checkboxInput("twos", "Twos"))),
    column(6, align = "center", textOutput("twos_score"))
  ),
  fluidRow(
    column(6, align = "center", disabled(checkboxInput("threes", "Threes"))),
    column(6, align = "center", textOutput("threes_score"))
  ),
  fluidRow(
    column(6, align = "center", disabled(checkboxInput("fours", "Fours"))),
    column(6, align = "center", textOutput("fours_score"))
  ),
  fluidRow(
    column(6, align = "center", disabled(checkboxInput("fives", "Fives"))),
    column(6, align = "center", textOutput("fives_score"))
  ),
  fluidRow(
    column(6, align = "center", disabled(checkboxInput("sixes", "Sixes"))),
    column(6, align = "center", textOutput("sixes_score"))
  ),
  fluidRow(
    column(6, align = "center", disabled(checkboxInput("three_of_a_kind", "Three of a Kind"))),
    column(6, align = "center", textOutput("three_of_a_kind_score"))
  ),
  fluidRow(
    column(6, align = "center", disabled(checkboxInput("four_of_a_kind", "Four of a Kind"))),
    column(6, align = "center", textOutput("four_of_a_kind_score"))
  ),
  fluidRow(
    column(6, align = "center", disabled(checkboxInput("full_house", "Full House"))),
    column(6, align = "center", textOutput("full_house_score"))
  ),
  fluidRow(
    column(6, align = "center", disabled(checkboxInput("low_straight", "Low Straight"))),
    column(6, align = "center", textOutput("low_straight_score"))
  ),
  fluidRow(
    column(6, align = "center", disabled(checkboxInput("high_straight", "High Straight"))),
    column(6, align = "center", textOutput("high_straight_score"))
  ),
  fluidRow(
    column(6, align = "center", disabled(checkboxInput("yahtzee", "Yahtzee"))),
    column(6, align = "center", textOutput("yahtzee_score"))
  ),
  fluidRow(
    column(6, align = "center", disabled(checkboxInput("chance", "Chance"))),
    column(6, align = "center", textOutput("chance_score"))
  ),
  hr(),
  # fluidRow(
  #   column(6),
  #   column(6, textOutput("score"))
  # ),
  
  #textOutput("turn_score"),
  br(),
  
  fluidRow(
    column(12, align = "center",
           disabled(actionButton("next_turn", "Next Turn"))
    )
  )
)

