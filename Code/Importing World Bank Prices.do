** Importing World Bank Prices (Pink Sheet) from https://www.worldbank.org/en/research/commodity-markets#1

global wd "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data"


import excel "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/World Bank Price Data/CMO-Historical-Data-Monthly.xlsx", sheet("Monthly Prices") cellrange(A5:CK767) firstrow clear

ren A period

gen id = _n
drop if id <= 2
drop id

gen year = substr(period, 1,4)
gen month = substr(period,6,.)

destring(Crudeoilaverage-CK), replace force // converting all values to numeric, and forcing missing values as "."
drop BU-CK

gen coal_avg = (CoalAustralian + CoalSouthAfrican)/2

cd "$wd"


save "Importing World Bank Prices.dta", replace

merge m:1 year using "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data/Importing World Bank Deflator.dta"

drop if _merge == 1

drop _merge

cd "$wd"


save "Monthly World Bank Prices - Deflated.dta", replace

** Deflating prices for all variables
order period year month deflator *

qui describe, varlist
local vars `r(varlist)'
local omit period year month deflator 
local want : list vars - omit

foreach var of varlist `want' {
	gen `var'_defl = `var'/(deflator/100)
	label var `var'_defl "`var' Deflated to 2010 "
}

cd "$wd"

// want to standardize Coal, diamond, oil, petroleum, and phosphate for analysis (top 5)

egen coal_avg_std = std(coal_avg_defl) // standardizing the coal average so we can use it later
egen coal_aus_std = std(CoalAustralian_defl)
egen coal_sa_std = std(CoalSouthAfrican_defl)

egen crudeoil_avg_std = std(Crudeoilaverage_defl)

egen iron_ore = std(Ironorecfrspot_defl)


save "Monthly World Bank Prices - Deflated.dta", replace

