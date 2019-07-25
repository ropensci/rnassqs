#' Expand an ellipsis list.
#' 
#' This function takes an ellipsis list of the form `...` and returns an 
#' expanded list
#' @keywords internal
#' @importFrom stats setNames
#' @importFrom utils stack
#' @noRd
#' 
#' @param ... either a list or a series of strings to be expanded
#' @return a named list.
expand_list <- function(...){
  x <- list(...)
  listx <- if(is.null(names(x))) x[[1]] else x
  res <- stack(listx)  
  as.list(setNames(res$values, res$ind))
}
