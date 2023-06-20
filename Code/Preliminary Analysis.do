**************************************
*                                    *
*                                    *
*         Minerals Project           *
*                                    *
*                                    *
**************************************

global md "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital" // md for main directory

global wd "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data"

global nss  "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data"

global nss_work "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Working Data"

global nss_orig "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data"

**************************************
*                                    *
*       Preliminary Analysis         *
*                                    *
**************************************

cd "$wd"

use  NSS_Minerals_merged_clean.dta , clear

*********************
// Cleaning preamble

drop if round == "."
drop if round == "55"

gen state_code = substr(sd, 1,2)
ren sd dist_code 

// careful with petroleum products
label var dresource_id7 "petroleum_products"

foreach v of varlist dresource* {
   local x : variable label `v'
   rename `v' `x'
   label var `x' "`x' mine"
}

egen alum = rowmax(aluminum alumina)

egen crudeoil = rowmax(oil petroleum_products)

ren iron iron_ore

ren coal_avg_std coal_std
ren crudeoil_avg_std crudeoil_std

*********************

local resource crudeoil // pick resource here
local outcome child_lab // pick outcome (child_lab child_lab_outside_hh)

di "Interaction with intensive margin"

xi: reghdfe `outcome' c.`resource'_std##i.`resource' [pw = pweight] if child == 1, absorb(state_code month) vce(cluster dist_code)

gen high_`resource' = `resource'_std >= 1

di "Idicator for shock >= 1 std. deviation."

xi: reghdfe `outcome' high_`resource'##`resource' [pw = pweight] if child == 1, absorb(state_code month) vce(cluster dist_code)

drop high_`resource'

di "District Fixed Effects - intensive margin"

xi: reghdfe `outcome' c.`resource'_std##i.`resource' [pw = pweight] if child == 1, absorb(dist_code month) vce(cluster dist_code)

*********************

// I think part of the issue is that we don't have enough treated observations
tab child_lab if coal == 1 & child == 1
tab child_lab if coal == 0 & child == 1

// I think part of the issue is that we don't have enough treated observations
tab child_lab_outside_hh if coal == 1 & child == 1
tab child_lab_outside_hh if coal == 0 & child == 1
