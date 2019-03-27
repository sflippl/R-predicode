#' Distance helper
#'
#' This function computes the distance for a list of matrices.
#'
#' @param list_1 first list
#' @param list_2 second list
#' @param type type of [norm()]

.distance <- function(list_1, list_2, type) {
    purrr::map2_dbl(
        list_1, list_2,
        ~ norm(.x - .y, type = type)
    ) %>%
        sum()
}
