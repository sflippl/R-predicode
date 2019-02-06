#' Extract the output of the data
#'
#' @param object The object to extract the output from, usually a task
#' @param ... Further arguments provided to the methods
#'
#' @export

output <- function(object, ...) {
    UseMethod("output")
}
