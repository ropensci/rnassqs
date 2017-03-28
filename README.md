<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.org/potterzot/rnassqs.svg?branch=master)](https://travis-ci.org/potterzot/rnassqs)

rnassqs (R NASS QuickStats)
---------------------------

This is a package that allows users to access the NASS quickstats data through their API. It is in a very early stage, but should be usable enough. Some aspects may change. You have been warned.

Installing
----------

Install like any R package from github:

    library(devtools)
    install_github('potterzot/rnassqs')

API Key
-------

To use the NASS Quickstats API you first have to [request an API key](http://quickstats.nass.usda.gov/api). You can either set a variable to this key in your files (though you run the risk of making it public, which is not a huge deal here), or you can set it in the console or in your environmental variables. To set the API key in the environment, create or edit a file in your home directory named `.Renviron`. Add a line like this:

    NASSQS_TOKEN="your_api_key"

If you do not set the key and you are running the session interactively, R will ask you for the key at the console and then store it for the rest of the session.

Usage
-----

The most basic level of access is with `nassqs_GET()`, with which you can make any query of variables. For example, to mirror the request that is on the [NASS API documentation](http://quickstats.nass.usda.gov/api), you can do:

    library(nassqs)
    params = list("commodity_desc"="CORN", "year__GE"=2012, "state_alpha"="VA")
    req = nassqs_GET(params=params, key=your_api_key)
    qsJSON = nassqs_parse(req)

Note that you can request data for multiple values of the same parameter by as follows:

    params = list("commodity_desc"="CORN", "year__GE"=2012, "state_alpha"="VA", "state_alpha"="WA")
    req = nassqs_GET(params=params, key=your_api_key)
    qsJSON = nassqs_parse(req)

NASS does not allow GET requests that pull more than 50,000 records in one request. The function will inform you if you try to do that. It will also inform you if you've requested a set of parameters for which there are no records.

### Handling inequalities and operators other than "="

The NASS API handles other operators by modifying the variable name. The API can accept the following modifications: \* \_\_LE = &lt;= \* \_\_LT = &lt; \* \_\_GT = &gt; \* \_\_GE = &gt;= \* \_\_LIKE = like \* \_\_NOT\_LIKE = not like \* \_\_NE = not equal \_\_LE = &lt;=

For example, to request corn yields for all years since 2000, you would use something like:

    params = list("commodity_desc"="CORN", 
                  "year__GE"=2000, 
                  "state_alpha"="VA", 
                  "statisticcat_desc"="YIELD")
    df = nassqs(params=params) #returns data as a data frame.

You could also use the helper function `nassqs_yield()`:

    nassqs_yield(list("commodity_desc"="CORN", "agg_level_desc"="NATIONAL")) #gets US yields

Alternatives
------------

NASS also provides a daily tarred and gzipped file of their entire dataset. At the time of writing it is approaching 1 GB. You can download that file from their FTP:

<ftp://ftp.nass.usda.gov/quickstats>

The FTP link also contains builds for: NASS' census (every 5 years, the next is 2017), or data for one of their specific sectors (CROPS, ECONOMICS, ANIMALS & PRODUCTS). At the time of this writing, specific files for the ENVIRONMENTAL and DEMOGRAPHICS sectors are not available.
