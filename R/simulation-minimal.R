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

    # Generate parameters ---------------------------------------------------------
    generate_parameters <- is.character(init_parameters)
    if(!generate_parameters) {
        assert_parameters(init_parameters)
    }
    else {
        init_parameters <-
            initialize_parameters(
                structure(list(), class = init_parameters),
                implementation
            )
    }

    # Generate signals ---------------------------------------------------------
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

#' Helpers for the minimal simulation
#'
#' @name simulate-minimal-helpers

NULL

#' @describeIn simulate-minimal-helpers checks whether parameters are valid

assert_parameters <- function(parameters, implementation) {
    assertthat::assert_that(
        is.list(parameters),
        length(parameters) == architecture_depth(implementation)
    )
    purrr::iwalk(
        parameters,
        ~ checkmate::check_matrix(
            .x,
            mode = "numeric",
            any.missing = FALSE,
            nrows = layer_size(architecture(implementation), .y - 1),
            ncols = layer_size(architecture(implementation), .y)
        )
    )
}

#' @describeIn simulate-minimal-helpers initializes parameters. Extendible by
#' using the character init_parameters in [simulate()] as a S3 class.

initialize_parameters <- function(method, implementation) {
    UseMethod("initialize_parameters")
}

initialize_parameters.randortho <- function(method, implementation) {
    implementation %>%
        architecture_depth() %>%
        seq_len() %>%
        purrr::map(
            function(x) {
                nrows <- layer_size(implementation, x - 1)
                ncols <- layer_size(implementation, x)
                pracma::randortho(n = max(nrows, ncols)) %>%
                    magrittr::extract(seq_len(nrows), seq_len(ncols))
            }
        )
}

#' @describeIn simulate-minimal-helpers checks whether the signals have the
#' right format

assert_signals <- function(signals, implementation) {
    assertthat::assert_that(
        is.list(init_signals),
        length(init_signals) == architecture_depth(implementation)
    )
    init_signals %>%
        purrr::iwalk(
            ~ checkmate::assert_numeric(
                .x,
                finite = TRUE,
                any.missing = FALSE,
                len = layer_size(implementation, .y)
            )
        )
}

#' @describeIn simulate-minimal-helpers initializes signals. Extendible by
#' using the character init_signals in [simulate()] as a S3 class.

initialize_signals <- function(method, implementation) {
    UseMethod("initialize_signals")
}

initialize_signals.randnorm <- function(method, implementation) {
    n_samples <-
        implementation %>%
        implementation_hpc() %>%
        n_samples()
    implementation %>%
        architecture_depth() %>%
        seq_len() %>%
        purrr::map(
            function(x) {
                implementation %>%
                    layer_size(x) %>%
                    runif(min = -1, max = 1) %>%
                    scale(center = FALSE, scale = TRUE) %>%
                    rep(n_samples) %>%
                    matrix(ncol = n_samples)
            }
        )
}
