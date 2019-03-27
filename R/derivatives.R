#' Derivatives
#'
#' Recovers the derivatives in an architecture, network, etc.
#'
#' @param x an object.
#'
#' @export

derivatives <- function(x) UseMethod("derivatives")

#' @export

derivatives.architecture <- function(x) {
    x[["derivative"]]
}

#' @export

derivatives.hpc <- function(x) {
    x %>%
        hpc_architecture() %>%
        derivative()
}
