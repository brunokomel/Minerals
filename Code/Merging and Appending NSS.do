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

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/bridge dist_rd and sdname 4.dta", clear

merge m:m dist_rd using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/NSS_all_dist_child_lab.dta"

// Note: _merge == 1 means that there was a mine, but no NSS data (Mumbai and New Delhi)
// _merge == 2 means that there was no mine in that district for any of the years
// The way I did this was short sided, as I only named the districts that had mines
// so _merge == 3 are districts that have mines (and which I mathced a name to a dist number)

drop _merge

save "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/bride_incl_month.dta", replace

gen year_survey_two_digit = substr(date_survey,5,2)

gen year_survey  = ""

replace year_survey = "20" +year_survey_two_digit if substr(year_survey_two_digit,1,1) == "0" 
replace year_survey = "20" +year_survey_two_digit if substr(year_survey_two_digit,1,1) == "1" 
replace year_survey = "200" +year_survey_two_digit if substr(year_survey_two_digit,1,1) == "7"  | substr(year_survey_two_digit,1,1) == "8" 

// Some observations don't have date of survey, but they have date of despatch
gen despatch_year_two_digit  = substr(date_despatch,5,2)
replace year_survey = "20" + despatch_year_two_digit if year_survey == "" & (substr(despatch_year_two_digit,1,1) == "0" )
replace year_survey = "20" + despatch_year_two_digit if year_survey == "" & (substr(despatch_year_two_digit,1,1) == "1" )


gen month_survey = ""
replace month_survey = substr(date_survey,3,2) if strlen(date_survey) == 6
replace month_survey = substr(date_survey,2,2) if strlen(date_survey) == 5
replace month_survey = substr(date_despatch,3,2) if date_survey == "" & strlen(date_despatch) == 6
replace month_survey = substr(date_despatch,2,2) if date_survey == "" & strlen(date_despatch) == 5


// Round 55 doesn't have dates, but it does tell us the quarter, so we can at least figure out the year.
// from documentation: "The 1st sub-round period is from July to September 1999, 2nd sub-round period is from October to December 1999 and so on."

ren quarter_survey sub_round
gen quarter_survey = ""
replace quarter_survey = "3" if sub_round == "1"
replace quarter_survey = "4" if sub_round == "2"
replace quarter_survey = "1" if sub_round == "3"
replace quarter_survey = "2" if sub_round == "4"

replace year_survey = "1999" if sub_round == "1" |  sub_round == "2"
replace year_survey = "2000" if sub_round == "3" |  sub_round == "4"

// And let's fill in the quarters for the other observations
replace quarter_survey = "1" if substr(date_survey,3,2) == "01" | substr(date_survey,3,2) == "02" | substr(date_survey,3,2) == "03"
replace quarter_survey = "2" if substr(date_survey,3,2) == "04" | substr(date_survey,3,2) == "05" | substr(date_survey,3,2) == "06"
replace quarter_survey = "3" if substr(date_survey,3,2) == "07" | substr(date_survey,3,2) == "08" | substr(date_survey,3,2) == "09"
replace quarter_survey = "4" if substr(date_survey,3,2) == "10" | substr(date_survey,3,2) == "11" | substr(date_survey,3,2) == "12"

// some observations have d/mm/yy
replace quarter_survey = "1" if  strlen(date_survey) == 5 & (substr(date_survey,2,2) == "01" | substr(date_survey,2,2) == "02" | substr(date_survey,2,2) == "03")
replace quarter_survey = "2" if strlen(date_survey) == 5 &  (substr(date_survey,2,2) == "04" | substr(date_survey,2,2) == "05" | substr(date_survey,2,2) == "06")
replace quarter_survey = "3" if strlen(date_survey) == 5 & (substr(date_survey,2,2) == "07" | substr(date_survey,2,2) == "08" | substr(date_survey,2,2) == "09")
replace quarter_survey = "4" if strlen(date_survey) == 5 & (substr(date_survey,2,2) == "10" | substr(date_survey,2,2) == "11" | substr(date_survey,2,2) == "12")

egen sd_id = concat(sdname year_survey)

drop if sd == "" // getting rid of Mumbai and Nee Delhi (10 obs)

drop year_survey_two_digit despatch_year_two_digit sub_round

save "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/bridge_incl_month.dta", replace

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/bridge_incl_month.dta", clear

merge m:1 sd_id using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/dist_lvl_minerals.dta"

// We can see that the years where we have NSS data, most observations are matched
tab year if _merge == 2

drop if _merge == 2

// note that the obs. in _merge == 1 that have a District Name, that's because that district had a mine at some point, but not for that specific year

tostring(round), replace
lab var round "NSS Round"

// Adding round identifiers to the mining data
gen mine = 0
lab var mine "Any mine in that year"
replace mine = 1 if _merge == 3

drop _merge

cd "$wd"

save "mining_bridged_May17.dta", replace

gen round_id = round + id
unique round_id // So for each round, we don't have any duplicates

/* 
// To collapse by district
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
*/ 


cd "$wd"

gen year_mo = year_survey + month_survey

save NSS_Minerals_merged_clean_May17.dta , replace 


**************************************
*                                    *
*       Adding Monthly Prices        *
*                                    *
**************************************

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/Monthly World Bank Prices - Deflated.dta", clear

keep year month Coal* coal*

gen year_mo = year + month

ren year year_mineral_data

merge 1:m year_mo using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/NSS_Minerals_merged_clean_May17.dta"

drop if _merge == 1 // these are the Month-years for which we have mining data but not NSS

// _merge == 2 are the observations in Round 55, for which we don't have months
// There are a few others from round 60, 61, 64 and 66 as well, but they total to like 130
// So for the monthly analysis we're interested in _merge ==3 (about 2.7 million observations)

save NSS_Minerals_merged_clean_monthly_May17.dta , replace 


// Next go to preliminary analysis 
