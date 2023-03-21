#' Plots the Jarvis-March algorithm.
#'
#' This function plots a set of 2-dimensional points, along with the convex hull of those points. Requires `ggplot2` package.
#' @param dataset A list of vectors of length 2, each representing a point in 2 dimensions. May also accept a dataframe or vector.
#' @return A plot of the dataset (black points) along with the convex hull of the dataset (red points and line segments).
#' @export
#' @examples
#' dat <- list(c(1,1),c(1,2),c(2,1),c(2,2),c(1.5,1.5))
#' plot_hull(dat)

plot_hull <- function(dataset){
  
  # loading the ggplot package
  library(ggplot2)
  
  # checking for errors and making sure we have a list of 2-vectors
  dataset <- error_checking_conversion(dataset)
  
  # if we have an error message, just return it instead
  if(class(dataset)=="character"){
    return(dataset)
  }
  
  #dealing with the special case where there is no convex hull (when we only have one point)
  if(length(dataset)==1){
    df_data <- as.data.frame(dataset, row.names=c("X","Y"))
    df_data <- as.data.frame(t(df_data))
    hull_plot <- ggplot() + geom_point(aes(x=X,y=Y),df_data)
    return(hull_plot)
  }
  
  # running the jarvis-march algorithm to find the convex hull
  hull <- jarvis_march_points(dataset)
  
  # making a new hull as a list of points rather than edges
  #h <- length(hull)
  #hull_v2 <- list()
  #for(i in 1:h){
    #hull_v2[[i]] <- c(hull[[i]][1],hull[[i]][2])
  #}
  #hull_v2[[h+1]] <- c(hull[[h]][3],hull[[h]][4])
  
  # converting both the dataset and hull into dataframes
  df_data <- as.data.frame(dataset, row.names=c("X","Y"))
  df_hull <- as.data.frame(hull, row.names=c("X_hull","Y_hull"))
  df_data <- as.data.frame(t(df_data))
  df_hull <- as.data.frame(t(df_hull))
  
  # creating the plot
  hull_plot <- ggplot() + geom_point(aes(x=X,y=Y),df_data) + geom_point(aes(x=X_hull,y=Y_hull),df_hull,col="red") + geom_path(aes(x=X_hull,y=Y_hull),df_hull,col="red")
  
  # outputting the plot
  return(hull_plot)
  
}
