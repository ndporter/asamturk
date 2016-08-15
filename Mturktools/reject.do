*Mturktools.reject
*Nathaniel D Porter (nathanield.porter@gmail.com)
*November 2015


/*

Instructions (IMPORTANT):
This file should only be distributed as part of the package mturktools.
While each .do file can be used separately, the package is designed to be 
run using mturktools.do.

Purpose: Remove rejected assignments prior to calculating results

Notes:
(1) File assumes that working directory has already been set
(2) Uses working.dta, preserves original combined.dta
(3) Saves accepted.dta to preserve working as complete file

*/


*read source
use working, clear

*drop rejected assignments (keep reversed rejections)
drop if assignmentstatus=="Rejected" & approve ~= "x"

*save file- note new name
save accepted, replace
