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

gen worked = 0
local work_var = "Usual_Principal_Activity_Status"
replace worked = 1 if `work_var' == "11" | `work_var' == "21" | `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"

gen worked_outside_hh = 0
replace worked_outside_hh = 1 if  `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"
							
gen attended_school = (`work_var' == "91")
							
ren Usual_Principal_Activity_NIC2008 industry

gen id = hhid + person
lab var id "observation identifier"


cd "$nss/Working Data"

save NSS_68_clean.dta, replace

gen year = 2012 // Picked year in the end of survey
gen round = 68

global variables = "id dist_code pweight worked* year round date* industry attended_school age"

keep $variables

ren dist_code sd

egen dist_rd = concat(sd round)

cd "$nss/Working Data"

save NSS_68_clean.dta, replace

merge m:1 sd using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/nss68_dist_match_icrisat_id.dta", force

ren _merge bridge_dist_name
label define merge_label 1 "not identified" 2 "identified not matched" 3 "identified & matched"
label values bridge_dist_name merge_label

drop state_code dist_code

merge m:1 sd using "$wd/brown_nss68_dist_match.dta", force

drop _merge

save NSS_68_clean.dta, replace

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

gen worked = 0
local work_var = "Usual_Principal_Activity_Status"
replace worked = 1 if `work_var' == "11" | `work_var' == "21" | `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"

gen worked_outside_hh = 0
replace worked_outside_hh = 1 if  `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"
							
gen attended_school = (`work_var' == "91")
							
ren Usual_Principal_Activity_NIC2004 industry

gen id = hhid + person
lab var id "observation identifier"
lab var id "observation identifier"



cd "$nss/Working Data"

save NSS_66_clean.dta, replace

replace state = substr(state,1,2)

egen sd = concat(state dist_code)

replace dist_code = sd

gen year = 2010 // Picked year in the end of survey
gen round = 66

keep $variables

ren dist_code sd

egen dist_rd = concat(sd round)

save NSS_66_clean.dta, replace

merge m:1 sd using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/nss66_dist_match_icrisat_id.dta", force

ren _merge bridge_dist_name
label define merge_label 1 "not identified" 2 "identified not matched" 3 "identified & matched"
label values bridge_dist_name merge_label

drop state_no district_no

merge m:1 sd using "$wd/brown_nss66_dist_match.dta", force

drop _merge

save NSS_66_clean.dta, replace


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

gen worked = 0
local work_var = "B4_c9"
replace worked = 1 if `work_var' == "11" | `work_var' == "21" | `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"

gen worked_outside_hh = 0
replace worked_outside_hh = 1 if  `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"
							
gen attended_school = (`work_var' == "91")
							
ren B4_c11 industry

cd "$nss/Working Data"

save NSS_64_clean.dta, replace

egen sd = concat(state dist_code)

replace dist_code = sd

gen year = 2008 // Picked year in the end of survey
gen round = 64

keep $variables

ren dist_code sd

egen dist_rd = concat(sd round)

save NSS_64_clean.dta, replace

merge m:1 sd using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/nss66_dist_match_icrisat_id.dta", force // just using the NSS66 mapping for now

ren _merge bridge_dist_name
label define merge_label 1 "not identified" 2 "identified not matched" 3 "identified & matched"
label values bridge_dist_name merge_label

drop state_no district_no

merge m:1 sd using "$wd/brown_nss64_dist_match.dta", force

drop _merge

save NSS_64_clean.dta, replace

// Not using round 62 for now
/* 
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

ren  Person_slno_B5_q1 person
lab var person "identifier for individual respondent"

ren B5_q2 age
lab var age "age of respondent"

ren WGT pweight
lab var pweight "probability weight (combined multiplier)"

ren Person_key id
lab var id "observation identifier"

// Block 5 only

gen worked = 0
local work_var = "B5_q3"
replace worked = 1 if `work_var' == "11" | `work_var' == "21" | `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"

gen worked_outside_hh = 0
replace worked_outside_hh = 1 if  `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"
							
gen attended_school = (`work_var' == "91")
							
ren B5_q5 industry



cd "$nss/Working Data"

save NSS_62_clean.dta, replace

egen sd = concat(state dist_code)

replace dist_code = sd

gen year = 2006 // Picked year in the end of survey
gen round = 62

keep $variables

ren dist_code sd

egen dist_rd = concat(sd round)

save NSS_62_clean.dta, replace

*/

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

ren PID id 
lab var id "observation identifier"

ren Personal_serial_no person
lab var person "identifier for individual respondent"

ren Age age
lab var age "age of respondent"

ren WEIGHT_SUB_ROUND pweight
lab var pweight "probability weight (combined multiplier)"

// Block 5 only


gen worked = 0
local work_var = "Usual_principal_activity_status"
replace worked = 1 if `work_var' == "11" | `work_var' == "21" | `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"

gen worked_outside_hh = 0
replace worked_outside_hh = 1 if  `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"
							
gen attended_school = (`work_var' == "91")
							
ren Usual_principal_activity_NIC_5_d industry


cd "$nss/Working Data"

save NSS_61_clean.dta, replace

gen state_id = substr(state, 1,2)

egen sd = concat(state_id dist_code)

replace dist_code = sd 

gen year = 2005 // Picked year in the end of survey
gen round = 61

keep $variables

ren dist_code sd

egen dist_rd = concat(sd round)

save NSS_61_clean.dta, replace

merge m:1 sd using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/nss61_dist_match_icrisat_id.dta", force // just using the NSS66 mapping for now

ren _merge bridge_dist_name
label define merge_label 1 "not identified" 2 "identified not matched" 3 "identified & matched"
label values bridge_dist_name merge_label

drop statecode districtcode

merge m:1 sd using "$wd/brown_nss61_dist_match.dta", force
// Note that we're losing about 3500 obs here

drop _merge

save NSS_61_clean.dta, replace

// Not using round 60 for now
/* 
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

ren B4_c1 person
lab var person "identifier for individual respondent"

ren B4_c5 age
lab var age "age of respondent"

ren WGT pweight
lab var pweight "probability weight (combined multiplier)"

ren Key_memb id
lab var id "observation identifier"

// Block 4 only

gen worked = 0
local work_var = "B4_c9"
replace worked = 1 if `work_var' == "11" | `work_var' == "21" | `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"

gen worked_outside_hh = 0
replace worked_outside_hh = 1 if  `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"
							
gen attended_school = (`work_var' == "91")
							
ren B4_c10 industry



cd "$nss/Working Data"

save NSS_60_clean.dta, replace

egen sd = concat(state dist_code)

replace dist_code = sd


gen year = 2004 // Picked year in the end of survey
gen round = 60

keep $variables

ren dist_code sd 

egen dist_rd = concat(sd round)

save NSS_60_clean.dta, replace
*/ 

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

ren Key_prsn id 
lab var id "observation identifier"

ren B51_q1 person
lab var person "identifier for individual respondent"

ren B51_q2 age
lab var age "age of respondent"

ren Wgt pweight
lab var pweight "probability weight (combined multiplier)"

// Block 4 only

gen worked = 0
local work_var = "B51_q3"
replace worked = 1 if `work_var' == "11" | `work_var' == "21" | `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"

gen worked_outside_hh = 0
replace worked_outside_hh = 1 if  `work_var' == "31" | `work_var' == "41" | `work_var' == "51" | `work_var' == "81"
							
gen attended_school = (`work_var' == "91")
							
ren B51_q5 industry

ren sub_round quarter_survey
lab var quarter_survey "Quarter of Survey"

cd "$nss/Working Data"

save NSS_55_clean.dta, replace

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


egen sd = concat(state dist_code)

replace dist_code = sd



cd "$nss/Working Data"


gen year = 2000 // Picked year in the end of survey
gen round = 55

local vars $variables
local omit date*
local want : list vars - omit


keep `want' quarter_survey

ren dist_code sd

egen dist_rd = concat(sd round)

save NSS_55_clean.dta, replace

merge m:1 sd using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/nss55_dist_match_icrisat_id.dta", force // just using the NSS66 mapping for now

ren _merge bridge_dist_name
label define merge_label 1 "not identified" 2 "identified not matched" 3 "identified & matched"
label values bridge_dist_name merge_label

drop state_code sub_region_code district_code

merge m:1 sd using "$wd/brown_nss55_dist_match.dta", force

drop _merge

save NSS_55_clean.dta, replace


// Next go to "Merging and Appending NSS"

