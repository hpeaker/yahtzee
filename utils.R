roll_dice <- function(n = 1) {
  sample(6, n, replace = TRUE)
}

yahtzee <- function(rolls) {
  if(all(rolls == rolls[1])) {
    return(50)
  } else {
    return(0)
  }
}

four_of_a_kind <- function(rolls) {
  if(any(table(rolls) >= 4)) {
    return(sum(rolls))
  } else {
    return(0)
  }
}

three_of_a_kind <- function(rolls) {
  if(any(table(rolls) >= 3)) {
    return(sum(rolls))
  } else {
    return(0)
  }
}

full_house <- function(rolls) {
  if(length(setdiff(table(rolls), c(2, 3))) == 0) {
    return(25)
  } else {
    return(0)
  }
}

low_straight <- function(rolls) {
  if(all(c(1,2,3,4) %in% rolls) || all(c(2,3,4,5) %in% rolls) || all(c(3,4,5,6) %in% rolls)) {
    return(30)
  } else {
    return(0)
  }
}

high_straight <- function(rolls) {
  if(all(c(1,2,3,4,5) %in% rolls) || all(c(2,3,4,5,6) %in% rolls)) {
    return(40)
  } else {
    return(0)
  }
}

chance <- function(rolls) {
  sum(rolls)
}

ones <- function(rolls) {
  sum(rolls == 1) * 1
}

twos <- function(rolls) {
  sum(rolls == 2) * 2
}

threes <- function(rolls) {
  sum(rolls == 3) * 3
}

fours <- function(rolls) {
  sum(rolls == 4) * 4
}

fives <- function(rolls) {
  sum(rolls == 5) * 5
}

sixes <- function(rolls) {
  sum(rolls == 6) * 6
}
