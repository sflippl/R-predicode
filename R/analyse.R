#' Analytical solutions for the network
#'
#' This function provides analytical solutions if they are available.
#'
#' @param implementation An implementation.
#' @param stopping_rule A [stopping_rule()]
#' @param init_signals What is the signal value at time 0? As a string,
#' provides the random method to draw the parameters. Currently, only "randnorm"
#' is implemented.
#' @param init_parameters What is the parameter value at time 0? As a string,
#' provides the random method to draw the parameters. Currently, only
#' "randortho" is implemented.
#' @param fixed_parameters Should the parameters be fixed or can they be
#' learned?
#' @param instantaneous_signals Should the signals be computed instantaneously
#' @param tau_estimation What is the time constant of estimation? Is not used if
#' fixed_parameters is TRUE
#' @param tau_inference What is the time constant of inference? Is not used if
#' instantaneous signals is TRUE
#' @param timestep What resolution should the explicit learning
#' trajectory have?
#'
#' @export

analyse <- function(
    implementation,
    stopping_rule,
    init_signals = "randnorm",
    init_parameters = "randortho",
    fixed_parameters = FALSE,
    instantaneous_signals = TRUE,
    tau_estimation,
    tau_inference,
    timestep
) {
    UseMethod("analyse")
}
