#' Implementation
#'
#' This function specifies how the [hpc()] network should be implemented:
#' should it use Rao & Ballards model or the Free Energy Principle? What
#' assumptions do we make about the covariance matrix and should it be
#' learnable?
#'
#' @section Minimal implementation:
#' This implementation consists of an optional weight matrix for each layer
#'
#' @details
#' If you wish to add your own implementation function, you may do so by
#' providing a class that subsets the general class 'implementation' and may be
#' called by [simulate()].
#'
#' @param hpc Which network should be implemented?
#' @param error_weights How should the error within one layer be weighted?
#' List of matrices. Default is identity matrices in every layer.
#'
#' @export

implement_minimal <- function(hpc, error_weights = NULL, ...) {
    if(!is.null(error_weights)) {
        assertthat::assert_that(
            is.list(error_weights),
            length(error_weights) == architecture_depth(hpc) + 1
        )
        purrr::walk2(
            layers(hpc),
            function(x, y) {
                checkmate::check_matrix(
                    x,
                    mode = "numeric",
                    nrows = y,
                    ncols = y,
                    any.missing = FALSE
                )
                assertthat::assert_that(
                    matrixcalc::is.positive.semi.definite(x)
                )
            }
        )
    }
    else {
        error_weights <-
            purrr::map(
                layers(hpc),
                ~ diag(nrow = ., ncol = .)
            )
    }
    implementation <-
        list(
            hpc = hpc,
            error_weights = error_weights
        )
    class(implementation) <-
        c("minimal_implementation", "implementation", class(implementation))
    implementation
}

#' @describeIn implement_minimal Recover hpc
#'
#' @param implementation An implementation
#'
#' @export

implementation_hpc <- function(implementation) {
    implementation[["hpc"]]
}

#' @describeIn implement_minimal Recover error weights
#'
#' @export

error_weights <- function(implementation) {
    implementation[["error_weights"]]
}
