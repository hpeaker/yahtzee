library(shiny)
library(shinyjs)
library(purrr)
library(magrittr)

source("utils.R")
source("shiny_funs.R")

global_vals <- reactiveValues(dice = rep("_", 5),
                              locks = c(),
                              players = c(),
                              scores = c(),
                              player_turn = "",
                              in_progress = FALSE,
                              players_done = c(),
                              game_over = FALSE,
                              rolls_remaining = 0)

score_ids <- c("aces", "twos", "threes", "fours", "fives", "sixes", "three_of_a_kind",
               "four_of_a_kind", "full_house", "low_straight", "high_straight", "yahtzee",
               "chance")

lock_ids <- c("lock1", "lock2", "lock3", "lock4", "lock5")