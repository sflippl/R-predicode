#' Minimal Feedforward Networks
#'
#' A minimal feedforward network estimates a q-dimensional vector Y from a
#' p-dimensional vector X. It is defined by an r x p-matrix theta_0 and a
#' q x r-matrix theta_1.
#'
#' @param theta_0 Input the matrix theta_0
#' @param theta_1 Input the matrix theta_1
#'
#' @examples
#' minimal_fnn_manual <- minimal_fnn(theta_0 = matrix(-1), theta_1 = matrix(-1))
#'
#' @export

minimal_fnn <- function(theta_0, theta_1) {
    checkmate::assert_matrix(theta_0, any.missing = FALSE)
    checkmate::assert_matrix(theta_1, any.missing = FALSE)
    assertthat::assert_that(is.numeric(theta_0),
                            is.numeric(theta_1),
                            nrow(theta_0) == ncol(theta_1))
    fnn <- list(theta_0 = theta_0, theta_1 = theta_1)
    class(fnn) <- c("minimal_fnn", "fnn", class(fnn))
    fnn
}

#' @describeIn minimal_fnn recovers p, q and r
#'
#' @export

dim.minimal_fnn <- function(x) {
    p <-
        x %>%
        theta_0() %>%
        ncol()
    q <-
        x %>%
        theta_1() %>%
        nrow()
    r <-
        x %>%
        theta_0() %>%
        nrow()
    c(p = p, q = q, r = r)
}

#' @rdname minimal_fnn
#'
#' @export

print.minimal_fnn <- function(x, ...) {
    dims <- dim(x)
    msg <- glue::glue("Minimal FNN with p = {dims['p']}, r = {dims['r']}, and \\
                      q = {dims['q']}.")
    print(msg)
    invisible(x)
}

#' @rdname minimal_fnn
#'
#' @export

is_minimal_fnn <- function(x) {
    inherits(x, "minimal_fnn")
}

#' @rdname minimal_fnn
#'
#' @export

theta_0 <- function(minimal_fnn) {
    assertthat::assert_that(is_minimal_fnn(minimal_fnn))
    minimal_fnn$theta_0
}

#' @rdname minimal_fnn
#'
#' @export

theta_1 <- function(minimal_fnn) {
    assertthat::assert_that(is_minimal_fnn(minimal_fnn))
    minimal_fnn$theta_1
}
