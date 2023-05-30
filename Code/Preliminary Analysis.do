**************************************
*                                    *
*                                    *
*         Minerals Project           *
*                                    *
*                                    *
**************************************

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

use NSS_Minerals_merged_clean.dta , clear

gen state_code = substr(sd, 1,2)


gen coal_mine = dresource_id12

gen interaction = wb_price_std_id12*coal_mine

xi: reghdfe child_lab  c.wb_price_std_id12#i.coal_mine [pw = pweight] if child == 1, absorb(state_code round) vce(cluster sd)

mdesc child_lab wb_price_std_id12 pweight state_code round sd coal_mine


//// Monthly price data

cd "$wd"

use  NSS_Minerals_merged_clean_monthly_price.dta , clear

//since round 55 doesn't have months, let's just drop them
drop if round == "55"

gen state_code = substr(sd, 1,2)

replace dresource_id12 = 0 if dresource_id12 == .

gen coal_mine = dresource_id12

gen interaction = coal_avg_std*coal_mine


xi: reghdfe child_lab  c.coal_avg_std#i.coal_mine [pw = pweight] if child ==1, absorb(state_code month) vce(cluster sd) 

xi: reghdfe child_lab  coal_avg_std coal_mine interaction [pw = pweight] if child == 1, absorb(state_code round) vce(cluster sd)
// basically a 0 effect

// using district fixed effects
xi: reghdfe child_lab  coal_avg_std coal_mine interaction [pw = pweight] if child == 1, absorb(sd round) vce(cluster sd)



