
//uniform randomly sample 100 records from the 767 web of science articles on mturk

//TOPIC: ("mechanical turk")
//Refined by: DOCUMENT TYPES: ( ARTICLE ) AND PUBLICATION YEARS: ( 2015 OR 2013 OR 2012 OR 2010 OR 2014 OR 2016 OR 2011 )
//Indexes=SCI-EXPANDED, SSCI, A&HCI, CPCI-S, CPCI-SSH, BKCI-S, BKCI-SSH, ESCI, CCR-EXPANDED, IC Timespan=All years

//conducted 5/23/2016

clear all
set seed 20120616
forv i=1/100{
	di ceil(uniform()*767)
	}

//the record numbers are stored in this folder in Mturkpapers_recordssampled.xls
//duplicate record numbers get double the weight in the final sample

//MturkPapers.txt contains the record information

//Formatting Mtukrpapers.txt here into a file
clear all
cd D:\Dropbox\PSU_RAs\NatePorterRA\webofscience
mata
	raw=cat("MTurkPapers.txt")
	//for looping over records
	ptj=select(1::rows(raw),raw:=="PT J")
	ers=select(1::rows(raw),raw:=="ER")
	//storage
	data=J(rows(ptj),11,"")
		//au,ti,so,vl,is,bp,ep,py,ab,tc,pm
	//loop and store
	for (i=1;i<=rows(ptj);i++){
		f=raw[ptj[i]::ers[i]]
		fsub=subinstr(substr(f,1,2)," ","",.)
		//author
		x1=select(1::rows(f),fsub:=="AU")
		if (rows(x1)){
			x2=min(select(1+x1::rows(f),fsub[1+x1::rows(f)]:!=""))-1
			data[i,1]=subinstr(invtokens(f[x1::x2]'),"AU","",1)
			}
		//title
		x1=select(1::rows(f),fsub:=="TI")
		if (rows(x1)){
			x2=min(select(1+x1::rows(f),fsub[1+x1::rows(f)]:!=""))-1
			data[i,2]=subinstr(invtokens(f[x1::x2]'),"TI","",1)
			}
		//source
		x1=select(1::rows(f),fsub:=="SO")
		if (rows(x1)){
			x2=min(select(1+x1::rows(f),fsub[1+x1::rows(f)]:!=""))-1
			data[i,3]=subinstr(invtokens(f[x1::x2]'),"SO","",1)
			}
		//volume
		x1=select(1::rows(f),fsub:=="VL")
		if (rows(x1)){
			x2=min(select(1+x1::rows(f),fsub[1+x1::rows(f)]:!=""))-1
			data[i,4]=subinstr(invtokens(f[x1::x2]'),"VL","",1)
			}
		//issue
		x1=select(1::rows(f),fsub:=="IS")
		if (rows(x1)){
			x2=min(select(1+x1::rows(f),fsub[1+x1::rows(f)]:!=""))-1
			data[i,5]=subinstr(invtokens(f[x1::x2]'),"IS","",1)
			}	
		//begin page
		x1=select(1::rows(f),fsub:=="BP")
		if (rows(x1)){
			x2=min(select(1+x1::rows(f),fsub[1+x1::rows(f)]:!=""))-1
			data[i,6]=subinstr(invtokens(f[x1::x2]'),"BP","",1)
			}
		//end page
		x1=select(1::rows(f),fsub:=="EP")
		if (rows(x1)){
			x2=min(select(1+x1::rows(f),fsub[1+x1::rows(f)]:!=""))-1
			data[i,7]=subinstr(invtokens(f[x1::x2]'),"EP","",1)
			}	
		//year
		x1=select(1::rows(f),fsub:=="PY")
		if (rows(x1)){
			x2=min(select(1+x1::rows(f),fsub[1+x1::rows(f)]:!=""))-1
			data[i,8]=subinstr(invtokens(f[x1::x2]'),"PY","",1)
			}	
		//abstract
		x1=select(1::rows(f),fsub:=="AB")
		if (rows(x1)){
			x2=min(select(1+x1::rows(f),fsub[1+x1::rows(f)]:!=" "))-1
			data[i,9]=subinstr(invtokens(f[x1::x2]'),"AB","",1)
			}
		//times cited
		x1=select(1::rows(f),fsub:=="TC")
		if (rows(x1)){
			x2=min(select(1+x1::rows(f),fsub[1+x1::rows(f)]:!=""))-1
			data[i,10]=subinstr(invtokens(f[x1::x2]'),"TC","",1)
			}
		//pubmed id
		x1=select(1::rows(f),fsub:=="PM")
		if (rows(x1)){
			x2=min(select(1+x1::rows(f),fsub[1+x1::rows(f)]:!=""))-1
			data[i,11]=subinstr(invtokens(f[x1::x2]'),"PM","",1)
			}
		}
	//final formatting
	i=1
	while (i<100){
		data=subinstr(data,"  "," ",.)
		i=i+1
		}
end
clear
getmata (authors title source volume issue beginpage endingpage year abstract timescited pubmedid)=data

//make weights for duplicated titles
gen case=_n
sort case
tempfile tmp
save `tmp'
clear
set obs 100
gen recordnum=.
set seed 20120616
forv i=1/100{
	replace recordnum=ceil(uniform()*767) in `i'
	}
gen weight=1
collapse (sum) weight, by(recordnum)
gen case=_n
sort case
merge 1:1 case using `tmp'
tab _merge
drop _merge

//save file
save WebOfScience_MturkSample, replace


