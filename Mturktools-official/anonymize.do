*Mturktools.anonymize
*Nathaniel D Porter (nathanield.porter@gmail.com)
*August 2016

/*

Instructions (IMPORTANT):
This file should only be distributed as part of the package mturktools.
While each .do file can be used separately, the package is designed to be 
run using mturktools.do.

Purposes: 
Replace MTurk worker ID numbers with locally unique ID numbers
Output allows worker analysis within working data 
Cannot be later matched on worker to other data
Allow public posting of data without endangering worker confidentiality

Notes:
(1) File assumes that working directory has already been set
(2) Uses accepted.dta, preserves original combined.dta
(3) Saves public.dta to preserve working as complete file
(4) Saves public.csv in text format

*/


*read source
use accepted, clear

*Create new id numbers
sort workerid
egen anonid = group(workerid)

*Drop workerid
drop workerid

*save file- note new name
save public, replace

*save csv
export delimited public.csv, replace
