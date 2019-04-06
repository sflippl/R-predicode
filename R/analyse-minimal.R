#' @describeIn analyse At the moment, there are two explicit learning
#' trajectories available: [explicit_inference()] with fixed parameters (section
#' C.2) and [explicit_estimation()] with instantaneous signals. This function
#' provides an interface with these functions that is consistent with the
#' function [simulate()].
#'
#'
#' @export

analyse.minimal_implementation <- function(
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
    # Test input ---------------------------------------------------------------
    assertthat::assert_that(
        is_analytical(implementation),
        is_stopping_rule(stopping_rule)
    )
    checkmate::check_number(tau_estimation, lower = 0, finite = TRUE)
    checkmate::check_number(tau_inference, lower = 0, finite = TRUE)
    checkmate::check_number(timestep, lower = 0, finite = TRUE)
    assertthat::assert_that(
        tau_estimation > 0,
        tau_inference > 0,
        timestep > 0
    )

    # Dynamical inference ------------------------------------------------------
    if(fixed_parameters && !instantaneous_signals) {
        implementation %>%
            explicit_inference(
                stopping_rule = stopping_rule,
                parameters = init_parameters,
                init_signals = init_signals,
                time_constant = tau_inference,
                timestep = timestep
            ) %>%
            return()
    }

    # Dynamical estimation -----------------------------------------------------
    if(!fixed_parameters && instantaneous_signals) {
        implementation %>%
            explicit_estimation(
                stopping_rule = stopping_rule,
                init_parameters = init_parameters,
                time_constant = tau_estimation,
                timestep = timestep
            ) %>%
            return()
    }

    # Nothing to estimate ------------------------------------------------------
    if(fixed_parameters && instantaneous_signals) {
        stop("The system immediately reaches its endpoint.")
    }

    # Too complex --------------------------------------------------------------
    stop("At the moment, no explicit solution exists for this case.")
    # if(instantaneous_signals) {
    #     init_signals <-
    #         infer_signals(
    #             implementation = implementation,
    #             parameters = init_parameters,
    #             input = hpc_input(implementation_hpc(implementation), 0),
    #             init_signals = init_signals,
    #             stopping_rule = instantaneous_signals_stopping_rule,
    #             timestep = instantaneous_signals_timestep,
    #             bypass_assertion = TRUE
    #         )
    # }
    # N1 <- layer_size(implementation, 1)
    # N0 <- layer_size(implementation, 0)
    # covariance <-
    #     implementation %>%
    #     implementation_hpc() %>%
    #     hpc_input() %>%
    #     {(ncol(.)-1)^(-1) * (. %*% t(.))}
    # eigen <-
    #     covariance %>%
    #     eigen()
    # eigenvalues <- eigen$values
    # eigenvectors <- eigen$vectors
    # resolution <- eigenvalues[N1] - eigenvalues[N1+1]
    # power <- eigenvalues[1] - eigenvalues[N0]
    # starting_point <-

}
