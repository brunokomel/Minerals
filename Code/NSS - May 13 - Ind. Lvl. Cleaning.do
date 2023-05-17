**************************************
*                                    *
*                                    *
*           NSS Cleaning             *
*                                    *
*                                    *
**************************************


global wd "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data"


global nss  "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data"

global nss_work "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Working Data"

global nss_orig "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data"

cd "$nss"

global child_age = 15 // 14 in some industries

**************************************
*                                    *
*             Round 68               *
*                                    *
**************************************

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data/Extracted Data/Round 68/Block_1_2_Identification of sample household and particulars of field operation.dta", clear

ren Date_of_Survey date_survey
label var date_survey "Date of Survey"

ren Date_of_Despatch date_despatch
label var date_despatch	"Date of Despatch"

keep HHID date*

 merge 1:m HHID using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data/Extracted Data/Round 68/Block_5_1_Usual principal activity particulars of household members.dta"

ren State state
lab var state "state code"

ren District_code dist_code
lab var dist_code "district code"

ren Sector sector
lab var sector "rural or urban"

ren Stratum stratum
lab var stratum "stratum"

ren Sub_Stratum_No substratum
lab var substratum "substratum"

ren FSU_Serial_No psu
lab var psu "primary survey unit (village/block)"

ren Hamlet_Group_Sub_Block_No hamlet_subblock
lab var hamlet_subblock "hamlet group or sub-block number"

ren Second_Stage_Stratum_No ss_strata_no
lab var ss_strata_no "second stage stratum number"

ren Sample_Hhld_No household
lab var household "represents the nth household within each of the second stage stratum"

ren Person_Serial_No person
lab var person "identifier for individual respondent"

ren Age age
lab var age "age of respondent"

ren HHID hhid
lab var hhid "household identifier"

ren Multiplier_comb pweight
lab var pweight "probability weight (combined multiplier)"

// Block 5_1 only
ren Usual_Principal_Activity_Status upas_code
lab var upas_code "Usual principal activity status code"

ren Whether_in_Subsidiary_Activity worked
lab var worked "Whether respondent worked in prev. 365 days (for more than 30 days)"

*** Svy commands:
destring upas_code, replace

gen fs_strata = state + sector + stratum + substratum
lab var fs_strata "first stage strata"

gen id = hhid + person
lab var id "observation identifier"

order id state dist_code sector stratum substratum psu fs_strata hamlet_subblock ss_strata household hhid person pweight age worked upas_code

cd "$nss/Working Data"

save  NSS_68_child_lab.dta, replace

use NSS_68_child_lab, clear
svyset psu [pw = pweight], strata(fs_strata) singleunit(centered)

// svydescribe

// Now to get a Child labor dummy
gen child = age <= $child_age 
lab var child "Age <= 15"
gen child_lab = (age <= $child_age ) & (worked == "1" ) // 
// need to think about district level child labor (conditional on an observation being a child)

cd "$nss/Working Data"

save NSS_68_child_lab.dta, replace


/*
foreach v of var * {
	local l`v' : variable label `v'
	if `"`l`v''"' == "" {
		local l`v' "`v'"
 	}
  }

collapse  (mean) child_lab  (firstnm) state  [pw = pweight], by(dist_code)

foreach v of var * {
	label var `v' `"`l`v''"'
}
*/

gen year = 2012 // Picked year in the end of survey
gen round = 68

global variables = "id dist_code pweight worked child child_lab year round date*"

keep $variables

ren dist_code sd

egen dist_rd = concat(sd round)

cd "$nss/Working Data"

save NSS_68_dist_child_lab.dta, replace


**************************************
*                                    *
*             Round 66               *
*                                    *
**************************************

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data/Extracted Data/Round 66/Block_1_2_Identification of sample household and particulars of field operation.dta", clear

ren Date_of_Survey date_survey
label var date_survey "Date of Survey"

ren Date_of_Despatch date_despatch
label var date_despatch	"Date of Despatch"

keep HHID date*

 merge 1:m HHID using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data/Extracted Data/Round 66/Block_5_1_Usual principal activity particulars of household members.dta"


ren State state
lab var state "state code"

ren District dist_code
lab var dist_code "district code"

ren Sector sector
lab var sector "rural or urban"

ren Stratum stratum
lab var stratum "stratum"

ren Sub_Stratum_No substratum
lab var substratum "substratum"

ren FSU_Serial_No psu
lab var psu "primary survey unit (village/block)"

ren Hamlet_Group_Sub_Block_No hamlet_subblock
lab var hamlet_subblock "hamlet group or sub-block number"

ren Second_Stage_Stratum_No ss_strata_no
lab var ss_strata_no "second stage stratum number"

ren Sample_Hhld_No household
lab var household "represents the nth household within each of the second stage stratum"

ren Person_Serial_No person
lab var person "identifier for individual respondent"

ren Age age
lab var age "age of respondent"

ren HHID hhid
lab var hhid "household identifier"

ren WEIGHT pweight
lab var pweight "probability weight (combined multiplier)"

// Block 5_1 only
ren Usual_Principal_Activity_Status upas_code
lab var upas_code "Usual principal activity status code"

ren Whether_in_Subsidiary_Activity worked
lab var worked "Whether respondent worked in prev. 365 days (for more than 30 days)"

*** Svy commands:
destring upas_code, replace

gen fs_strata = state + sector + stratum + substratum
lab var fs_strata "first stage strata"

gen id = hhid + person
lab var id "observation identifier"

order id state dist_code sector stratum substratum psu fs_strata hamlet_subblock ss_strata household hhid person pweight age worked upas_code

cd "$nss/Working Data"

save  NSS_66_child_lab.dta, replace

use NSS_66_child_lab, clear
svyset psu [pw = pweight], strata(fs_strata) singleunit(centered)

// svydescribe

// Now to get a Child labor dummy
gen child = age <= $child_age 
lab var child "Age <= 15"
gen child_lab = (age <= $child_age ) & (worked == "1" ) // 
// need to think about district level child labor (conditional on an observation being a child)

cd "$nss/Working Data"

save NSS_66_child_lab.dta, replace

replace state = substr(state,1,2)

egen sd = concat(state dist_code)

replace dist_code = sd

gen year = 2010 // Picked year in the end of survey
gen round = 66

keep $variables

ren dist_code sd

egen dist_rd = concat(sd round)

save NSS_66_dist_child_lab.dta, replace


**************************************
*                                    *
*             Round 64               *
*                                    *
**************************************

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data/Extracted Data/Round 64/Block-1-sample-household-identification-records.dta", clear

ren B2_q2i date_survey
label var date_survey "Date of Survey"

ren B2_q2iv date_despatch
label var date_despatch	"Date of Despatch"

ren key_Hhold key_hhold

tostring date*, replace

keep key_hhold date*

merge 1:m key_hhold using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data/Extracted Data/Round 64/Block-4-demographic-usual-activity-members-records.dta"

//ren State state
lab var state "state code"

ren District dist_code
lab var dist_code "district code"

ren Sector sector
lab var sector "rural or urban"

ren Stratum stratum
lab var stratum "stratum"

ren Sub_Stratum substratum
lab var substratum "substratum"

ren FSU psu
lab var psu "primary survey unit (village/block)"

ren sub_block hamlet_subblock
lab var hamlet_subblock "hamlet group or sub-block number"

ren Ss_stratum ss_strata_no
lab var ss_strata_no "second stage stratum number"

ren Sample_hhold_No household
lab var household "represents the nth household within each of the second stage stratum"

ren B4_c1 person
lab var person "identifier for individual respondent"

ren B4_c5 age
lab var age "age of respondent"

ren wgt pweight
lab var pweight "probability weight (combined multiplier)"

ren key_memb id 
lab var id "observation identifier"

// Block 4 only
//ren Usual_Principal_Activity_Status upas_code
//lab var upas_code "Usual principal activity status code"

ren B4_c14 worked
lab var worked "Whether respondent worked in prev. 365 days (for more than 30 days)"

*** Svy commands:
//destring upas_code, replace

gen fs_strata = state + sector + stratum + substratum
lab var fs_strata "first stage strata"

//gen id = hhid + person
//lab var id "observation identifier"

order state dist_code sector stratum substratum psu fs_strata hamlet_subblock ss_strata household pweight age worked

cd "$nss/Working Data"

save  NSS_64_child_lab.dta, replace

use NSS_64_child_lab, clear
svyset psu [pw = pweight], strata(fs_strata) singleunit(centered)

// svydescribe

// Now to get a Child labor dummy
gen child = age <= $child_age 
lab var child "Age <= 15"
gen child_lab = (age <= $child_age ) & (worked == "1" ) // 
// need to think about district level child labor (conditional on an observation being a child)

cd "$nss/Working Data"

save NSS_64_child_lab.dta, replace

egen sd = concat(state dist_code)

replace dist_code = sd

/*
foreach v of var * {
	local l`v' : variable label `v'
	if `"`l`v''"' == "" {
		local l`v' "`v'"
 	}
  }

collapse  (mean) child_lab  (firstnm) state  [pw = pweight], by(sd)

foreach v of var * {
	label var `v' `"`l`v''"'
}
*/


gen year = 2008 // Picked year in the end of survey
gen round = 64

keep $variables

ren dist_code sd

egen dist_rd = concat(sd round)

save NSS_64_dist_child_lab.dta, replace


**************************************
*                                    *
*             Round 62               *
*                                    *
**************************************

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data/Extracted Data/Round 62/Block-1-2-Household-ID-records.dta", clear

ren B2_q2i date_survey
label var date_survey "Date of Survey"

ren B2_q2iv date_despatch
label var date_despatch	"Date of Despatch"

keep Hhold_key date*

merge 1:m Hhold_key using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data/Extracted Data/Round 62/Block-5-Persons-usual-activity-records.dta"

ren State state
lab var state "state code"

ren District dist_code
lab var dist_code "district code"

ren Sector sector
lab var sector "rural or urban"

ren Stratum stratum
lab var stratum "stratum"

ren SubStratum substratum
lab var substratum "substratum"

ren FSU psu
lab var psu "primary survey unit (village/block)"

//ren sub_block hamlet_subblock
//lab var hamlet_subblock "hamlet group or sub-block number"

//ren Ss_stratum ss_strata_no
//lab var ss_strata_no "second stage stratum number"

//ren Sample_hhold_No household
//lab var household "represents the nth household within each of the second stage stratum"

ren  Person_slno_B5_q1 person
lab var person "identifier for individual respondent"

ren B5_q2 age
lab var age "age of respondent"

ren WGT pweight
lab var pweight "probability weight (combined multiplier)"

ren Person_key id
lab var id "observation identifier"

// Block 5 only
//ren Usual_Principal_Activity_Status upas_code
//lab var upas_code "Usual principal activity status code"

ren B5_q7 worked
lab var worked "Whether respondent worked in prev. 365 days (for more than 30 days)"


*** Svy commands:
//destring upas_code, replace

gen fs_strata = state + sector + stratum + substratum
lab var fs_strata "first stage strata"

//gen id = hhid + person
//lab var id "observation identifier"


cd "$nss/Working Data"

save  NSS_62_child_lab.dta, replace

use NSS_62_child_lab, clear
svyset psu [pw = pweight], strata(fs_strata) singleunit(centered)

// svydescribe

// Now to get a Child labor dummy
gen child = age <= $child_age 
lab var child "Age <= 15"
gen child_lab = (age <= $child_age ) & (worked == "1" ) // 
// need to think about district level child labor (conditional on an observation being a child)

cd "$nss/Working Data"

save NSS_62_child_lab.dta, replace

egen sd = concat(state dist_code)

replace dist_code = sd

/*
foreach v of var * {
	local l`v' : variable label `v'
	if `"`l`v''"' == "" {
		local l`v' "`v'"
 	}
  }

collapse  (mean) child_lab  (firstnm) state  [pw = pweight], by(sd)

foreach v of var * {
	label var `v' `"`l`v''"'
}
*/


gen year = 2006 // Picked year in the end of survey
gen round = 62

keep $variables

ren dist_code sd

egen dist_rd = concat(sd round)

save NSS_62_dist_child_lab.dta, replace


**************************************
*                                    *
*             Round 61               *
*                                    *
**************************************

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data/Extracted Data/Round 61/Block_1_2_and_3_level_01.dta", clear

ren Date_survey date_survey
label var date_survey "Date of Survey"

ren Date_despatch date_despatch
label var date_despatch	"Date of Despatch"

keep HHID date*

merge 1:m HHID using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data/Extracted Data/Round 61/Block_5pt1_level_04.dta"
 
keep if _merge == 3

ren State_region state
lab var state "state code"

ren District dist_code
lab var dist_code "district code"

ren Sector sector
lab var sector "rural or urban"

ren Stratum stratum
lab var stratum "stratum"

ren Sub_stratum substratum
lab var substratum "substratum"

ren FSU psu
lab var psu "primary survey unit (village/block)"

ren PID id 
lab var id "observation identifier"

//ren sub_block hamlet_subblock
//lab var hamlet_subblock "hamlet group or sub-block number"

//ren Ss_stratum ss_strata_no
//lab var ss_strata_no "second stage stratum number"

//ren Sample_hhold_No household
//lab var household "represents the nth household within each of the second stage stratum"

ren Personal_serial_no person
lab var person "identifier for individual respondent"

ren Age age
lab var age "age of respondent"

ren WEIGHT_SUB_ROUND pweight
lab var pweight "probability weight (combined multiplier)"

// Block 5 only
//ren Usual_Principal_Activity_Status upas_code
//lab var upas_code "Usual principal activity status code"

ren Whether_in_subsidiary_activity worked
lab var worked "Whether respondent worked in prev. 365 days (for more than 30 days)"


*** Svy commands:
//destring upas_code, replace

gen fs_strata = state + sector + stratum + substratum
lab var fs_strata "first stage strata"

//gen id = hhid + person
//lab var id "observation identifier"

order state dist_code sector stratum substratum psu fs_strata  pweight age worked

cd "$nss/Working Data"

save  NSS_61_child_lab.dta, replace

use NSS_61_child_lab, clear
svyset psu [pw = pweight], strata(fs_strata) singleunit(centered)

// svydescribe

// Now to get a Child labor dummy
gen child = age <= $child_age 
lab var child "Age <= 15"
gen child_lab = (age <= $child_age ) & (worked == "1" ) // 
// need to think about district level child labor (conditional on an observation being a child)

cd "$nss/Working Data"

save NSS_61_child_lab.dta, replace

gen state_id = substr(state, 1,2)

egen sd = concat(state_id dist_code)

replace dist_code = sd 

/*
foreach v of var * {
	local l`v' : variable label `v'
	if `"`l`v''"' == "" {
		local l`v' "`v'"
 	}
  }

collapse  (mean) child_lab  (firstnm) state  [pw = pweight], by(sd)

foreach v of var * {
	label var `v' `"`l`v''"'
}
*/


gen year = 2005 // Picked year in the end of survey
gen round = 61

keep $variables

ren dist_code sd

egen dist_rd = concat(sd round)

save NSS_61_dist_child_lab.dta, replace



**************************************
*                                    *
*             Round 60               *
*                                    *
**************************************

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data/Extracted Data/Round 60/Block-1-sample-household-identification-records.dta", clear

ren B2_q2i date_survey
label var date_survey "Date of Survey"

ren B2_q2iv date_despatch
label var date_despatch	"Date of Despatch"

keep Key_hhold date*

merge 1:m Key_hhold using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data/Extracted Data/Round 60/Block-4-Demographic-usual- activity-members-records.dta"


//ren State_region state
//lab var state "state code"

ren District dist_code
lab var dist_code "district code"

ren Sector sector
lab var sector "rural or urban"

ren Stratum stratum
lab var stratum "stratum"

ren Key_memb id
lab var id "observation identifier"

//ren Sub_stratum substratum
//lab var substratum "substratum"

ren FSU psu
lab var psu "primary survey unit (village/block)"

//ren sub_block hamlet_subblock
//lab var hamlet_subblock "hamlet group or sub-block number"

//ren Ss_stratum ss_strata_no
//lab var ss_strata_no "second stage stratum number"

//ren Sample_hhold_No household
//lab var household "represents the nth household within each of the second stage stratum"

ren B4_c1 person
lab var person "identifier for individual respondent"

ren B4_c5 age
lab var age "age of respondent"

ren WGT pweight
lab var pweight "probability weight (combined multiplier)"

// Block 4 only
//ren Usual_Principal_Activity_Status upas_code
//lab var upas_code "Usual principal activity status code"

ren B4_c12 worked
lab var worked "Whether respondent worked in prev. 365 days (for more than 30 days)"


*** Svy commands:
//destring upas_code, replace

//gen fs_strata = state + sector + stratum + substratum
//lab var fs_strata "first stage strata"

//gen id = hhid + person
//lab var id "observation identifier"

//order state dist_code sector stratum substratum psu fs_strata  pweight age worked


cd "$nss/Working Data"

save  NSS_60_child_lab.dta, replace

use NSS_60_child_lab, clear
//svyset psu [pw = pweight], strata(fs_strata) singleunit(centered)

// svydescribe

// Now to get a Child labor dummy
gen child = age <= $child_age 
lab var child "Age <= 15"
gen child_lab = (age <= $child_age ) & (worked == "1" ) // 
// need to think about district level child labor (conditional on an observation being a child)

cd "$nss/Working Data"

save NSS_60_child_lab.dta, replace

egen sd = concat(state dist_code)

replace dist_code = sd

/*
foreach v of var * {
	local l`v' : variable label `v'
	if `"`l`v''"' == "" {
		local l`v' "`v'"
 	}
  }

collapse  (mean) child_lab  (firstnm) state  [pw = pweight], by(sd)

foreach v of var * {
	label var `v' `"`l`v''"'
}
*/


gen year = 2004 // Picked year in the end of survey
gen round = 60

keep $variables

ren dist_code sd 

egen dist_rd = concat(sd round)

save NSS_60_dist_child_lab.dta, replace


**************************************
*                                    *
*             Round 55               *
*                                    *
**************************************

use "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/NSS Data/Original Data/Extracted Data/Round 55/Block51-sch10-and-10dot1-Records-combined.dta", clear


ren State state
lab var state "state code"

ren District dist_code
lab var dist_code "district code"

ren Sector sector
lab var sector "rural or urban"

ren Stratum stratum
lab var stratum "stratum"

ren Key_prsn id 
lab var id "observation identifier"

//ren Sub_stratum substratum
//lab var substratum "substratum"

//ren FSU psu
//lab var psu "primary survey unit (village/block)"

//ren sub_block hamlet_subblock
//lab var hamlet_subblock "hamlet group or sub-block number"

//ren Ss_stratum ss_strata_no
//lab var ss_strata_no "second stage stratum number"

//ren Sample_hhold_No household
//lab var household "represents the nth household within each of the second stage stratum"

ren B51_q1 person
lab var person "identifier for individual respondent"

ren B51_q2 age
lab var age "age of respondent"

ren Wgt pweight
lab var pweight "probability weight (combined multiplier)"

// Block 4 only
//ren Usual_Principal_Activity_Status upas_code
//lab var upas_code "Usual principal activity status code"

ren B51_q7 worked
lab var worked "Whether respondent worked in prev. 365 days (for more than 30 days)"

ren sub_round quarter_survey
lab var quarter_survey "Quarter of Survey"

*** Svy commands:
//destring upas_code, replace

//gen fs_strata = state + sector + stratum + substratum
//lab var fs_strata "first stage strata"

//gen id = hhid + person
//lab var id "observation identifier"

//order state dist_code sector stratum substratum psu fs_strata  pweight age worked


cd "$nss/Working Data"

save  NSS_55_child_lab.dta, replace

use NSS_55_child_lab, clear
//svyset psu [pw = pweight], strata(fs_strata) singleunit(centered)

// svydescribe

// Now to get a Child labor dummy
gen child = age <= $child_age 
lab var child "Age <= 15"
gen child_lab = (age <= $child_age ) & (worked == "1" ) // 
// need to think about district level child labor (conditional on an observation being a child)

cd "$nss/Working Data"

save NSS_55_child_lab.dta, replace

// Changing State codes for round 55 (from NSS file from round 61)

gen state_new = ""
replace state_new = "28" if state == "02"
replace state_new = "12" if state == "03"
replace state_new = "18" if state == "04"
replace state_new = "10" if state == "05"
replace state_new = "30" if state == "06"
replace state_new = "24" if state == "07"
replace state_new = "06" if state == "08"
replace state_new = "02" if state == "09"
replace state_new = "11" if state == "10"
replace state_new = "29" if state == "11"

replace state_new = "32" if state == "12"
replace state_new = "23" if state == "13"
replace state_new = "27" if state == "14"
replace state_new = "14" if state == "15"
replace state_new = "17" if state == "16"
replace state_new = "15" if state == "17"
replace state_new = "13" if state == "18"
replace state_new = "21" if state == "19"
replace state_new = "03" if state == "20"
replace state_new = "08" if state == "21"

replace state_new = "11" if state == "22"
replace state_new = "33" if state == "23"
replace state_new = "16" if state == "24"
replace state_new = "09" if state == "25"
replace state_new = "19" if state == "26"
replace state_new = "35" if state == "27"
replace state_new = "04" if state == "28"
replace state_new = "26" if state == "29"
replace state_new = "25" if state == "30"
replace state_new = "07" if state == "31"

replace state_new = "31" if state == "32"
replace state_new = "34" if state == "33"


egen sd = concat(state_new dist_code)

replace dist_code = sd

/*

foreach v of var * {
	local l`v' : variable label `v'
	if `"`l`v''"' == "" {
		local l`v' "`v'"
 	}
  }

collapse  (mean) child_lab  (firstnm) state  [pw = pweight], by(sd)

foreach v of var * {
	label var `v' `"`l`v''"'
}
*/



cd "$nss/Working Data"


gen year = 2000 // Picked year in the end of survey
gen round = 55

local vars $variables
local omit date*
local want : list vars - omit


keep `want' quarter_survey

ren dist_code sd

egen dist_rd = concat(sd round)

save NSS_55_dist_child_lab.dta, replace


// Next go to "Merging and Appending NSS"

