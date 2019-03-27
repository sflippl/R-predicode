#' Gradient descent on a minimal FNN
#'
#' Given a step size and initial values, this function simulates gradient
#' descent for a [minimal_fnn()]. It returns a data frame with one observation
#' per time point, step size, and set of initial values. The function is
#' vectorized over both step size and initial values.
#'
#' @param minimal_task A minimal task which is being optimized.
#' @param initial_values A list of [minimal_fnn()]s that function as starting
#' values.
#' @param step_size Which step size should the gradient descent use?
#'
#' @export

minimal_fnn_gd <- function(minimal_task, initial_values, step_size,
                           stopping_rule) {
    assertthat::assert_that(is.numeric(step_size), all(step_size > 0))
    assertthat::assert_that(is_stopping_rule(stopping_rule))
    gradient_descent <- dplyr::tibble(
        initial_values = list(),
        step_size = numeric(0),
        fnn = list()
    )
    max_it <- max_iterations(stopping_rule)
    stop_dist <- stopping_distance(stopping_rule)
    for(tmp_step_size in step_size) {
        step <- .minimal_fnn_gd_step(minimal_task, tmp_step_size)
        for(tmp_initial_values in initial_values) {
            assertthat::assert_that(is_minimal_fnn(tmp_initial_values))
            gradient_descent <-
                dplyr::bind_rows(
                    gradient_descent,
                    dplyr::tibble(
                        initial_values = list(tmp_initial_values),
                        step_size = tmp_step_size,
                        fnn = list(tmp_initial_values)
                    )
                )
            old_fnn <- tmp_initial_values
            t <- 0
            bool_it <- t <= max_it
            bool_dist <- TRUE
            while(bool_it & bool_dist) {
                new_fnn <- step(old_fnn)
                gradient_descent <-
                    dplyr::bind_rows(
                        gradient_descent,
                        dplyr::tibble(
                            initial_values = list(tmp_initial_values),
                            step_size = tmp_step_size,
                            fnn = list(new_fnn)
                        )
                    )
                dist_0 <- sum((theta_0(new_fnn) - theta_0(old_fnn))^2)
                dist_1 <- sum((theta_1(new_fnn) - theta_1(old_fnn))^2)
                bool_dist <- (dist_0 + dist_1) >= stop_dist
                old_fnn <- new_fnn
            }
        }
    }
    gradient_descent
}

#' Computes the gradient descent step for a minimal FNN given a minimal task
#'
#' @param minimal_task A minimal task
#' @param step_size The step size of gradient descent
#'
#' @export

.minimal_fnn_gd_step <- function(minimal_task, step_size) {
    x <-
        minimal_task %>%
        input() %>%
        as.matrix() %>%
        t()
    theta_0_colnames <-
        minimal_task %>%
        input() %>%
        names()
    y <-
        minimal_task %>%
        output() %>%
        as.matrix() %>%
        t()
    theta_1_rownames <-
        minimal_task %>%
        output() %>%
        names()
    w <- weights(minimal_task)
    function(minimal_fnn) {
        theta_0 <- theta_0(minimal_fnn)
        theta_1 <- theta_1(minimal_fnn)
        middle_expression <-
            2 * diag(w) %*% (y - theta_1 %*% theta_0 %*% x) %*% t(x)
        new_theta_0 <-
            (theta_0 + step_size * t(theta_1) %*% middle_expression) %>%
            as.matrix() %>%
            magrittr::set_colnames(theta_0_colnames)
        new_theta_1 <-
            (theta_1 + step_size * middle_expression %*% t(theta_0)) %>%
            as.matrix() %>%
            magrittr::set_rownames(theta_1_rownames)
        minimal_fnn(theta_0 = new_theta_0, theta_1 = new_theta_1)
    }
}
