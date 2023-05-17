** Importing World Bank Deflator

global wd "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/Working Data"


import delimited "/Users/brunokomel/Library/CloudStorage/OneDrive-UniversityofPittsburgh/2 - Mineral Prices and Human Capital/Data/World Bank Price Data/P_Data_Extract_From_World_Development_Indicators/9879ca88-f21d-4c4c-8a9a-9d4a7c31e281_Data.csv", clear 


drop seriesname seriescode countryname countrycode
drop if yr1987 == .

xpose, clear varname

order _varname v1

ren v1 deflator
label var deflator "2010 Deflator (World Bank)"
ren _varname year
replace year = substr(year,3,.)

cd "$wd"

save "Importing World Bank Deflator.dta", replace
