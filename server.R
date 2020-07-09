
server <- function(input, output, session) {
  
  sub_scores <- reactiveValues(aces = -1, twos = -1, threes = -1, fours = -1, fives = -1, sixes = -1,
                               three_of_a_kind = -1, four_of_a_kind = -1, full_house = -1,
                               low_straight = -1, high_straight = -1, yahtzee = -1, chance = -1)
  #score <- reactiveVal(value = 0)
  roll_number <- reactiveVal(value = 0)
  remaining_scores <- reactiveVal(value = score_ids)
  completed_scores <- reactiveVal(value = c())
  
  dice_locks <- reactive({
    which(c(input$lock1, input$lock2, input$lock3, input$lock4, input$lock5))
  })
  
  unlocked_dice <- reactive({
    i <- dice_locks()
    setdiff(1:5, i)
  })
  
  n_unlocked_dice <- reactive({
    length(unlocked_dice())
  })
  
  observe({
    i <- input$ready
    if(i > 0) {
      isolate(global_vals$players <- c(global_vals$players, input$player_name))
      disable("player_name")
      disable("ready")
      isolate({
        if(length(global_vals$players) == 1) {
          enable("start")
        }
      })
    }
  })
  
  observe({
    i <- input$start
    if(i > 0) {
      isolate({
        global_vals$player_turn <- global_vals$players[1]
        disable("start")
        global_vals$in_progress <- TRUE
        global_vals$scores <- rep(0, length(global_vals$players))
        names(global_vals$scores) <- global_vals$players
      })
    }
  })
  
  observe({
    in_progress <- global_vals$in_progress
    if(in_progress) {
      hide("ready")
      hide("start")
      hide("player_name")
    }
  })
  
  output$all_players <- renderText({
    paste("Playing:", paste(global_vals$players, collapse = ", "))
  })
  
  output$player_turn <- renderText({
    paste("Turn:", global_vals$player_turn)
  })
  
  # observe({
  #   i <- input$roll_js_dice
  #   if(i > 0) {
  #     #print("roll")
  #     session$sendCustomMessage("roll-dice", i)
  #   }
  # })
  
  observe({
    values <- global_vals$dice
    indices <- isolate(unlocked_dice() - 1)
    message <- paste(paste(values, collapse = ""), paste(indices, collapse = ""))
    if(all(values %in% c("1", "2", "3", "4", "5", "6"))) {
      print(message)
      session$sendCustomMessage("update-dice", message)
    }
  })
  
  s_scores <- reactive({
    c(sub_scores$aces, sub_scores$twos, sub_scores$threes, sub_scores$fours,
      sub_scores$fives, sub_scores$sixes, sub_scores$three_of_a_kind,
      sub_scores$four_of_a_kind, sub_scores$full_house,
      sub_scores$low_straight, sub_scores$high_straight,
      sub_scores$yahtzee, sub_scores$chance)
  })
  
  bonus_score <- reactive({
    number_scores <- c(sub_scores$aces, sub_scores$twos, sub_scores$threes, sub_scores$fours,
      sub_scores$fives, sub_scores$sixes)
    
    if(sum(number_scores) >= 63) {
      return(35)
    } else {
      return(0)
    }
  })
  
  score <- reactive({
    sum(s_scores()[s_scores() >= 0]) + bonus_score()
  })
  
  output$score <- renderText({
    score()
  })
  
  observe({
    global_vals$locks <- input$dice_locks
  })
  
  output$lock_indication <- renderText({
    x <- rep("_", 5)
    x[as.numeric(global_vals$locks)] <- "x"
    return(paste(x, collapse = " "))
  })
  
  observe({
    input$roll_dice
    if(input$roll_dice > 0) {
      isolate({
        # roll the unlocked dice
        global_vals$dice[unlocked_dice()] <- roll_dice(n = n_unlocked_dice())
        # update the roll number
        new_roll_number <- roll_number() + 1
        roll_number(new_roll_number)
      })
    }
  })
  
  observe({
    rn <- roll_number()
    current_player <- global_vals$player_turn
    if(length(current_player) == 0) {
      return()
    }
    isolate({
      if(current_player == input$player_name && global_vals$in_progress) {
        if(rn == 0) {
          disable_all(lock_ids)
          disable_all(score_ids)
        } else {
          enable_all(lock_ids)
          enable_all(remaining_scores())
        }
        if(rn == 3) {
          disable("roll_dice")
          #enable("next_turn")
        } else {
          enable("roll_dice")
          disable("next_turn")
        }
      } else {
        disable_all(lock_ids)
        disable("next_turn")
        disable_all(score_ids)
        disable("roll_dice")
      }
    })
  })
  
  observe({
    nt <- input$next_turn
    if(is.null(nt)) {
      return()
    }
    if(nt == 0) {
      return()
    }
    isolate({
      if(!(input$player_name %in% global_vals$players_done)) {
        # update player sub scores
        isolate(sub_scores[[choose_score_id()]] <- turn_score())
        # update total score
        isolate(global_vals$scores[[input$player_name]] <- score())
        # reset roll count
        roll_number(0)
        # reset locks and rolls
        global_vals$dice <- c("_", "_", "_", "_", "_")
        updateCheckboxInput(session, "lock1", value = FALSE)
        updateCheckboxInput(session, "lock2", value = FALSE)
        updateCheckboxInput(session, "lock3", value = FALSE)
        updateCheckboxInput(session, "lock4", value = FALSE)
        updateCheckboxInput(session, "lock5", value = FALSE)
        # un-select score choices
        updateCheckboxInputs(session, score_ids, FALSE)
        # update remaining and completed scores
        isolate(completed_scores(c(completed_scores(), choose_score_id())))
        isolate(remaining_scores(remaining_scores()[remaining_scores() != choose_score_id()]))
        # move to next player
        isolate({
          l <- length(global_vals$players)
          cur_i <- which(global_vals$players == global_vals$player_turn)
          next_i <- (cur_i + 1) %% l
          if(next_i == 0) {next_i <- l}
          global_vals$player_turn <- global_vals$players[next_i]
        })
        # check if all scores are filled
        if(all(s_scores() >= 0)) {
          isolate(global_vals$players_done <- c(global_vals$players_done, input$player_name))
        }
        # If all players done show final scores and play fanfare
        isolate({
          if(length(global_vals$players_done) == length(global_vals$players)) {
            global_vals$game_over <- TRUE
            session$sendCustomMessage("fanfare", "")
          }
        })
      }
    })
  })
  
  observe({
    if(global_vals$game_over) {
      show("final_scores")
    }
  })
  
  output$final_scores <- renderUI({
    ord <- order(global_vals$scores)
    scores <- global_vals$scores
    nms <- names(global_vals$scores)
    first_score <- scores[ord == 1]
    first_name <- nms[ord == 1]
    second_score <- scores[ord == 2]
    second_name <- nms[ord == 2]
    third_score <- scores[ord == 3]
    third_name <- nms[ord == 3]
    the_rest_scores <- scores[ord >= 4]
    the_rest_names <- nms[ord >= 4]
    tagList(
      h1(paste(first_name, first_score)),
      h2(paste(second_name, second_score)),
      h3(paste(third_name, third_score)),
      h5(paste(the_rest_names, the_rest_scores))
    )
  })
  
  choose_score <- reactive({
    x <- c(input$aces, input$twos, input$threes, input$fours, input$fives, input$sixes,
           input$three_of_a_kind, input$four_of_a_kind, input$full_house,
           input$low_straight, input$high_straight, input$yahtzee, input$chance)
    
    return(c("Aces", "Twos", "Threes", "Fours", "Fives", "Sixes", "Three of a Kind",
             "Four of a Kind", "Full House", "Low Straight", "High Straight", "Yahtzee",
             "Chance")[x])
  })
  
  choose_score_id <- reactive({
    x <- c(input$aces, input$twos, input$threes, input$fours, input$fives, input$sixes,
           input$three_of_a_kind, input$four_of_a_kind, input$full_house,
           input$low_straight, input$high_straight, input$yahtzee, input$chance)
    
    return(c("aces", "twos", "threes", "fours", "fives", "sixes", "three_of_a_kind",
             "four_of_a_kind", "full_house", "low_straight", "high_straight", "yahtzee",
             "chance")[x])
  })
  
  observe({
    if(roll_number() > 0 && !is.null(scoring_function()(c(1,1,1,1,1)))) {
      enable("next_turn")
    } else {
      disable("next_turn")
    }
  })
  
  
  scoring_function <- reactive({
    default_fun <- function(x) NULL
    score_choice <- choose_score()
    if(length(score_choice) != 1) {
      return(default_fun)
    }
    f <- switch(
      score_choice,
      "Aces" = ones,
      "Twos" = twos,
      "Threes" = threes,
      "Fours" = fours,
      "Fives" = fives,
      "Sixes" = sixes,
      "Three of a Kind" = three_of_a_kind,
      "Four of a Kind" = four_of_a_kind,
      "Full House" = full_house,
      "Low Straight" = low_straight,
      "High Straight" = high_straight,
      "Yahtzee" = yahtzee,
      "Chance" = chance
    )
    return(f)
  })
  
  turn_score <- reactive({
    scoring_function()(as.numeric(global_vals$dice))
  })
  
  observe({
    rn <- roll_number()
    current_player <- global_vals$player_turn
    isolate({
      if(current_player == input$player_name && global_vals$in_progress) {
        global_vals$rolls_remaining <- 3 - roll_number()
      }
    })
  })
  
  output$rolls_remaining <- renderText({
    paste("Rolls Remaining:", global_vals$rolls_remaining)
  })
  
  output$turn_score <- renderText({
    turn_score()
  })
  
  output$current_rolls <- renderText({
    paste(global_vals$dice, collapse = " ")
  })
  
  score_render <- function(id) {
    if(input[[id]]) {
      return(turn_score())
    } else if(isolate(sub_scores[[id]] >= 0)) {
      return(isolate(sub_scores[[id]]))
    } else {
      return(NULL)
    }
  }
  
  output$aces_score <- renderText(score_render("aces"))
  output$twos_score <- renderText(score_render("twos"))
  output$threes_score <- renderText(score_render("threes"))
  output$fours_score <- renderText(score_render("fours"))
  output$fives_score <- renderText(score_render("fives"))
  output$sixes_score <- renderText(score_render("sixes"))
  
  output$three_of_a_kind_score <- renderText(score_render("three_of_a_kind"))
  output$four_of_a_kind_score <- renderText(score_render("four_of_a_kind"))
  output$full_house_score <- renderText(score_render("full_house"))
  output$low_straight_score <- renderText(score_render("low_straight"))
  output$high_straight_score <- renderText(score_render("high_straight"))
  output$yahtzee_score <- renderText(score_render("yahtzee"))
  output$chance_score <- renderText(score_render("chance"))
  
  checkbox_updates <- function(id) {
    if(input[[id]]) {
      isolate(updateCheckboxInputs(session, score_ids[score_ids != id], value = FALSE))
    }
  }
  
  observe(checkbox_updates("aces"))
  observe(checkbox_updates("twos"))
  observe(checkbox_updates("threes"))
  observe(checkbox_updates("fours"))
  observe(checkbox_updates("fives"))
  observe(checkbox_updates("sixes"))
  
  observe(checkbox_updates("three_of_a_kind"))
  observe(checkbox_updates("four_of_a_kind"))
  observe(checkbox_updates("full_house"))
  observe(checkbox_updates("low_straight"))
  observe(checkbox_updates("high_straight"))
  observe(checkbox_updates("yahtzee"))
  observe(checkbox_updates("chance"))
  
}


