% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tasks-minimal.R
\name{minimal_task}
\alias{minimal_task}
\alias{dim.minimal_task}
\alias{is_minimal_task}
\alias{weights.minimal_task}
\alias{input.minimal_task}
\alias{output.minimal_task}
\title{Minimal tasks}
\usage{
minimal_task(x, y, w = rep(1, ncol(y)))

\method{dim}{minimal_task}(x)

is_minimal_task(x)

\method{weights}{minimal_task}(object, ...)

\method{input}{minimal_task}(object, ...)

\method{output}{minimal_task}(object, ...)
}
\arguments{
\item{x}{Input data}

\item{y}{Output data}

\item{w}{Weights of the loss function}

\item{object}{a minimal task}

\item{...}{Further parameters}
}
\description{
A minimal task consists of an input and an output dataset. The estimation
of the output y according to a model is evaluated by the sum of
squares weighted by w.
}
\section{Methods (by generic)}{
\itemize{
\item \code{dim}: retrieves p, q and n
}}

\examples{
x <- dplyr::transmute(cars, speed = scale(speed))
y <- dplyr::transmute(cars, dist = scale(dist))
minimal_task_1 <- minimal_task(x, y)
minimal_task_1

}
