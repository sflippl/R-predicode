#' Layers
#'
#' Recovers layers from networks, architectures, etc.
#'
#' @param x an object.
#'
#' @export

layers <- function(x) {
    UseMethod("layers")
}

#' @export

layers.architecture <- function(x) {
    x[["layers"]]
}

#' @export

layers.hpc <- function(x) {
    layers(hpc_architecture(x))
}

#' @export

layers.implementation <- function(x) {
    layers(implementation_hpc(x))
}

#' @describeIn layers recovers the size of a layer
#'
#' @param layers a vector of layer indices
#'
#' @export

layer_size <- function(x, layers) {
    i <- layers + 1
    layers(x)[i] %>%
        tidyr::replace_na(0)
}
