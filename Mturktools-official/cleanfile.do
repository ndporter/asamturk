*Mturktools.cleanfile
*Nathaniel D Porter (nathanield.porter@gmail.com)
*November 2015

/*

Instructions (IMPORTANT):
This file should only be distributed as part of the package mturktools.
While each .do file can be used separately, the package is designed to be 
run using mturktools.do.

Purpose: Clean output of combinefiles.do automatically

Notes:
(1) File assumes that working directory has already been set
(2) Uses working.dta, preserves original combined.dta

*/

*read source
use working, clear

***clean variables

*Drop any extra lines
drop if assignmentstatus==""

*Remove {} so Stata codes as missing
foreach var of varlist _all {
quietly replace `var' = regexr(`var', "{}", "")
}

*Change format to numeric when appropriate
/*Note that if variables are intended to be string but only contain numbers,
they will be converted here unless each variable is specified separately*/
quietly destring, ignore("$") replace

*Times to Stata format
/*For some reason, certain cases have time in UTC instead of standard and formats
date differently for those. Do just flags for now and doesn't convert.
Eventually, this do file should have auto conversion of all times to UTC*/
gen UTCflag = ""
foreach var in creationtime accepttime submittime autoapprovaltime ///
approvaltime rejectiontime {
	gen double t`var' = clock(`var', "#MDhms#Y")
	replace t`var' = clock(`var', "YMDhms#") if strpos(`var', "UTC")
	replace UTCflag=UTCflag+`var' if strpos(`var', "UTC")
	drop `var'
	rename t`var' `var'
}
*Save
save working, replace
