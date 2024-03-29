% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fnn-minimal-gd.R
\name{minimal_fnn_gd}
\alias{minimal_fnn_gd}
\title{Gradient descent on a minimal FNN}
\usage{
minimal_fnn_gd(minimal_task, initial_values, step_size, stopping_rule)
}
\arguments{
\item{minimal_task}{A minimal task which is being optimized.}

\item{initial_values}{A list of [minimal_fnn()]s that function as starting
values.}

\item{step_size}{Which step size should the gradient descent use?}
}
\description{
Given a step size and initial values, this function simulates gradient
descent for a [minimal_fnn()]. It returns a data frame with one observation
per time point, step size, and set of initial values. The function is
vectorized over both step size and initial values.
}
