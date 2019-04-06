#' Explicit inference
#'
#' This function returns the explicit inference as described in section C.2.
#'
#' @param implementation An implementation of a two-layered linear predictive
#' coding network
#' @param length_time How long should the explicit learning trajectory be
#' provided?
#' @param parameters What are the parameters?
#' @param init_signals How are the signals initialized?
#' @param time_constant What is the time constant of inference?
#' @param timestep What is the resolution of the learning trajectories?
#'
#' @export

explicit_inference <- function(
    implementation,
    length_time,
    parameters = "randortho",
    init_signals = "randnorm",
    time_constant,
    timestep
) {
    assertthat::assert_that(is_analytical(implementation))
    checkmate::assert_number(length_time, lower = 0, finite = TRUE)
    checkmate::assert_number(time_constant, lower = 0, finite = TRUE)
    checkmate::assert_number(timestep, lower = 0, finite = TRUE)
    assertthat::assert_that(
        time_constant > 0,
        timestep > 0
    )
    parameters <-
        parameters %>%
        generate_parameters(implementation) %>%
        magrittr::extract2(1)
    init_signals <-
        init_signals %>%
        generate_signals(implementation) %>%
        magrittr::extract2(1)
    N1 <-
        implementation %>%
        layer_size(1)

    # The right singular vectors mix up the dynamics, we therefore multiply by
    # them to untangle them
    svd_parameters <- svd(parameters)
    singular_right <- svd_parameters$v
    untangled_signals <- t(singular_right) %*% init_signals
    input <-
        implementation %>%
        implementation_hpc() %>%
        hpc_input()
    untangled_signals_inf <-
        svd_parameters$d^(-1) * t(svd_parameters$u) %*% input
    ks <- seq_len(N1)
    observations <- seq_len(ncol(init_signals))
    time <- seq(from = 0, to = length_time, by = timestep)
    trajectory <-
        tibble::tibble(
            time = time,
            untangled_signal =
                purrr::map(
                    time,
                    ~ exp(-svd_parameters$d^2 * ./time_constant) *
                        (untangled_signals - untangled_signals_inf) +
                        untangled_signals_inf
                )
        ) %>%
        dplyr::mutate(
            tangled_signal =
                purrr::map(
                    untangled_signal,
                    ~ singular_right %*% .
                )
        )
    attr(trajectory, "B") <- singular_right
    trajectory
}
