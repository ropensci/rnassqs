<!-- README.md is generated from README.Rmd. Please edit that file -->

[![ORCiD](https://img.shields.io/badge/ORCiD-0000--0002--3410--3732-green.svg)](http://orcid.org/0000-0002-3410-3732)
[![DOI](https://zenodo.org/badge/37335585.svg)](https://zenodo.org/badge/latestdoi/37335585)

[![License](https://img.shields.io/github/license/mashape/apistatus.svg)](http://choosealicense.com/licenses/mit/)

[![Build
Status](https://travis-ci.org/potterzot/rnassqs.svg?branch=master)](https://travis-ci.org/potterzot/rnassqs)
[![Last-changedate](https://img.shields.io/badge/last%20change-2019--05--01-brightgreen.svg)](https://github.com/potterzot/rnassqs/commits/master)
[![Coverage
Status](https://coveralls.io/repos/github/potterzot/rnassqs/badge.svg?branch=master)](https://coveralls.io/github/potterzot/rnassqs?branch=master)

## rnassqs (R NASS Quick Stats)

This is a package that allows users to access the USDA’s National
Agricultural Statistics Service (NASS) ‘Quick Stats’ data through their
API. It is fairly low level and does not include a lot of scaffolding or
setup. Some things may change, but at this point it is relatively
stable.

## Installing

Install should be simple via either devtools or CRAN:

    # Via devtools
    library(devtools)
    install_github('potterzot/rnassqs')
    
    # Via CRAN
    install.packages("rnassqs")

## API Key

To use the NASS Quick Stats API you need an [API
key](http://quickstats.nass.usda.gov/api). There are several ways of
clueing the rnassqs package in to your api key. You can set the variable
explicitly and pass it to functions, like so

    params <- list(...)                    # parameters for query 
    api_key <- "<your api key here>"       # api key
    data <- nassqs(params, key = api_key)  # query and return data

Alternatively, you can set the api key as an environmental variable
either by adding it to your `.Renviron` like so:

    NASSQS_TOKEN="<your api key here>"

or by setting it explicitly in the console by calling
`rnassqs::nassqs_auth()`. This will prompt you to enter the api key if
not set, and return the value of the api key if it is set. If you do not
set the key and you are running the session interactively, R will ask
you for the key when you try to issue a query.

## Usage

See the examples in [inst/examples](inst/examples) for quick recipes to
download data.

The most basic level of access is with `nassqs()`, with which you can
make any query of variables. For example, to mirror the request that is
on the [NASS API documentation](http://quickstats.nass.usda.gov/api),
you can use:

    library(nassqs)
    params = list("commodity_desc"="CORN", "year__GE"=2012, "state_alpha"="VA")
    d = nassqs(params=params, key=your_api_key)

You can request data for multiple values of the same parameter by as
follows:

    params = list("commodity_desc"="CORN", "year__GE"=2012, "state_alpha" = c("VA", "WA"))
    d = nassqs(params=params, key=your_api_key)

NASS does not allow GET requests that pull more than 50,000 records in
one request. The function will inform you if you try to do that. It will
also inform you if you’ve requested a set of parameters for which there
are no records.

Other useful functions
    include:

    # returns a set of unnique values for the parameter "STATISTICCAT_DESC"
    nassqs_param_values("statisticcat_desc", key = your_api_key)
    
    # returns a count of the number of records for a given query
    nassqs_record_count(params=params, key=your_api_key)
    
    # Get yields specifically
    # Equivalent to including "'statisticat_desc' = 'YIELD'" in your parameter list. 
    nassqs_yield(params, key = your_api_key)
    
    # Get area specifically
    # Equivalent to including all "AREA" values in statisticcat_desc
    nassqs_area(params, key = your_api_key)
    
    # Specifies just "AREA HARVESTED" values of statisticcat_desc
    nassqs_area(params, area = "AREA HARVESTED", key = your_api_key)

### Separating the GET request and the parsing

If you prefer to process the returned request separately, you can
specify just the GET request with

    d = nassqs_GET(params=params, key=your_api_key)

To parse it, you can use

    nassqs_parse(d)

If you need JSON or CSV returned, the option `format = "JSON"` or
`format = "CSV"` will do that. Both return a data.frame though, so
there’s no difference unless you also pass `as = "raw"` to `nassqs()`
to leave the response as raw text. This will return either a JSON string
or a CSV string that you can parse as you see fit.

### Handling inequalities and operators other than “=”

The NASS API handles other operators by modifying the variable name. The
API can accept the following modifications:

  - \_\_LE: \<=
  - \_\_LT: \<
  - \_\_GT: \>
  - \_\_GE: \>=
  - \_\_LIKE: like
  - \_\_NOT\_LIKE: not like
  - \_\_NE: not equal

For example, to request corn yields in Virginia and Pennsylvania for all
years since 2000, you would use something like:

    params = list("commodity_desc"="CORN", 
                  "year__GE"=2000, 
                  "state_alpha"=c("VA", "PA"), 
                  "statisticcat_desc"="YIELD")
    df = nassqs(params=params) #returns data as a data frame.

## Alternatives

NASS also provides a daily tarred and gzipped file of their entire
dataset. At the time of writing it is approaching 1 GB. You can download
that file from their FTP:

<ftp://ftp.nass.usda.gov/quickstats>

The FTP link also contains builds for: NASS’ census (every 5 years, the
next is 2017), or data for one of their specific sectors (CROPS,
ECONOMICS, ANIMALS & PRODUCTS). At the time of this writing, specific
files for the ENVIRONMENTAL and DEMOGRAPHICS sectors are not available.
