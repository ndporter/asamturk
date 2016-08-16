*Mturktools.combinefiles
*Nathaniel D Porter (nathanield.porter@gmail.com)
*November 2015

/*

Instructions (IMPORTANT):
This file should only be distributed as part of the package mturktools.
While each .do file can be used separately, the package is designed to be 
run using mturktools.do.

Purpose: Combine multiple batches of Mturk results in Stata automatically

Notes:
(1) File assumes that working directory has already been set
(2) Only variables with identical names across batches will be combined

*/

*Comprehend all batch files
*"." is automatically removed in varname but remains in variable description
*varname case can be preserved by removing case(lower) in import
clear
gen batchnum = ""
save temp, replace
local batches: dir . files "*.csv"
foreach f of local batches {
   preserve
   import delim using `f', varnames(1) case(lower) stringcols(_all) clear
   gen batchnum = regexr("`f'", "Batch_*_batch", "")
   replace batchnum = substr(batchnum, 7, 7)
   save temp, replace
   restore
   quietly append using temp, force
}   
*Reorder output in by [Auto-generated, Input, Answer]
order input* answer*, last

*For stata file use this; otherwise comment out
save combined, replace
save working, replace
*For Excel/csv/tsv file use or modify this; otherwise comment out
/*Default is csv text file with:
	variable names on line 1
	variables with commas in values enclosed in double quotes*/
*export delim using "combined.csv"

