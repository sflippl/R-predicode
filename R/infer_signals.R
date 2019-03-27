#' Infer signals
#'
#' This function returns the inferred signals of a predictive coding
#' implementation.
#'
#' @param implementation The implementation
#' @param parameters the parameters.
#' @param init_signals What is the signal value at time 0? As a string,
#' provides the random method to draw the parameters. Currently, only
#' "randortho" is implemented.
#' @param stopping_rule The [stopping_rule()]
#' @param timestep The timestep
#' @param bypass_assertions Should the assertions be skipped to save time? Set
#' TRUE only if you can trust the input.
#'
#' @export

infer_signals <- function(
    implementation,
    parameters,
    input,
    init_signals = "randnorm",
    stopping_rule,
    timestep,
    bypass_assertions = FALSE
) {
    if(!bypass_assertions) {
        checkmate::assert_number(timestep, lower = 0, finite = TRUE)
        assertthat::assert_that(timestep > 0)
        assertthat::assert_that(is_stopping_rule(stopping_rule))
        assert_parameters(parameters, implementation)
        generate_signals <- is.character(init_signals)
        if(!generate_signals) {
            assert_signals(signals, implementation)
        }
        else {
            init_signals <-
                initialize_signals(
                    structure(list(), class = init_signals),
                    implementation
                )
        }
    }
    old_signals <- init_signals
    bool_stop <- TRUE
    it <- 1
    while(bool_stop) {
        it <- it + 1
        new_signals <-
            signal_step(
                implementation,
                parameters = parameters,
                input = input,
                signals = old_signals,
                time_constant = 1,
                timestep = timestep
            )
        bool_stop <-
            (it <= max_iterations(stopping_rule)) &&
            (.distance(new_signals, old_signals, "2") >=
                 stopping_distance(stopping_rule))
        old_signals <- new_signals
    }
    new_signals
}
