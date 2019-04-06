#' @describeIn simulate This simulates the minimal implementation
#'
#' @param force_orthogonality Should parameters be orthogonalized?
#'
#' @export

simulate.minimal_implementation <- function(
    implementation,
    stopping_rule,
    tau_estimation,
    tau_inference,
    timestep,
    init_signals = "randnorm",
    init_parameters = "randortho",
    fixed_parameters = FALSE,
    instantaneous_signals = FALSE,
    instantaneous_signals_stopping_rule = stopping_rule,
    instantaneous_signals_timestep = timestep,
    force_orthogonality = TRUE,
    ...
) {
    # Check input values -------------------------------------------------------
    checkmate::assert_number(timestep, lower = 0, finite = TRUE)
    assertthat::assert_that(timestep > 0)
    checkmate::check_number(tau_estimation, lower = 0, finite = TRUE)
    checkmate::check_number(tau_inference, lower = 0, finite = TRUE)
    assertthat::assert_that(
        tau_estimation > 0,
        tau_inference > 0,
        is_stopping_rule(stopping_rule),
        is_stopping_rule(instantaneous_signals_stopping_rule)
    )

    init_parameters <- generate_parameters(init_parameters, implementation)

    init_signals <- generate_signals(init_signals, implementation)

    if(instantaneous_signals) {
        init_signals <-
            infer_signals(
                implementation = implementation,
                parameters = init_parameters,
                input = hpc_input(implementation_hpc(implementation), 0),
                init_signals = init_signals,
                stopping_rule = instantaneous_signals_stopping_rule,
                timestep = instantaneous_signals_timestep,
                bypass_assertion = TRUE
            )
    }

    # Instantiate data frame ---------------------------------------------------
    simulation <-
        tibble::tibble(
            time = 0,
            signals = list(init_signals),
            parameters = list(init_parameters)
        )

    # Fill data frame ----------------------------------------------------------
    bool_stop <- max_iterations(stopping_rule) >= 1
    old_signals <- init_signals
    old_parameters <- init_parameters
    time <- 0
    while(bool_stop) {
        time <- time + timestep
        if(!fixed_parameters) {
            new_parameters <-
                parameter_step(
                    implementation,
                    parameters = old_parameters,
                    input = hpc_input(implementation_hpc(implementation), time),
                    signals = old_signals,
                    time_constant = tau_estimation,
                    timestep = timestep
                )
            if(force_orthogonality) {
                new_parameters <-
                    new_parameters %>%
                    purrr::map(
                        function(x) {
                            svd <- svd(x)
                            svd$u %*% svd$v
                        }
                    )
            }
        }
        else {
            new_parameters <- old_parameters
        }
        if(instantaneous_signals) {
            new_signals <-
                infer_signals(
                    implementation,
                    parameters = new_parameters,
                    input = hpc_input(implementation_hpc(implementation), time),
                    init_signals = old_signals,
                    stopping_rule = instantaneous_signals_stopping_rule,
                    timestep = instantaneous_signals_timestep,
                    bypass_assertion = TRUE
                )
        }
        else {
            new_signals <-
                signal_step(
                    implementation,
                    parameters = old_parameters,
                    input = hpc_input(implementation_hpc(implementation), time),
                    signals = old_signals,
                    time_constant = tau_inference,
                    timestep = timestep
                )
        }
        bool_stop <-
            (time/timestep + 1 <= max_iterations(stopping_rule)) &&
            (.distance(old_parameters, new_parameters, "2") +
                 .distance(old_signals, new_signals, "2") >=
                 stopping_distance(stopping_rule))
        old_signals <- new_signals
        old_parameters <- new_parameters
        simulation <-
            simulation %>%
            dplyr::bind_rows(
                tibble::tibble(
                    time = time,
                    signals = list(new_signals),
                    parameters = list(new_parameters)
                )
            )
    }
    simulation
}
