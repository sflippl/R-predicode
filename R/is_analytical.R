#' Analytical solutions for predictive coding networks
#'
#' This function returns whether an analytical solution exists for this network.

is_analytical <- function(implementation) {
    two_linear <-
        (architecture_depth(implementation) == 1) &&
        inherits(hpc_architecture(implementation_hpc(implementation)),
                 "linear_layered_architecture") &&
        is.matrix(hpc_input(implementation_hpc(implementation)))
    if(two_linear) return(TRUE)
    FALSE
}
