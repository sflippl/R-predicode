#' Simulation
#'
#' This function simulates a particular implementation of a predictive coding
#' network.
#'
#' @param implementation The implementation we are concerned with
#' @param stopping_rule a [stopping_rule()]
#' @param init_signals What is the signal value at time 0? As a string,
#' provides the random method to draw the parameters. Currently, only "randortho"
#' is implemented.
#' @param init_parameters What is the parameter value at time 0? As a string,
#' provides the random method to draw the parameters. Currently, only "randortho"
#' is implemented.
#' @param fixed_parameters Should the parameters be fixed or can they be
#' learned?
#' @param instantaneous_signals Should the signals be computed instantaneously,
#' i. e. should we either use a closed form for the signals or use the EM
#' algorithm?
#' @param tau_estimation What is the time constant of estimation? Is not used if
#' fixed_parameters is TRUE
#' @param tau_inference What is the time constant of inference? Is not used if
#' instantaneous signals is TRUE
#'
#' @export

simulate <- function(
    implementation, stopping_rule,
    init_signals = "randortho",
    init_parameters = "randortho",
    fixed_parameters = FALSE,
    instantaneous_signals = FALSE,
    tau_estimation,
    tau_inference,
    timestep,
    ...
) {
    UseMethod("simulate")
}
