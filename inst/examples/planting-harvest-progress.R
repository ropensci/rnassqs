# Script for estimating the date for which 50% of farms within a given state
# have planted & harvested their crop, based on NASS surveys
# Author: Austin

# Packages/dependecies
library(tidyverse) # for data wrangling and plotting
library(lubridate) # working with dates
library(assertthat) # for error check later on
library(rnassqs) # for calling NASS stats

# replace with your own API key
api_key <- "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"

nassqs_auth(key = api_key)

# Look up query parameters available
nassqs_param_values("statisticcat_desc") |>
  enframe() |>
  filter(str_detect(value, "PROGRESS")) # "PROGRESS, 5 YEAR AVG" looks promising

# Function for getting NASS data
get_nass_df <- function(yr, crop) {
  params_list <- list(
    year = yr,
    source_desc = "SURVEY",
    sector_desc = "CROPS",
    group_desc = "FIELD CROPS",
    statisticcat_desc = "PROGRESS, 5 YEAR AVG",
    unit_desc = c("PCT PLANTED", "PCT HARVESTED"),
    agg_level_desc = "STATE",
    commodity_desc = crop
  )
  
  n_records <- nassqs_record_count(params_list)$count
  assertthat::assert_that(n_records < 50000)
  
  output_df <- nassqs(params_list) |> as_tibble()
  
  return(output_df)
}

# If this fails, try running it again. Sometimes the API seems to struggle
dates <-
  purrr::map(2022, get_nass_df, c("COTTON", "PEANUTS")) |>
  purrr::list_rbind() |>
  mutate(week_ending = ymd(week_ending)) # convert character to date

# Summary table
# The following uses the two dates associated with the two lowest differences
# to 50% progress, and performs a weighted average based on their respective
# closeness to 50%. Note that a small factor (1e-9) was added for when
# `diff == 0` so that the calculation could proceed (Can't divide 1 by 0).

tbl_progress <-
  dates |> group_by(year,
                    commodity_desc,
                    class_desc,
                    prodn_practice_desc,
                    util_practice_desc,
                    unit_desc,
                    state_name) |>
  mutate(diff = abs(Value - 50)) |>
  slice_min(diff, n = 2) |>
  mutate(tmp1 = 1 / (diff + 1e-9),
         tmp2 = sum(tmp1),
         weight = tmp1 / tmp2,
         date_approx50 = weighted.mean(week_ending, weight)) |>
  slice(1) |> # to get rid of the duplicated dates
  ungroup() |>
  arrange(year,
          commodity_desc,
          state_name,
          desc(unit_desc))

# View table in markdown format
knitr::kable(
  tbl_progress |>
    select(
      year,
      commodity_desc,
      state_name,
      statisticcat_desc,
      unit_desc,
      Value,
      diff,
      week_ending,
      date_approx50
    )
)
  
