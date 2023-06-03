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

// Yearly price data

// After cleaning

cd "$wd"

use  NSS_Minerals_merged_clean.dta , clear

gen state_code = substr(sd, 1,2)

ren dresource_id1 coal_mine

ren wb_price_std_id1 coal_price_wb

gen interaction = coal_price_wb*coal_mine

xi: reghdfe child_lab  c.coal_price_wb#i.coal_mine [pw = pweight] if child == 1, absorb(state_code round) vce(cluster sd)

xi: reghdfe child_lab coal_mine interaction coal_price_wb [pw=pweight] if child == 1, absorb(state_code round) vce(cluster sd)

mdesc child_lab coal_price_wb pweight state_code round sd coal_mine

//// Monthly price data

//since round 55 doesn't have months, let's just drop them
drop if round == "55"

gen interaction2 = coal_avg_std*coal_mine

xi: reghdfe child_lab  c.coal_avg_std#i.coal_mine [pw = pweight] if child ==1, absorb(state_code month) vce(cluster sd) 

xi: reghdfe child_lab_outside_hh  coal_avg_std coal_mine interaction2 [pw = pweight] if child == 1, absorb(state_code round) vce(cluster sd)
// basically a 0 effect

// using district fixed effects
xi: reghdfe child_lab  coal_avg_std coal_mine interaction2 [pw = pweight] if child == 1, absorb(sd round) vce(cluster sd)

// For other resources

preserve 

local which_id = 5  // mind the fact that there's only "oil" during round 55
local which_price = "comtrade" // wb or comtrade 

gen int`which_id' = `which_price'_price_std_id`which_id'*dresource_id`which_id'

xi: reghdfe child_lab  `which_price'_price_std_id`which_id' dresource_id`which_id' int`which_id' [pw = pweight] if child == 1, absorb(sd round) vce(cluster sd)

restore

