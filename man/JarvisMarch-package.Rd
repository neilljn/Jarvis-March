\name{JarvisMarch}
\alias{JarvisMarch}
\alias{JarvisMarch}
\docType{package}
\title{
  Find the Convex Hull using the Jarvis-March Algorithm
}
\description{
  Find the convex hull of a dataset of points in two dimensions using the Jarvis-March algorithm. We can also plot the convex hull of a dataset and determine if other points are inside the convex hull of a dataset.
}
\details{
  This package contains three primary functions: 'jarvis_march', to find the convex hull of a dataset of points as a list of line segments; 'plot_hull', which plots the convex hull of a dataset of points; and 'in_hull', which determines if other points are in the convex hull. Each function takes as input a list of 2-vectors, where each 2-vector represents a point in 2-dimensional space (x,y). The functions may instead take as input a dataframe or a single vector.
}
\author{
James Neill

Maintainer: James Neill <j.neill@lancaster.ac.uk>
}
