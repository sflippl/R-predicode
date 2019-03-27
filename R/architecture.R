#' Architectures
#'
#' Architectures provide the structure of the generative model in a Hierarchical
#' Predictive Coding network.
#'
#' @section Lifecycle:
#' These architectures are going to be extended, but the currently provided
#' architectures will remain available. The GPU implementation might imply
#' breaking changes.
#'
#' @export

is_architecture <- function(x) {
    inherits(x, "architecture")
}

#' @describeIn is_architecture defines fully connected layers of size layers
#'
#' @param layers an `integer` vector. First element provides the input size.
#' Every other element provides a deeper layer.
#' @param transformation What is the nonlinearity? Either a function or a list
#' of functions with the same length as `layers`. Default is the identity
#' function. Functions must be vectorized.
#'
#' @export

layered_architecture <- function(
    layers,
    transformation = identity,
    derivative = function(x) 0*x+1
) {
    checkmate::assert_integerish(
        layers,
        lower = 1,
        any.missing = FALSE,
        all.missing = FALSE,
        min.len = 2
    )
    layers <- rlang::as_integer(layers)
    f_is_list <- assertthat::see_if(
        is.list(transformation),
        length(transformation) == length(layers),
        all(purrr::map_lgl(transformation, rlang::is_function))
    )
    f_is_function <- assertthat::see_if(rlang::is_function(transformation))
    f_is_identity <- f_is_function && all.equal(transformation, identity)
    assertthat::assert_that(
        f_is_list || f_is_function,
        msg = paste(attr(f_is_list, "msg"), " and ", attr(f_is_function, "msg"))
    )
    if(f_is_function) transformation <- rep(list(transformation), length(layers))
    d_is_list <- assertthat::see_if(
        is.list(derivative),
        length(derivative) == length(layers),
        all(purrr::map_lgl(derivative, rlang::is_function))
    )
    d_is_function <- rlang::is_function(derivative)
    assertthat::assert_that(
        d_is_list || d_is_function,
        msg = paste(attr(d_is_list, "msg"), " and ", attr(d_is_function, "msg"))
    )
    if(d_is_function) derivative <- rep(list(derivative), length(layers))
    architecture <- list(
        layers = layers,
        transformation = transformation,
        derivative = derivative
    )
    class(architecture) <-
        c("layered_architecture", "architecture", class(architecture))
    if(f_is_identity) class(architecture) <-
        c("linear_layered_architecture", class(architecture))
    architecture
}

#' @describeIn layered_architecture Returns the vector of node numbers in each
#' layer.
#'
#' @export

layers <- function(architecture) UseMethod("layers")

#' @export

layers.architecture <- function(architecture) architecture[["layers"]]

#' @export

layers.hpc <- function(architecture) {
    architecture %>%
        hpc_architecture() %>%
        layers()
}

#' @describeIn layered_architecture Returns the size of a layer. If it
#' exceeds the maximum layer number, returns 0. Lowest layer is counted as layer
#' 0.
#'
#' @parameter layer Layer number we are interested in.
#'
#' @export

layer_size <- function(architecture, layer) {
    layer <- layer + 1
    if(layer > length(architecture)) return(0L)
    layers(architecture)[layer]
}

#' @describeIn layered_architecture Returns the transformation function of a
#' layer.
#'
#' @export

layer_transformation <- function(architecture, layer) {
    checkmate::assert_integerish(
        layer,
        lower = 0,
        upper = architecture_depth(architecture),
        len = 1,
        any.missing = FALSE
    )
    transformations(architecture)[[layer + 1]]
}

#' @describeIn layered_architecture Returns the derivative of a layer.
#'
#' @export

layer_derivative <- function(architecture, layer) {
    checkmate::assert_integerish(
        layer,
        lower = 0,
        upper = architecture_depth(architecture),
        len = 1,
        any.missing = FALSE
    )
    derivatives(architecture)[[layer + 1]]
}

#' @describeIn architecture Returns the depth of the architecture.
#'
#' @export

architecture_depth <- function(architecture) {
    length(layers(architecture)) - 1
}

#' @rdname is_architecture
#'
#' @export

print.layered_architecture <- function(x, ...) {
    depth <- architecture_depth(x)
    msg <- glue::glue("Layered architecture with {depth} hidden layers.")
    print(msg)
    invisible(x)
}

#' @rdname is_architecture
#'
#' @export

print.linear_layered_architecture <- function(x, ...) {
    depth <- architecture_depth(x)
    if(depth == 1) layer <- "layer"
    else layer <- "layers"
    msg <-
        glue::glue("Layered linear architecture with {depth} hidden {layer}.")
    print(msg)
    invisible(x)
}
