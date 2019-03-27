.norm_prediction_error <-
    function(completed_signals, error_weights, parameters, implementation) {
        purrr::map(
            0:length(parameters),
            function(l) {
                if(l < length(parameters)) {
                    transformation <-
                        implementation %>%
                        implementation_hpc() %>%
                        hpc_architecture() %>%
                        layer_transformation(l)
                    prediction <-
                        transformation(
                            parameters[[l+1]] %*% completed_signals[[l+2]]
                        )
                }
                else {
                    nrow <- nrow(completed_signals[[l+1]])
                    ncol <- ncol(completed_signals[[l+1]])
                    prediction <- matrix(0, nrow = nrow, ncol = ncol)
                }
                prediction_error <- prediction - completed_signals[[l+1]]
                error_weights[[l+1]] %*% prediction_error
            }
        )
    }
