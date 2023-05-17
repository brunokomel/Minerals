**************************************
*                                    *
*                                    *
*      Merging & appending NSS       *
*                                    *
*                                    *
**************************************

global wd "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data"


global nss  "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data"

global nss_work "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Working Data"

global nss_orig "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data"


**************************************
*                                    *
*           Appending NSS            *
*                                    *
**************************************

cd "$nss/Working Data"

use NSS_55_dist_child_lab.dta, clear

append using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Working Data/NSS_60_dist_child_lab.dta"

append using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Working Data/NSS_61_dist_child_lab.dta"

append using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Working Data/NSS_62_dist_child_lab.dta"

append using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Working Data/NSS_64_dist_child_lab.dta"

append using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Working Data/NSS_66_dist_child_lab.dta"

append using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Working Data/NSS_68_dist_child_lab.dta"

cd "$wd"

save NSS_all_dist_child_lab.dta, replace

**************************************
*                                    *
*        Merging to Minerals         *
*                                    *
**************************************

// New way of bridging

// Merging to the bridge

cd "$nss/Working Data"

// Adding round identifiers to the mining data

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/bridge dist_rd and sdname 4.dta", clear

gen rd = substr(dist_rd,5,2)

gen year = 2000
replace year = 2004 if rd == "60"
replace year = 2005 if rd == "61"
replace year = 2006 if rd == "62"
replace year = 2008 if rd == "64"
replace year = 2010 if rd == "66"
replace year = 2012 if rd == "68"

egen sd_id = concat(sdname year)

save "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/bridge dist_rd and sdname 5.dta"

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/dist_lvl_minerals.dta", clear

merge m:1 sd_id using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/bridge dist_rd and sdname 5.dta"

keep if _merge == 3

drop _merge

cd "$wd"

save "mining_bridged.dta", replace

foreach v of var * {
	local l`v' : variable label `v'
	if `"`l`v''"' == "" {
		local l`v' "`v'"
 	}
  }

qui describe, varlist
local vars `r(varlist)'
local omit dist_rd
local want : list vars - omit

collapse  (firstnm) "`want'" , by(dist_rd)

foreach v of var * {
	label var `v' `"`l`v''"'
}

save "mining_bridged_no_dups.dta", replace

// Merging NSS to the Minerals data
cd "$nss/Working Data"

use NSS_all_dist_child_lab.dta, clear

merge m:1 dist_rd using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/mining_bridged_no_dups.dta"

// I don't think there are any Mumbai observations in NSS

cd "$wd"

save NSS_Minerals_merged.dta , replace 

keep if round != .

tab _merge

gen mine = 0
replace mine = 1 if _merge == 3

save NSS_Minerals_merged_clean.dta , replace 


**************************************
*                                    *
*       Adding Monthly Prices        *
*                                    *
**************************************
