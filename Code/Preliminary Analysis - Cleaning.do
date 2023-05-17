**************************************
*                                    *
*                                    *
*         Minerals Project           *
*                                    *
*                                    *
**************************************

global wd "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/Mineral Prices and Human Capital/Working Data"

global origd "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/Mineral Prices and Human Capital/Original Data"


cd "$wd"

use "$origd/dfhsw_GRD_public_v1.dta", clear

keep if country == "india"

cd "$wd"

save dfhsw_India.dta

tab year

tab resource 

tab resource year

// Count unique observations
levelsof admin1, l(values_num)

local count_values_num: word count of `values_num'
di "Number of numeric values: `count_values_num'"

// Attempting to install/find the right command

ssc install geocode3
ssc install insheetjson 
ssc install libjson


**************************************
*                                    *
*         Reverse Geocoding          *
*                                    *
**************************************

ssc install opencagegeo

// trying opencagegeo

use dfhsw_India.dta, clear

global mykey "a39fd81fb8fd4485876c4f72618f9d1f"

keep if obs_no == 28064
keep if year == 1994

opencagegeo, key($mykey) latitude(latitude) longitude(longitude) replace

save geocode_example.dta

// Now for real:

use "dfhsw_India.dta", clear

opencagegeo, key($mykey) latitude(latitude) longitude(longitude) replace

save geocode_sample.dta

save geocode_sample_unmatched_4_27.dta

use geocode_sample_unmatched_4_27.dta, clear

keep if g_lat == ""

opencagegeo, key($mykey) latitude(latitude) longitude(longitude) replace // need to try again at 11pm 4/27

save geocode_sample_unmatched_4_27.dta, replace
******************

use geocode_sample.dta 

drop if g_lat == ""

keep if g_county == ""

tab latitude // 15 mines have a missing county

clear 

use geocode_sample.dta 

keep if g_city == ""

unique latitude

************ doing it in a smarter way

use dfhsw_India.dta, clear

global pittkey "1cb9a90f9fe9422f8fe98e149e549ee9"

drop if latitude == .
drop if longitude == .
sum latitude, detail
sum orig_deflator, detail


drop latlong
egen latlong = concat(latitude longitude), format(%25.0g) punct(" , ") 

unique latlong

foreach v of var * {
	local l`v' : variable label `v'
	if `"`l`v''"' == "" {
		local l`v' "`v'"
 	}
  }
  
collapse (firstnm) minetype mineownership locationname admin1 admin2   (mean) latitude longitude precisioncode , by(latlong) 

foreach v of var * {
	label var `v' `"`l`v''"'
}

save unique_geolocs.dta, replace


opencagegeo, key($pittkey) latitude(latitude) longitude(longitude) replace

global annkey "f43f6f3bb3c74af6a92c445d8b907928"

opencagegeo, key($annkey) latitude(latitude) longitude(longitude) replace

save unique_geolocs.dta, replace

tab g_country

drop if g_country == "Bangladesh"

save unique_geolocs.dta, replace


/// python stuff

// then import the csv file manually
save geo_data_districts.dta

use geo_data_districts.dta

///

use dfhsw_India.dta, clear

// drop latlong
egen latlong = concat(latitude longitude), format(%25.0g) punct(" , ") 

merge m:1 latlong using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/Mineral Prices and Human Capital/Working Data/geo_data_districts.dta"

drop if _merge == 1 // this observation is actually in Bangladesh

save india_mines_dists.dta

cd "$wd"

use india_mines_dists.dta, clear

encode resource, gen(resource_id)

// thanks to this guy https://www.btskinner.io/code/create-dummy-variables-from-categorical-variables-keeping-labels-stata/
// 

// dummy for categorical variables
#delimit;
local makedummy resource_id
// place categorical vars here

;
#delimit cr

local i = 1

foreach var of local makedummy {
    // get overall label
    local l`var' : variable label `var'
    // get all values for var
    levelsof `var', local(`var'_levels)
    // need for later
    local frst = substr("`r(levels)'",1,1)
    // store values individually
    foreach val of local `var'_levels {
        local `var'vl`val' : label `var' `val'
    }
    // create dummies from var
    tab `var', gen(d`var')
    // for each new dummy ...
    foreach dum of varlist d`var'* {
        local num = substr("`dum'",-2,2) // I had to edit this because there are more than 10 categories. So mora than 1 digits (here -2 and 2)
        foreach value of local `var'_levels {
            // if 0/1 binary or cat. that starts with 0
            if `frst' == 0 {
                // label new dummy with old value
                if `num' == `value' + 1 {
                    label variable `dum' "`l`var'' - ``var'vl`value''"
                }
            }
            // if 1/2 binary or cat. that starts with 1
            if `frst' == 1 {
                // label new dummy with old value
                if `num' == `value' {
                    label variable `dum' "`l`var'' - ``var'vl`value''"
                }
            }
        }
        // add dummy var name to local
        local dumvarlist `dumvarlist' `dum'
    }
}

describe `dumvarlist'

// END CODE SNIPPET

// There will be an error. Pick up here 

// Creating an interaction for the capacity variable, so we can have capcacity for each resource in each district year (post collapsing) 

foreach var of varlist dresource_id*{
	
	ds `var'
	local varname = r(varlist)
	local idnum = substr("`varname'",13,.)
	
	gen prod_resource_id`idnum' = `var' * annuallocationcapacity
	
	local `var'_lab: variable label `var'
	
	label variable prod_resource_id`idnum' `var'_lab 
}                                                                                                         

// Doing the same thing for units and prices now
// These are all of them:
global all_prices_index = "comtrade_unit wb_unit usgs_unit multicolour_unit comtrade_price wb_price usgs_price multicolour_price"
// but I'm going to start with only world bank prices


// Need to create standardized prices
egen wb_price_std = std(wb_price), by(resource)

foreach ind of varlist wb_unit wb_price wb_price_std { 
	
foreach var of varlist dresource_id* {
	
	ds `var'
	local varname = r(varlist)
	local idnum = substr("`varname'",13,.)
	
	gen `ind'_id`idnum' = `var' * `ind'
	
	local `var'_lab: variable label `var'
	
	label variable `ind'_id`idnum' `var'_lab 
}                                                                                                         

}

save india_mines_dists_dummies.dta, replace


// Creating district identifiers
use  india_mines_dists_dummies.dta, clear

// egen ds = concat(DistrictName StateName)

egen sdname = concat( StateName DistrictName)

// Now we can collapse

// Note that for prices, we only have one price per year (for all districts)
foreach v of var * {
	local l`v' : variable label `v'
	if `"`l`v''"' == "" {
		local l`v' "`v'"
 	}
  }

collapse  (max) dresource_id* wb_price* (sum) prod_resource_id*  (firstnm) country DistrictName StateName latlong latitude longitude standardmeasure wb_unit* , by(year sdname)

foreach v of var * {
	label var `v' `"`l`v''"'
}

save dist_lvl_minerals.dta, replace

egen sd_id = concat(sdname year)

save dist_lvl_minerals.dta, replace

// From here go to preliminiary analysis
