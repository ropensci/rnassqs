#' Expand an ellipsis list.
#' 
#' This function takes an ellipsis list of the form `...` and returns an 
#' expanded list
#'
#' @importFrom stats setNames
#' @importFrom utils stack
#' @keywords internal
#' @noRd
#' 
#' @param ... either a list or a series of strings to be expanded
#' @return a named list.
expand_list <- function(...){
  x <- list(...)
  if(length(x) == 0) { stop("No parameters were supplied.")}
  listx <- if(is.null(names(x))) x[[1]] else x
  res <- stack(listx)  
  as.list(setNames(res$values, res$ind))
}


#' Check that a parameter is a valid API parameter.
#'
#' Takes a string and checks against the list of valid parameters.
#'
#' @keywords internal
#' @noRd
#'
#' @param param the parameter to check
#' @return logical
parameter_is_valid <- function(param) {
  valid_params <- toupper(nassqs_params())
  param2 <- gsub("__LE|__LT|__GT|__GE|__LIKE|__NOT_LIKE|__NE", "", toupper(param))
  
  if(!param2 %in% valid_params) {
    stop("Parameter '", param, "' is not a valid parameter. Use `nassqs_params()`
    for a list of valid parameters.")
  }
  return(TRUE)
}

#' Convert Quick Stats "Value" to numeric
#' 
#' @keywords internal
#' @noRd
#'
#' @param x an array of values in character format.
#' @return numeric
char_to_num <- function(x) {
  regex_str <- ",|NA|\\(D\\)|\\(Z\\)"
  as.numeric(gsub(regex_str, "", x)) 
}
