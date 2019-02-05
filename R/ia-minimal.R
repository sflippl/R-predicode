#' Minimal integrated account
#'
#' The minimal integrated account consists of one hidden layer with no prior,
#' only includes linear transformation, and is concerned with singular tasks.
#'
#' @param lambda Interpolation parameter. Can be a vector but may only include
#' values between zero and one.
#' @param p Dimension of $X$. Default is NA.
#' @param q Dimension of $Y$. Default is NA.
#' @param r Dimension of $H$. Default is NA.
#'
#' @export

minimal_ia <- function(lambda = 1,
                       p = NA_integer_, q = NA_integer_, r = NA_integer_) {
    checkmate::checkNumeric(lambda, lower = 0, upper = 1, any.missing = FALSE)
}

#' @describeIn minimal_ia

minimal_hpc <- function(p = NA_integer_, q = NA_integer_, r = NA_integer_,
                        Sigma_X = NA_real_, Sigma_Y = NA_real_,
                        x = NULL, y = NULL,
                        U = NA_real_, V = NA_real_) {
    c(p, q, r) <- get_minimal_dimensions(p = p, q = q, r = r)
    checkmate::checkNumber(p, lower = 0, finite = TRUE)
    checkmate::checkNumber(q, lower = 0, finite = TRUE)
    checkmate::checkNumber(r, lower = 0, finite = TRUE)
    checkmate::checkNumber(Sigma_X, lower = 0, finite = TRUE)
    checkmate::checkNumber(Sigma_Y, lower = 0, finite = TRUE)
    checkmate::checkNumber(U, finite = TRUE)
    checkmate::checkNumber(V, finite = TRUE)
    assertthat::assert_that(is.null(x) || is.null(y) || nrow(x) == nrow(y))
    hpc <- list(p = p, q = q, r = r, x = x, y = y,
                Sigma_X = Sigma_X, Sigma_Y = Sigma_Y, theta = theta)
    hpc
}

#' @describeIn minimal_ia

minimal_fnn <- function(p = NA_integer_, q = NA_integer_, r = NA_integer_,
                        x = NULL, y = NULL,
                        theta = c(`0` = NA_real_, `1` = NA_real_)) {
    c(p, q, r) <- get_minimal_dimensions(p = p, q = q, r = r)
    checkmate::checkNumber(p, lower = 0, finite = TRUE)
    checkmate::checkNumber(q, lower = 0, finite = TRUE)
    checkmate::checkNumber(r, lower = 0, finite = TRUE)
    checkmate::checkNumber(Sigma_X, lower = 0, finite = TRUE)
    checkmate::checkNumber(Sigma_Y, lower = 0, finite = TRUE)
    checkmate::checkNumber(U, finite = TRUE)
    checkmate::checkNumber(V, finite = TRUE)
    assertthat::assert_that(is.null(x) || is.null(y) || nrow(x) == nrow(y))
    fnn <- list(p = p, q = q, r = r, x = x, y = y, theta = theta)
    class(fnn) <- c("minimal_fnn", "fnn")
    fnn
}

get_minimal_dimensions <- function(
    p = NA_integer_, q = NA_integer_, r = NA_integer_) {
    p <- rlang::as_integer(p)
    q <- rlang::as_integer(q)
    r <- rlang::as_integer(r)
}
