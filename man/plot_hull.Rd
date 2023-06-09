% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_hull.R
\name{plot_hull}
\alias{plot_hull}
\title{Plots the Jarvis-March algorithm.}
\usage{
plot_hull(dataset)
}
\arguments{
\item{dataset}{A list of vectors of length 2, each representing a point in 2 dimensions. May also accept a dataframe or vector.}
}
\value{
A plot of the dataset (black points) along with the convex hull of the dataset (red points and line segments).
}
\description{
This function plots a set of 2-dimensional points, along with the convex hull of those points. Requires `ggplot2` package.
}
