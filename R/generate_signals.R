#' Generate signals
#'
#' Generates signals, either by instantiating them or asserting that they are
#' valid.
#'
#' @param signal provided signal. Might be a character, e. g. "randnorm"
#' @param implementation an implementation
#'
#' @export

generate_signals <- function(signal, implementation) {
    generate_signals <- is.character(signal)
    if(!generate_signals) {
        assert_signals(signal, implementation)
    }
    else {
        signal <-
            initialize_signals(
                structure(list(), class = signal),
                implementation
            )
    }
    signal
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
            ~ checkmate::assert_matrix(
                .x,
                any.missing = FALSE,
                nrow = layer_size(implementation, .y)
            )
        )
}

#' @describeIn simulate-minimal-helpers initializes signals. Extendible by
#' using the character init_signals in [simulate()] as a S3 class.
#'
#' @export

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
