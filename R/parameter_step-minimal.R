#' @export

parameter_step.minimal_implementation <- function(
    implementation,
    parameters,
    input,
    signals,
    time_constant,
    timestep
) {
    completed_signals <- c(list(input), signals)
    error_weights <- error_weights(implementation)
    depth <-
        implementation %>%
        architecture_depth()
    normalized_prediction_error <-
        .norm_prediction_error(
            completed_signals,
            error_weights,
            parameters,
            implementation
        )
    gradient <-
        1:depth %>%
        purrr::map(
            function(l) {
                derivative <-
                    implementation %>%
                    implementation_hpc() %>%
                    hpc_architecture() %>%
                    layer_derivative(l - 1)
                (normalized_prediction_error[[l]] *
                    derivative(parameters[[l]] %*% signals[[l]])) %*%
                    t(signals[[l]])
            }
        )
    new_parameters <-
        1:depth %>%
        purrr::map(
            ~ parameters[[.]] - timestep/time_constant * gradient[[.]]
        )
    new_parameters
}
