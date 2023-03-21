#' Determines if Points are in the Convex Hull
#'
#' This function checks if points in a list are in the convex hull of a set of points.
#' @param dataset The main set of points - a list of vectors of length 2, each representing a point in 2 dimensions. May also accept a dataframe or vector.
#' @param pointset The points to check if they are in the convex hull - a list of vectors of length 2, each representing a point in 2 dimensions. May also accept a dataframe or vector.
#' @return A list where each entry corresponds to the respective entry in the pointset, stating the determination for that point. The determination is either "a vertex of the convex hull", "on an edge of the convex hull (but not a vertex)", "inside the convex hull, or "outside the convex hull".
#' @export
#' @examples
#' dat <- list(c(1,1),c(1,2),c(2,1),c(2,2),c(1.5,1.5))
#' poi <- list(c(1,1),c(1.5,1),c(1.25,1.25),c(3,3))
#' in_hull(dat,poi)

in_hull <- function(dataset,pointset){
  
  # checking for errors and making sure we have lists of 2-vectors
  dataset <- error_checking_conversion(dataset)
  pointset <- error_checking_conversion(pointset)
  
  # if we have an error message, just return it instead
  if(class(dataset)=="character"){
    return(paste("main data error:", dataset))
  }
  if(class(pointset)=="character"){
    return(paste("points for comparison error:", pointset))
  }
  
  # running the jarvis-march algorithm to find the convex hull
  hull <- jarvis_march(dataset)
  
  # the sizes of the lists
  n <- length(pointset)
  m <- length(dataset)
  h <- length(hull)
  
  # creating a list that will be amended with the status of each point
  in_hull_list <- list()
  for(i in 1:n){
    in_hull_list[[i]] <- 0
  }
  
  # checking each point in the pointset
  for(i in 1:n){
    
    # checking if the point is a vertex of the hull
    for(j in 1:h){
      if((pointset[[i]][1]==hull[[j]][1])&(pointset[[i]][2]==hull[[j]][2])){
        in_hull_list[[i]] <- "a vertex of the convex hull"
      }
      if((pointset[[i]][1]==hull[[j]][3])&(pointset[[i]][2]==hull[[j]][4])){
        in_hull_list[[i]] <- "a vertex of the convex hull"
      }
    }
    
    # checking if the point lies on an edge of the hull (but not a vertex)
    if(in_hull_list[[i]]==0){
      for(j in 1:h){
        a <- hull[[j]][1]
        b <- hull[[j]][2]
        c <- hull[[j]][3]
        d <- hull[[j]][4]
        if((c-a)!=0){
          delta_x <-(pointset[[i]][1]-a)/(c-a)
        }
        if((d-b)!=0){
          delta_y <-(pointset[[i]][2]-b)/(d-b)
        }
        if(((c-a)==0)&((d-b)!=0)){
          if(pointset[[i]][1]==a){
            delta_x <- delta_y
          }
          else{
            delta_x <- 2
          }
        }
        if(((d-b)==0)&((c-a)!=0)){
          if(pointset[[i]][2]==b){
            delta_y <- delta_x
          }
          else{
            delta_y <- 2
          }
        }
        if ((delta_x==delta_y)){
          if((delta_x>0)&(delta_x<1)&(delta_y>0)&(delta_y<1)){
            in_hull_list[[i]] <- "on an edge of the convex hull (but not a vertex)"
          }
        }
      }
    }
    
    # checking if the point is inside or outside the hull (when the hull is a polygon)
    if(in_hull_list[[i]]==0){
      dataset_amended <- dataset
      dataset_amended[[m+1]] <- pointset[[i]]
      hull_amended <- jarvis_march(dataset_amended)
      if(length(hull_amended)!=length(hull)){
        in_hull_list[[i]] <- "outside the convex hull" 
      }
      else{
        for(j in 1:h){
          for(k in 1:4){
            if(hull_amended[[j]][k]!=hull[[j]][k]){
              in_hull_list[[i]] <- "outside the convex hull"
            }
          }
        }
      }
    }
    if(in_hull_list[[i]]==0){
      in_hull_list[[i]] <- "inside the convex hull"
    }
    
  }
  
  # outputting the list corresponding to the list of points provided
  return(in_hull_list)
  
}
