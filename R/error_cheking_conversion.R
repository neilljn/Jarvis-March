#' Error Checking
#'
#' This function converts vectors and dataframes into lists, and checks for any errors.
#' @param dataset The dataset to be checked.
#' @return If `dataset` is a list of 2-vectors, a dataframe with two columns (with numerical entries), or a vector with an even number of numeric entries, then a list of 2-vectors is returned. Otherwise an error message is returned.

error_checking_conversion <- function(dataset){
  
  # checking the input type
  input_type <- class(dataset)
  
  # returning an error if the dataset is empty
  if(input_type=="NULL"){
    return("the dataset is empty")
  }
  
  # returning an error if the input type is not a list or dataframe or vector (numeric with length > 1)
  if(input_type!="list"){
    if(input_type!="data.frame"){
      if(input_type!="numeric"){
        return("you have not inputted an accepted data type (list, dataframe, or vector)")
      }
    }
  }
  
  # error checking for list
  if(input_type=="list"){
    if(length(dataset)==0){
      return("the dataset is empty")
    }
    for(i in 1:length(dataset)){
      if(class(dataset[[i]])!="numeric"){
        return("the dataset contains elements that are not numeric points")
      }
    }
    for(i in 1:length(dataset)){
      if(length(dataset[[i]])!=2){
        return("the dataset has points that are not in two dimensions")
      }
    }
  }
  
  # error checking for dataframe
  if(input_type=="data.frame"){
    if(length(dataset)==0){
      return("the dataset is empty")
    }
    for(i in 1:length(dataset[1,])){
      for(j in 1:length(dataset[,1])){
        if(class(dataset[j,i])!="numeric"){
          return("the dataset contains elements that are not numeric points")
        }
      }
    }
    if(length(dataset)!=2){
      return("the dataset has points that are not in two dimensions")
    }
  }
  
  # error checking for vector
  if(input_type=="numeric"){
    if(length(dataset)==0){
      return("the dataset is empty")
    }
    if(length(dataset)==1){
      return("you have not inputted an accepted data type (list, dataframe, or vector)")
    }
    length_mod_2 <- length(dataset)%%2
    if(length_mod_2==1){
      return("the dataset cannot be a set of two-dimensional points, since it contains an odd number of elements")
    }
  }
  
  # converting a dataframe into a list
  if(input_type=="data.frame"){
    dataset_2 <- list()
    for(i in 1:length(dataset[,1])){
      dataset_2[[i]] <- c(dataset[i,1],dataset[i,2])
    }
    dataset <- dataset_2
  }
  
  # converting a vector into a list
  if(input_type=="numeric"){
    dataset_2 <- list()
    length_divide_2 <- length(dataset)/2
    for(i in 1:length_divide_2){
      dataset_2[[i]] <- c(dataset[(2*i)-1],dataset[2*i])
    }
    dataset <- dataset_2
  }
  
  # returning a list of 2-vectors
  return(dataset)
}
