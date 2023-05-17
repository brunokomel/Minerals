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

cd "$nss"

**************************************
*                                    *
*       Preliminary Analysis         *
*                                    *
**************************************

// After cleaning

cd "$wd"

use NSS_Minerals_merged_clean.dta , clear

gen state_code = substr(sd, 1,2)

// need to fill in missing values for prices

**# Fix this way back when
replace wb_price_std_id12 = . if wb_price_std_id12 == 0 // I think this is an error I need to go back and fix when creating the dummies

// Assigning prices to all observations in a given year
bysort year (wb_price_std_id12) : replace wb_price_std_id12 = wb_price_std_id12[_n-1] if missing(wb_price_std_id12)
bysort year (dresource_id12) : replace dresource_id12 = dresource_id12[_n-1] if missing(dresource_id12)

gen coal_mine = dresource_id12

gen interaction = wb_price_std_id12*coal_mine

xi: reghdfe child_lab  c.wb_price_std_id12#i.coal_mine [pw = pweight], absorb(state_code round) vce(cluster sd)

mdesc child_lab wb_price_std_id12 pweight state_code round sd coal_mine

