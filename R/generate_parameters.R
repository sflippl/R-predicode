#' Generate parameters
#'
#' Generates parameters, either by instantiating them or asserting that they are
#' valid.
#'
#' @param parameter provided parameter. Might be a character, e. g. "randortho"
#' @param implementation an implementation
#'
#' @export

generate_parameters <- function(parameter, implementation) {
    generate_parameters <- is.character(parameter)
    if(!generate_parameters) {
        assert_parameters(parameter, implementation)
    }
    else {
        parameter <-
            initialize_parameters(
                structure(list(), class = parameter),
                implementation
            )
    }
    parameter
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
            nrows = layer_size(implementation_hpc(implementation), .y - 1),
            ncols = layer_size(implementation_hpc(implementation), .y)
        )
    )
}

#' @describeIn simulate-minimal-helpers initializes parameters. Extendible by
#' using the character init_parameters in [simulate()] as a S3 class.
#'
#' @export

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
