#' Extract the input data
#'
#' @param object The object to extract the input from, usually a task
#' @param ... Further arguments provided to the methods
#'
#' @export

input <- function(object, ...) {
    UseMethod("input")
}
