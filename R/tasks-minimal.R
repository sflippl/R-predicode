#' Minimal tasks
#'
#' A minimal task consists of an input and an output dataset. The estimation
#' $\hat{y}$ of the output $y$ according to a model is evaluated by the sum of
#' squares $\mathcal{L}(y, \hat{y}):=\sum_{i=1}^qw_i(y_i-\hat{y}_i)^2$, where
#' $w$ is the corresponding weights vector.
#'
#' @param x Input data
#' @param y Output data
#' @param w Weights of the loss function
#'
#' @export

minimal_task <- function(x, y, w = rep(1, ncol(y))) {
    checkmate::assert_numeric(w, lower = 0, finite = TRUE, any.missing = FALSE)
    assertthat::assert_that(is.data.frame(x))
    assertthat::assert_that(is.data.frame(y))
    assertthat::assert_that(nrow(x) == nrow(y))
    assertthat::assert_that(length(w) == ncol(y))
    task <- list(x = x, y = y, w = w)
    class(task) <- c("minimal_task", "task")
    task
}

#' @export

print.minimal_task <- function(x, ...) {
    p <-
        x %>%
        input() %>%
        ncol()
    q <-
        x %>%
        output() %>%
        ncol()
    n <-
        x %>%
        input() %>%
        nrow()
    w <- weights(x)
    msg <- glue::glue("Minimal task with p = {p}, q = {q}, and n = {n}.
                      The loss function uses a weighted sum of squares with \\
                      the weights
                      w = {glue::glue_collapse(w, width = 40, sep = \", \")}")
    print(msg)
    invisible(x)
}

#' @rdname minimal_task
#'
#' @export

weights.minimal_task <- function(object, ...) {
    object$w
}

#' @rdname minimal_task
#'
#' @export

input.minimal_task <- function(object, ...) {
    object$x
}

#' @rdname minimal_task
#'
#' @export

output.minimal_task <- function(object, ...) {
    object$y
}
