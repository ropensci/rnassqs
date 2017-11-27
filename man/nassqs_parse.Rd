% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nassqs.R
\name{nassqs_parse}
\alias{nassqs_parse}
\title{Parse the returned request.}
\usage{
nassqs_parse(req, as = c("data.frame", "list", "raw"), ...)
}
\arguments{
\item{req}{the GET request.}

\item{as}{indicates type of data returned. Can be one of "list", "js", or "dataframe".}

\item{...}{additional parameters passed to \code{\link{nassqs_parse.json}}}
}
\value{
a data frame of the content from the request.
}
\description{
Returns a data frame. All values are strings.
}