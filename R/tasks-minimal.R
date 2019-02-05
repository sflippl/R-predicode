#' Minimal tasks
#'
#' A minimal task consists of an input and an output dataset. The estimation
#' of the output y according to a model is evaluated by the sum of
#' squares weighted by w.
#'
#' @param x Input data
#' @param y Output data
#' @param w Weights of the loss function
#'
#' @examples
#' x <- dplyr::transmute(cars, speed = scale(speed))
#' y <- dplyr::transmute(cars, dist = scale(dist))
#' minimal_task_1 <- minimal_task(x, y)
#' minimal_task_1
#'
#' @export

minimal_task <- function(x, y, w = rep(1, ncol(y))) {
    checkmate::assert_numeric(w, lower = 0, finite = TRUE, any.missing = FALSE)
    assertthat::assert_that(is.data.frame(x))
    assertthat::assert_that(is.data.frame(y))
    assertthat::assert_that(nrow(x) == nrow(y))
    assertthat::assert_that(length(w) == ncol(y))
    task <- list(x = x, y = y, w = w)
    class(task) <- c("minimal_task", "task", class(task))
    task
}

#' @describeIn minimal_task retrieves p, q and n
#'
#' @export

dim.minimal_task <- function(x) {
    p <-
        x %>%
        input() %>%
        ncol()
    q <-
        x %>%
        output() %>%
        ncol()
    n <- x %>%
        input() %>%
        nrow()
    c(p = p, q = q, n = n)
}

#' @rdname minimal_task
#'
#' @export

is_minimal_task <- function(x) {
    inherits(x, "minimal_task")
}

#' @export

print.minimal_task <- function(x, ...) {
    dims <- dim(x)
    w <- weights(x)
    msg <- glue::glue("Minimal task with p = {dims['p']}, q = {dims['q']}, \\
                      and n = {dims['n']}.
                      The loss function uses a weighted sum of squares with \\
                      the weights
                      w = {glue::glue_collapse(w, width = 40, sep = \", \")}")
    print(msg, ...)
    invisible(x)
}

#' @rdname minimal_task
#'
#' @export

weights.minimal_task <- function(object, ...) {
    assertthat::assert_that(is_minimal_task(object))
    object$w
}

#' @rdname minimal_task
#'
#' @export

input.minimal_task <- function(object, ...) {
    assertthat::assert_that(is_minimal_task(object))
    object$x
}

#' @rdname minimal_task
#'
#' @export

output.minimal_task <- function(object, ...) {
    assertthat::assert_that(is_minimal_task(object))
    object$y
}
