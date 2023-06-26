******* Cleaning up bridge files ***********

global wd "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data"

global nss  "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data"

global nss_work "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Working Data"

global nss_orig "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data"

global dbox "/Users/brunokomel/Library/CloudStorage/Dropbox/Human Capital/Data/NSS Mining Data Map"

**********************
*      Round 55      *
**********************

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Brown Mapping - NSS Districts/brown_nss55_dist_match.dta", clear

drop if sd == ""
gen round = "55"


gen str2 state_id = string(state_code_55, "%02.0f")
gen str2 dist_id = string(district_code_55, "%02.0f")

// here we have a bit of an issue with some duplicate distric codes in Gujarat, so we're going to collapse the data, and to be safe, since only one of these districts has a mine, I will keep the name that matches the mine data.

drop if sd == "0715" & Latlong == ""

collapse (firstnm) nss_state nss_district StateDistrict Latlong state_code* district_code* round state_id dist_id, by(sd)


cd "$wd"

save "brown_nss55_dist_match.dta", replace

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
*      Round 64      *
**********************

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Brown Mapping - NSS Districts/brown_nss64_dist_match.dta", clear

drop if sd == ""
gen round = "64"


gen str2 state_id = string(state_code_64, "%02.0f")
gen str2 dist_id = string(district_code_64, "%02.0f")

// here we have a bit of an issue with some duplicate distric codes in Gujarat, so we're going to collapse the data, and to be safe, since only one of these districts has a mine, I will keep the name that matches the mine data.

drop if sd == "2419" & Latlong == ""

collapse (firstnm) nss_state nss_district StateDistrict Latlong state_code_64 district_code_64 round state_id dist_id, by(sd)


cd "$wd"

save "brown_nss64_dist_match.dta", replace


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

