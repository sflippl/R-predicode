#' Stopping rules
#'
#' This small function helps to instantiate stopping rules in an intuitive way.
#'
#' @param max_iterations What is the maximum number of iterations?
#' @param stopping_distance At what distance should the algorithm stop?
#'
#' @export

stopping_rule <- function(max_iterations, stopping_distance = 0) {
    checkmate::assert_number(stopping_distance, na.ok = FALSE, lower = 0)
    checkmate::assert_number(max_iterations, na.ok = FALSE, lower = 0)
    assertthat::assert_that(rlang::is_integerish(max_iterations),
                            max_iterations != Inf | stopping_distance > 0)
    stopping_rule <- c(max_iterations = max_iterations,
                       stopping_distance = stopping_distance)
    class(stopping_rule) <- c("stopping_rule", class(stopping_rule))
    stopping_rule
}

#' @rdname stopping_rule
#'
#' @param x an object.
#'
#' @export

is_stopping_rule <- function(x) {
    inherits(x, "stopping_rule")
}

#' @rdname stopping_rule
#'
#' @param stopping_rule A stopping rule.
#'
#' @export

max_iterations <- function(stopping_rule) {
    assertthat::assert_that(is_stopping_rule(stopping_rule))
    max_it <- stopping_rule["max_iterations"]
    names(max_it) <- NULL
    max_it
}

#' @rdname stopping_rule
#'
#' @param stopping_rule A stopping rule.
#'
#' @export

stopping_distance <- function(stopping_rule) {
    assertthat::assert_that(is_stopping_rule(stopping_rule))
    stop_dist <- stopping_rule["stopping_distance"]
    names(stop_dist) <- NULL
    stop_dist
}

#' @export

print.stopping_rule <- function(x, ...) {
    max_it <- max_iterations(x)
    stop_dist <- stopping_distance(x)
    or <- " or"
    if(max_it == Inf) {
        msg_it <- ""
        or <- ""
    }
    else msg_it <- glue::glue("\n               iterations > {max_it}",
                              .trim = FALSE)
    if(stop_dist == 0) {
        msg_dist <- ""
        or <- ""
    }
    else
        msg_dist <-
            glue::glue("\n               ",
                       "distance between the last two elements < {stop_dist}",
                       .trim = FALSE)
    msg <- glue::glue("Stopping rule: Stop if:{msg_it}{or}{msg_dist}.")
    print(msg, ...)
    invisible(x)
}
