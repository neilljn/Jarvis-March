\name{jarvis_march_points}
\alias{jarvis_march_points}
\title{Runs the Jarvis-March Algorithm}
\usage{
jarvis_march_points(dataset)
}
\arguments{
\item{dataset}{A list of vectors of length 2, each representing a point in 2 dimensions.}
}
\value{
A list of vectors of length 2, each representing a point on the convex hull.
}
\description{
This function runs the Jarvis-March algorithm on a set of 2-dimensional points. Unlike the other functions in this package, it only accepts a list of 2-vectors (not a dataframe or vector).
}