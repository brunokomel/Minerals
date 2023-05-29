******* Cleaning up bridge files ***********

global wd "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data"

global nss  "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data"

global nss_work "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Working Data"

global nss_orig "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data"

**********************
*      Round 55      *
**********************

use "/Users/brunokomel/Library/CloudStorage/Dropbox/Human Capital/Data/NSS Mining Data Map/nss55_dist_match_icrisat.dta", clear 

gen round = "55"
gen str2 state_id = string(state_code, "%02.0f")
gen str2 dist_id = string(district_code, "%02.0f")

cd "$wd"

save "nss55_dist_match_icrisat_id.dta", replace

**********************
*      Round 61      *
**********************

use "/Users/brunokomel/Library/CloudStorage/Dropbox/Human Capital/Data/NSS Mining Data Map/nss61_dist_match_icrisat.dta", clear 

gen round = "61"
gen str2 state_id = string(statecode, "%02.0f")
gen str2 dist_id = string(districtcode, "%02.0f")

cd "$wd"

save "nss61_dist_match_icrisat_id.dta", replace

**********************
*      Round 66      *
**********************

use "/Users/brunokomel/Library/CloudStorage/Dropbox/Human Capital/Data/NSS Mining Data Map/nss66_dist_match_icrisat.dta", clear 

gen round = "66"
gen str2 state_id = string(statecode, "%02.0f")
gen str2 dist_id = string(districtcode, "%02.0f")

cd "$wd"

save "nss61_dist_match_icrisat_id.dta", replace

