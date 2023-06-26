******* Cleaning up bridge files ***********

global wd "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data"

global nss  "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data"

global nss_work "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Working Data"

global nss_orig "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data"

global dbox "/Users/brunokomel/Library/CloudStorage/Dropbox/Human Capital/Data/NSS Mining Data Map"

**********************
*      Round 61      *
**********************

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Brown Mapping - NSS Districts/brown_nss61_dist_match.dta", clear

drop if sd == ""
gen round = "61"


gen str2 state_id = string(state_code_62, "%02.0f")
gen str2 dist_id = string(district_code_62, "%02.0f")


cd "$wd"

save "brown_nss61_dist_match.dta", replace

**********************
*      Round 66      *
**********************


use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Brown Mapping - NSS Districts/brown_nss66_dist_match.dta", clear

drop if sd == ""
gen round = "66"


gen str2 state_id = string(state_code_66, "%02.0f")
gen str2 dist_id = string(district_code_66, "%02.0f")


cd "$wd"

save "brown_nss66_dist_match.dta", replace


**********************
*      Round 68      *
**********************


use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Brown Mapping - NSS Districts/brown_nss68_dist_match.dta", clear

drop if sd == ""
gen round = "68"


gen str2 state_id = string(state_code_68, "%02.0f")
gen str2 dist_id = string(district_code_68, "%02.0f")


cd "$wd"

save "brown_nss68_dist_match.dta", replace

