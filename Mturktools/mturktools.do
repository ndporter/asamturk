*Stata Mturktools master do file
*Nathaniel D Porter (nathanield.porter@gmail.com)
*Created November 2015
*Revised August 2016

/*
Instructions (IMPORTANT):
This file should only be distributed as part of the package mturktools.
To use the package:
(1) Place all files from the package into a directory with the original 
batch output (original filenames without spaces) downloaded from Mturk 
for all batches you wish to include together.
(2) Edit this file to reflect the directory on your local device.
(3) Comment out (add * to beginning of line) for any operations you do not wish 
to run.
(4) Run line by line or as a single file.
***Caution: By default, running this will replace previous mturktools output in 
working directory. Make sure to save data under a new name before running if
you do not wish to overwrite them (e.g. "save myfilename, replace")***
*/

*DO FIRST FOR ALL FILES
*Set local directory (use forward slashes, no backslashes)
cd "Y:/Nathaniel Junk/Mturktools-working/"

*Comprehend all batch files in directory into a single file
*Default output = combined.dta and working.dta
*For csv output, uncomment export delim in combinefiles
do combinefiles, nostop

*Clean up variable names and formats and standardize to Stata usable
*Default input = working.dta
*Default output = working.dta
*For csv output, uncomment export delim in cleanfile
do cleanfile, nostop

*Correct average work time estimates for multi-HIT batches
*Default input = working.dta
*Default output = working.dta
do worktime, nostop

*Create datafile of only accepted assignments (e.g. the good data)
*Default input = working.dta
*Default output = working.dta and accepted.dta
do reject, nostop

*Create datafile with anonymized worker IDs suitable for public repositories
*Default input = accepted.dta
*Default output = public.dta
do anonymize, nostop

***Produce key outputs in usable formats
*Default input = accepted.dta
*Default outputs in format "tabletype.csv"


