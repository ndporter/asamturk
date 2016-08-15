*Nathaniel D Porter nathanield.porter@gmail.com
*October 30, 2015
*Generic Code for producing Stata date/times and average work times
*Change CAPS code to reflect your batch and directory before running

/*

Instructions (IMPORTANT):
This file should only be distributed as part of the package mturktools.
While each .do file can be used separately, the package is designed to be 
run using mturktools.do.

Purpose: Create a maximum average worktime for batches where workers can accept
more than one HIT at a time. The Amazon time is the number of seconds they had
the HIT, and will overestimate the time spent when workers can complete multiple
HITs in a batch.

Notes:
(1) File assumes that working directory has already been set
(2) Uses working.dta, preserves original combined.dta

*/

*Read data
use working, clear

*Generate ordinal and count of assignments for each worker
sort batchnum workerid accepttime
by batchnum workerid: gen anum = _n
by batchnum workerid: egen nassign = max(anum)
*Create maximum total work time and maximum average work time by worker
by batchnum workerid: egen double fstart = min(accepttime)
by batchnum workerid: egen double lend = max(submittime)
gen maxtotwt = seconds(lend - fstart)
gen maxavgwt = maxtotwt/nassign
*Create minimum hourly reward by worker per batch
gen batchrew = reward*nassign
gen minhrrew = batchrew/hours(lend - fstart)
format accepttime submittime %tc
format fstart lend %tc
*Get rid of spare variables
drop anum fstart lend batchrew

*Summary (mean, SD, min max) of corrected average worktime and hourly reward
by batchnum: sum maxavgwt minhrrew
*Plot average work time and average reward for workers by # of assignments
scatter maxavgwt nassign || lowess maxavgwt nassign ||, by(batchnum) saving(avgwt)
scatter minhrrew nassign || lowess minhrrew nassign ||, by(batchnum) saving(avgrew)

*Save file
save working, replace
