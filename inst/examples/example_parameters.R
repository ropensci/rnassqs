# Example parameter settings to fetch different types of data

library(rnassqs)

# Set your api key. Generally not good to put directly into scripts. See the 
# vignette or the README for other methods
api_key <- "<your api key>"
  
# For any set of parameters, fetch data with
data <- nassqs(params, key = api_key)

# Parameter Examples -----------------------------------------------------------

# Irrigated cropland cash rents from 1997 onward
cash_rent_cropland_irr = list(sector_desc = "ECONOMICS",
                  commodity_desc = "RENT",
                  prodn_practice_desc = "IRRIGATED",
                  class_desc = "CASH, CROPLAND",
                  agg_level_desc = "COUNTY",
                  year__GE = 1997)

# Non-irrigated cropland cash rents from 1997 onward
cash_rent_cropland_nirr = list(sector_desc = "ECONOMICS",
                  commodity_desc = "RENT",
                  prodn_practice_desc = "NON-IRRIGATED",
                  class_desc = "CASH, CROPLAND",
                  agg_level_desc = "COUNTY",
                  year__GE = 1997)

# Pastureland cash rents at the State level
cash_rent_pastureland = list(sector_desc = "ECONOMICS",
                  commodity_desc = "RENT",
                  class_desc = "CASH, PASTURLAND",
                  agg_level_desc = "STATE")

# Net income of operations, total dollars
net_income = list(sector_desc = "ECONOMICS",
                  commodity_desc = "INCOME, NET CASH FARM",
                  class_desc = "OF OPERATIONS",
                  statisticcat_desc = "NET INCOME",
                  unit_desc = "$",
                  agg_level_desc = "COUNTY",
                  year__GE = 1997)

# Acres of ag cropland
ag_cropland = list(sector_desc = "ECONOMICS",
                  commodity_desc = "AG LAND",
                  agg_level_desc = "COUNTY",
                  class_desc = "CROPLAND",
                  unit_desc = "ACRES",
                  statisticcat_desc = "AREA",
                  year__GE = 1997)

# Acres of irrigated ag cropland
ag_cropland_irr = list(sector_desc = "ECONOMICS",
                       commodity_desc = "AG LAND",
                       agg_level_desc = "COUNTY",
                       class_desc = "CROPLAND",
                       unit_desc = "ACRES",
                       prodn_practice_desc = "IRRIGATED",
                       statisticcat_desc = "AREA",
                       year__GE = 1997)

#Total irrigated ag land
ag_land_irr = list(sector_desc = "ECONOMICS",
                        commodity_desc = "AG LAND",
                        agg_level_desc = "COUNTY",
                        prodn_practice_desc = "NON-IRRIGATED",
                        class_desc = "ALL CLASSES",
                        unit_desc = "ACRES",
                        domain_desc = "TOTAL",
                        year__GE = 1997)

#Ag sales
ag_sales = list(sector_desc = "ECONOMICS",
                commodity_desc = "COMMODITY TOTALS",
                agg_level_desc = "COUNTY",
                statisticcat_desc = "SALES",
                util_practice_desc = "ALL UTILIZATION PRACTICES",
                unit_desc = "$",
                domain_desc = "TOTAL",
                domaincat_desc = "NOT SPECIFIED",
                year__GE = 1997)