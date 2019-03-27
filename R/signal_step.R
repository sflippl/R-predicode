#' Signal step
#'
#' This function provides one step for the signal within a predictive coding
#' implementation
#'
#' @param implementation the implementation
#' @param parameters the parameters at the particular time
#' @param input the input at the particular time
#' @param signals the signals at the particular time
#' @param time_constant time_constant for the gradient descent (tau_inference)
#' @param timestep timestep of the simulation
#'
#'
#' @export

signal_step <- function(
    implementation,
    parameters,
    input,
    signals,
    time_constant,
    timestep
) {
    UseMethod("signal_step")
}
