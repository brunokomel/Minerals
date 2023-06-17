**************************************
*                                    *
*                                    *
*         Minerals Project           *
*                                    *
*                                    *
**************************************

global wd "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data"

global origd "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Original Mining Data"

cd "$wd"

use "$origd/dfhsw_GRD_public_v1.dta", clear

keep if country == "india"

cd "$wd"

save dfhsw_India.dta, replace

tab year

tab resource 

tab resource year

bysort resource : egen mean_capacity = mean(annuallocationcapacity) 

gen mean_cap_temp = -mean_capacity // putting a negative so that the ranking is from highest value to lowest

egen rank = group(mean_cap_temp resource)  // this will rank the resources according to their mean allocation capacity

drop mean_cap_temp

// note here that coal ranks 7th in average allocation capacity

******* Selecting the top "how many" resources by production *******

local how_many = 4 // change this to how many of the top resources we want 
// for top 4, it's diamonds, oil/petroleum products, and phosphate


gen top`how_many' = rank <= `how_many'

keep if top`how_many' == 1 | resource == "coal"

save dfhsw_India.dta, replace

******* *******

// Count unique observations
levelsof admin1, l(values_num)

local count_values_num: word count of `values_num'
di "Number of numeric values: `count_values_num'"

// Using the file that Ritadhi created

use "/Users/brunokomel/Library/CloudStorage/Dropbox/Human Capital/Data/NSS Mining Data Map/cross_country_mining_raw_state_district.dta", clear

ren district final_dist_1991

format %20.0g latitude longitude

egen latlong = concat(latitude longitude), format(%25.0g) punct(" , ") 

collapse (firstnm) final_dist_1991 state latitude longitude, by(latlong)

merge 1:m latitude longitude using "$wd/dfhsw_India.dta"

drop _merge 

save india_mines_dists_1991.dta, replace // using the district boundaries from 1991

use india_mines_dists_1991.dta, clear

encode resource, gen(resource_id)

// thanks to this guy https://www.btskinner.io/code/create-dummy-variables-from-categorical-variables-keeping-labels-stata/
// 

// dummy for categorical variables
#delimit;
local makedummy resource_id ; 
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
		qui ds `dum'
		if length(r(varlist)) == 13 {  // I had to edit this because there are more than 10 categories. So some variable ids have more than 1 digits (for these, we change substr("`dum'",-1,1) to substr("`dum'",-2,2)
        local num = substr("`dum'",-1,1)
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
		else {
			local num = substr("`dum'",-2,2) // I had to edit this because there are more than 10 categories. So more than 1 digits (here -2 and 2)
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
}

describe `dumvarlist'


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
foreach var of varlist comtrade_price wb_price usgs_price multicolour_price {
egen `var'_std = std(`var'), by(resource)
}

// egen wb_price_std = std(wb_price), by(resource)

foreach ind of varlist wb_unit wb_price_std  comtrade_price_std multicolour_price_std { 
	
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

egen sdname = concat( state final_dist_1991)

// Now we can collapse

// Note that for prices, we only have one price per year (for all districts)
foreach v of var * {
	local l`v' : variable label `v'
	if `"`l`v''"' == "" {
		local l`v' "`v'"
 	}
  }

collapse  (max) dresource_id* wb_price* comtrade_price* multicolour_price* (sum) prod_resource_id* comtrade_value wb_value usgs_value multicolour_value  (firstnm) country final_dist_1991 state latlong latitude longitude standardmeasure wb_unit* comtrade_unit* multicolour_unit* , by(year sdname)

foreach v of var * {
	label var `v' `"`l`v''"'
}

save dist_lvl_minerals.dta, replace

egen sd_id = concat(sdname year)

// The following loop will correct the 0 prices as missing data, and assign the same price to each resource for each year

foreach var of varlist wb_price*  { 
	replace `var' = . if `var' == 0
	bysort year (`var'):  replace `var' = `var'[_n-1] if missing(`var')
}

tostring(year), replace

order final_dist_1991 state *

save dist_lvl_minerals.dta, replace

// From here go to NSS Cleaning
