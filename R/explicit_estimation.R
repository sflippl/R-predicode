#' Explicit estimation
#'
#' This function implements theorem C.1 and returns the explicit estimation.
#'
#' @param implementation an implementation.
#' @param length_time The length of the trajectory computation
#' @param init_parameters What are the parameters?
#' @param time_constant What is the time constant?
#' @param timestep What is the resolution of the trajectory?
#'
#' @export

explicit_estimation <- function(
    implementation,
    length_time,
    init_parameters = "randortho",
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
    init_parameters <-
        init_parameters %>%
        generate_parameters(implementation) %>%
        magrittr::extract2(1)
    N_1 <- layer_size(implementation, 1)
    N_0 <- layer_size(implementation, 0)
    covariance <-
        implementation %>%
        implementation_hpc() %>%
        hpc_input() %>%
        {(ncol(.)-1)^(-1) * (. %*% t(.))}
    eigen <-
        covariance %>%
        eigen()
    eigenvalues <- eigen$values
    eigenvectors <- eigen$vectors
    resolution <- eigenvalues[N_1] - eigenvalues[N_1+1]
    power <- eigenvalues[1] - eigenvalues[N_0]
    relevant_eigenvectors <- eigenvectors[, seq_len(N_1)]
    nuisance_eigenvectors <- eigenvectors[, -seq_len(N_1)]
    gamma <- t(relevant_eigenvectors) %*% init_parameters
    eta <- t(nuisance_eigenvectors) %*% init_parameters
    svd_gamma <- svd(gamma)
    principal_angles <- svd_gamma$d
    t_0 <- log(principal_angles^(-2)-1)
    time <-
        seq(from = 0, to = length_time, by = timestep) %>%
        rep(each = N_1)
    time_its <- length_time/timestep + 1
    comp_t_0 <- rep(t_0, times = time_its)
    trajectory <-
        tibble::tibble(
            time = time,
            principal_angle = rep(seq_len(N_1), times = time_its),
            lower_bound =
                sqrt(1/(1+exp(-resolution*time/time_constant+comp_t_0))),
            upper_bound = sqrt(1/(1+exp(-power*time/time_constant+comp_t_0)))
        )
    attr(trajectory, "relevant_eigenvectors") <- relevant_eigenvectors
    attr(trajectory, "nuisance_eigenvectors") <- nuisance_eigenvectors
    attr(trajectory, "left_principal_vectors") <- svd_gamma$u
    attr(trajectory, "right_principal_vectors") <- svd_gamma$v
    trajectory
}
