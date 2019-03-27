#' Transformations
#'
#' Recovers the transformation in an architecture, network, etc.
#'
#' @param x an object
#'
#' @export

transformations <- function(x) {
    UseMethod("transformations")
}

#' @export

transformations.architecture <- function(x) {
    x[["transformation"]]
}

#' @export

transformations.hpc <- function(x) {
    transformations(hpc_architecture(x))
}
