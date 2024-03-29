% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stopping_rule.R
\name{stopping_rule}
\alias{stopping_rule}
\alias{is_stopping_rule}
\alias{max_iterations}
\alias{stopping_distance}
\title{Stopping rules}
\usage{
stopping_rule(max_iterations, stopping_distance = 0)

is_stopping_rule(x)

max_iterations(stopping_rule)

stopping_distance(stopping_rule)
}
\arguments{
\item{max_iterations}{What is the maximum number of iterations?}

\item{stopping_distance}{At what distance should the algorithm stop?}

\item{x}{an object.}

\item{stopping_rule}{A stopping rule.}

\item{stopping_rule}{A stopping rule.}
}
\description{
This small function helps to instantiate stopping rules in an intuitive way.
}
