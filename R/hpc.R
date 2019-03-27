#' Hierarchical Predictive Coding Model
#'
#' @param architecture an object of class [architecture](is_architecture()).
#' Lowest layer of the architecture corresponds to the input.
#' @param input the input data. Either a function of time, or a matrix.
#'
#' @section Lifecycle:
#' The function will gain new arguments that allow specification of other fixed
#' values than the input. Due to their default values, the standard behavior
#' will remain the same, however.
#'
#' @export

hpc <- function(architecture, input) {
    assertthat::assert_that(
        is_architecture(architecture),
        is.matrix(input) || rlang::is_function(input)
    )
    if(is.data.frame(input)) {
        assertthat::assert_that(nrow(input) == layer_size(architecture, 0))
    }
    hpc <- list(
        architecture = architecture,
        input = input
    )
    class(hpc) <- c("hpc", class(hpc))
    hpc
}

#' @rdname hpc
#'
#' @param x an object.
#'
#' @export

is_hpc <- function(x) {
    inherits(x, "hpc")
}

#' @describeIn hpc Recovers the architecture
#'
#' @export

hpc_architecture <- function(hpc) {
    hpc[["architecture"]]
}

#' @describeIn hpc Recovers the input
#'
#' @param time If specified, returns input at this time as a matrix, where one
#' column corresponds to one observation
#'
#' @export

hpc_input <- function(hpc, time = NULL) {
    input <- hpc[["input"]]
    if(is.null(time) || is.matrix(input)) return(input)
    input(time)
}

#' @describeIn hpc describes how many simples the input provides
#'
#' @export

n_samples <- function(hpc) {
    input <- hpc_input(hpc)
    if(rlang::is_function(input)) return(1)
    ncol(input)
}
