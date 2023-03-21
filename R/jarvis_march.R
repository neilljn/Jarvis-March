#' Runs the Jarvis-March Algorithm
#'
#' This function runs the Jarvis-March algorithm on a set of 2-dimensional points.
#' @param dataset A list of vectors of length 2, each representing a point in 2 dimensions. May also accept a dataframe or vector.
#' @return A list of vectors of length 4, each representing a line segment of the convex hull.
#' @export
#' @examples
#' dat <- list(c(1,1),c(1,2),c(2,1),c(2,2),c(1.5,1.5))
#' jarvis_march(dat)

jarvis_march <- function(dataset){
  
  # checking for errors and making sure we have a list of 2-vectors
  dataset <- error_checking_conversion(dataset)
  
  # if we have an error message, just return it instead
  if(class(dataset)=="character"){
    return(dataset)
  }
  
  # running the jarvis-march algorithm from c++ on the list
  convex_hull_points <- jarvis_march_points(dataset)
  
  # converting the list of points to a list of line segments
  convex_hull <- list()
  for(p in 1:(length(convex_hull_points)-1)){
    convex_hull[[p]] <- c(convex_hull_points[[p]][1],convex_hull_points[[p]][2],convex_hull_points[[p+1]][1],convex_hull_points[[p+1]][2])
  }
  
  # outputting a list of vectors
  return(convex_hull)
  
}
