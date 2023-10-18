**************************************************************************EPCOR Base Rate Analysis********************************************************************************;



%macro rcomp(rate, file, output, districtoutput, annualoutput);


libname pr 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Consumption Analysis\';
libname rc 'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\SAS DBs';


****Importing current and proposed residential rates****;

proc import datafile = 'U:\a-tx-projects\34805\029\SAS\RCOMP\Residential Rates - Current.xlsx'
	out=ResRates
	dbms=xlsx
	replace;
	sheet="Present";
run;


data resrates; set resrates;
	format Blk1_Amt best12.;
	format Blk2_Amt best12.;
	format Blk3_Amt best12.;
	format Blk4_Amt best12.;
	format Blk5_Amt best12.;
	format Blk6_Amt best12.;

	format base_chrg best12.;
	format Blk1_chrg best12.;
	format Blk2_chrg best12.;
	format Blk3_chrg best12.;
	format Blk4_chrg best12.;
	format Blk5_chrg best12.;
	format Blk6_chrg best12.;

	if district_id = 2340 then surcharge = -0.6275;
	if district_id = 2360 then surcharge = 2.5302;
	if district_id = 2361 then surcharge = 2.5302;
	if district_id = 2380 then surcharge = 0.9739;
	if district_id = 2352 then surcharge = -0.0001;
	if district_id = 2350 then surcharge = 1.2045;
	if district_id = 2349 then surcharge = 1.2692;
	if district_id = 2310 then surcharge = 0.2342;
	if district_id = 2341 then surcharge = 1.0754;
	if district_id = 2342 then surcharge = 0.5987;
	if district_id = 2369 then surcharge = -2.4172;
	if district_id = 2348 then surcharge = 2.0455;

	format surcharge best12.;

run;


proc import datafile = &file
	out=p_&rate
	dbms=xlsx
	replace;
	sheet="Proposed";		
run;


data p_&rate; set p_&rate;
	format pBlk1_Amt best12.;
	format pBlk2_Amt best12.;
	format pBlk3_Amt best12.;
	format pBlk4_Amt best12.;
	format pBlk5_Amt best12.;
	format pBlk6_Amt best12.;

	format pbase_chrg best12.;
	format pBlk1_chrg best12.;
	format pBlk2_chrg best12.;
	format pBlk3_chrg best12.;
	format pBlk4_chrg best12.;
	format pBlk5_chrg best12.;
	format pBlk6_chrg best12.;
run;


****Creating database with current and proposed rates****;

data temp;
	set pr.resraw;
run;

proc sort data = temp; by District_ID Rate Meter_Size; run;
proc sort data = resrates; by District_ID Rate Meter_Size; run;

data temp2; 
	merge temp (in=x1) resrates (in=y1);
	by district_id Rate Meter_size;
	x = x1;
	y = y1;
run;

data temp2; set temp2; 
	if x = 1 and y = 1; 
run;



data temp3; set temp2 (drop = x y); run;

proc sort data = p_&rate; by district_id meter_size; run;			**Sort by district_id then meter_size if proposed rates differ by district, else exlcude district_id sorting**;
proc sort data = temp3; by district_id meter_size; run;				**Sort by district_id then meter_size if proposed rates differ by district, else exlcude district_id sorting**;

data temp4; 
	merge temp3 (in=x1) p_&rate (in=y1);
	by district_id Meter_size;										**Merge by district_id and meter_size if proposed rates differ by district, else exclude district_id**;
	x = x1;
	y = y1;
run;

data temp4; set temp4; 
	if x = 1 and y = 1; 
run;

data temp5; set temp4 (drop = x y); run;

data rate_calc; set temp5;

******Creating current block uses for each customer*****;	

	if use <= blk1_amt then do;
		blk1_use = use;
		blk2_use = 0;
		blk3_use = 0;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;

	if (use > blk1_amt and use <= blk2_amt) then do;
		blk1_use = blk1_amt;
		blk2_use = use - blk1_amt;
		blk3_use = 0;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;
	
	if (use > blk2_amt and use <= blk3_amt) then do;
		blk1_use = blk1_amt;
		blk2_use = blk2_amt - blk1_amt;
		blk3_use = use - blk2_amt;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;
	
	if (use > blk3_amt and use <= blk4_amt) then do;
		blk1_use = blk1_amt;
		blk2_use = blk2_amt - blk1_amt;
		blk3_use = blk3_amt - blk2_amt;
		blk4_use = use - blk3_amt;
		blk5_use = 0;
		blk6_use = 0;
	end;
	
	if (use > blk4_amt and use <= blk5_amt) then do;
		blk1_use = blk1_amt;
		blk2_use = blk2_amt - blk1_amt;
		blk3_use = blk3_amt - blk2_amt;
		blk4_use = blk4_amt - blk3_amt;
		blk5_use = use - blk4_amt;
		blk6_use = 0;
	end;
	
	if (use > blk5_amt and use <= blk6_amt) then do;
		blk1_use = blk1_amt;
		blk2_use = blk2_amt - blk1_amt;
		blk3_use = blk3_amt - blk2_amt;
		blk4_use = blk4_amt - blk3_amt;
		blk5_use = blk5_amt - blk4_amt;
		blk6_use = use - blk5_amt;
	end;


******Creating proposed block uses for each customer*****;


	if use <= pblk1_amt then do;
		pblk1_use = use;
		pblk2_use = 0;
		pblk3_use = 0;
		pblk4_use = 0;
		pblk5_use = 0;
		pblk6_use = 0;
	end;

	if (use > pblk1_amt and use <= pblk2_amt) then do;
		pblk1_use = pblk1_amt;
		pblk2_use = use - pblk1_amt;
		pblk3_use = 0;
		pblk4_use = 0;
		pblk5_use = 0;
		pblk6_use = 0;
	end;
	
	if (use > pblk2_amt and use <= pblk3_amt) then do;
		pblk1_use = pblk1_amt;
		pblk2_use = pblk2_amt - pblk1_amt;
		pblk3_use = use - pblk2_amt;
		pblk4_use = 0;
		pblk5_use = 0;
		pblk6_use = 0;
	end;

	if (use > pblk3_amt and use <= pblk4_amt) then do;
		pblk1_use = pblk1_amt;
		pblk2_use = pblk2_amt - pblk1_amt;
		pblk3_use = pblk3_amt - pblk2_amt;
		pblk4_use = use - pblk3_amt;
		pblk5_use = 0;
		pblk6_use = 0;
	end;

	if (use > pblk4_amt and use <= pblk5_amt) then do;
		pblk1_use = pblk1_amt;
		pblk2_use = pblk2_amt - pblk1_amt;
		pblk3_use = pblk3_amt - pblk2_amt;
		pblk4_use = pblk4_amt - pblk3_amt;
		pblk5_use = use - pblk4_amt;
		pblk6_use = 0;
	end;
	
	if (use > pblk5_amt and use <= pblk6_amt) then do;
		pblk1_use = pblk1_amt;
		pblk2_use = pblk2_amt - pblk1_amt;
		pblk3_use = pblk3_amt - pblk2_amt;
		pblk4_use = pblk4_amt - pblk3_amt;
		pblk5_use = pblk5_amt - pblk4_amt;
		pblk6_use = use - pblk5_amt;
	end;



*****Calculating current and proposed base rate revenue for each customer*****;


	Current_BR_Rev = base_chrg + (blk1_use*blk1_chrg) + (blk2_use*blk2_chrg) + (blk3_use*blk3_chrg) + (blk4_use*blk4_chrg) + (blk5_use*blk5_chrg) + (blk6_use*blk6_chrg) 
					+ (surcharge*use);
	Proposed_BR_Rev = pbase_chrg + (pblk1_use*pblk1_chrg) + (pblk2_use*pblk2_chrg) + (pblk3_use*pblk3_chrg) + (pblk4_use*pblk4_chrg) + (pblk5_use*pblk5_chrg) 
					+ (pblk6_use*pblk6_chrg);


	base_first = base_chrg + (blk1_use*blk1_chrg);
	pbase_first = pbase_chrg + (pblk1_use*pblk1_chrg);
	bf_pct = base_first/current_br_rev;
	pbf_pct = pbase_first/proposed_br_rev;

	rate_diff = proposed_br_rev - current_br_rev;
	rate_diff_pct = proposed_br_rev/current_br_rev - 1;

	base_rev = pbase_chrg;
	tier1_rev = pblk1_use*pblk1_chrg;
	tier2_rev = pblk2_use*pblk2_chrg;
	tier3_rev = pblk3_use*pblk3_chrg;
	tier4_rev = pblk4_use*pblk4_chrg;
	tier5_rev = pblk5_use*pblk5_chrg;
	tier6_rev = pblk6_use*pblk6_chrg;
	total_rev = base_rev + tier1_rev + tier2_rev + tier3_rev + tier4_rev + tier5_rev + tier6_rev;


run;



*****Calculating total rate revenue by meter_size*****;
/*
proc sort data = rate_calc; by meter_size; run;
proc summary data = rate_calc; 
	by meter_size;
	var Current_BR_Rev Proposed_BR_Rev base_first pbase_first;
	output out = rate_impacts sum = ;
run;


data rate_impacts; set rate_impacts (drop = _type_ _freq_);
	
	pct_diff = proposed_br_rev/current_br_rev - 1;
	
	pct_basefirst = base_first/current_br_rev;
	p_pct_basefirst = pbase_first/proposed_br_rev;

	format pct_diff percent8.2;
	format current_br_rev dollar16.2;
	format proposed_br_rev dollar16.2;
	format base_first dollar16.2;
	format pbase_first dollar16.2;
	format pct_basefirst percent8.2;
	format p_pct_basefirst percent8.2;

run;

data rate_impacts2; 
	retain meter_size current_br_rev proposed_br_rev pct_diff base_first pbase_first pct_basefirst p_pct_basefirst;
	set rate_impacts; 
run;
	


proc export data = rate_impacts2
	outfile = 'U:\a-tx-projects\34805\029\SAS\RCOMP\Preliminary Rate Impacts.xlsx'
	dbms = xlsx replace;
	sheet = 'SAS Output';
run;



*****Creating database so I can set up an optimization probelm to calculate rates with lowest rev impact*****;


proc sort data = rate_calc; by meter_size; run;
proc summary data = rate_calc; 
	by meter_size; id pbase_chrg;
	var Current_BR_Rev Proposed_BR_Rev pblk1_use pblk2_use pblk3_use;
	output out = optimize sum = ;
run;

data optimize2; set optimize (drop = _type_);
	bc = pbase_chrg*_freq_;
	vol_rev = current_br_rev - bc;
run;


proc export data = optimize2
	outfile = 'U:\a-tx-projects\34805\029\SAS\RCOMP\Optimization.xlsx'
	dbms = xlsx replace;
	sheet = 'SAS Output';
run;

*/



*****Calculating individual customer impacts and creating database with summary statistics*****;

proc sort data = rate_calc; by premise_id; run;
proc summary data = rate_calc; 
	by premise_id;
	id meter_size;
	var current_br_rev proposed_br_rev pbase_first;
	output out = rate_calc2 sum =; 
run;

data rate_calc2; set rate_calc2 (drop = _type_);
	rate_diff = proposed_br_rev - current_br_rev;
	rate_diff_pct = proposed_br_rev/current_br_rev - 1;
	pbf_pct = pbase_first/proposed_br_rev;
run;


proc sort data = rate_calc2; by meter_size; run;

proc summary data = rate_calc2 n clm nway; 
	by meter_size;
	var rate_diff;
	output out = cust_impacts_dol n=n mean=mean std=sd median=median min=min max=max q1=q1 q3=q3 p10=p10 p90=p90;
run;


proc summary data = rate_calc2 n clm nway; 
	by meter_size;
	var rate_diff_pct;
	output out = cust_impacts_pct n=n mean=mean std=sd median=median min=min max=max q1=q1 q3=q3 p10=p10 p90=p90;
run;

proc summary data = rate_calc2 n clm nway; 
	by meter_size;
	var pbf_pct;
	output out = cust_impacts_pbf n=n mean=mean std=sd median=median min=min max=max q1=q1 q3=q3 p10=p10 p90=p90;
run;

proc sort data = rate_calc; by meter_size; run;
proc summary data = rate_calc;
	by meter_size;
	var base_rev tier1_rev tier2_rev tier3_rev tier4_rev tier5_rev tier6_rev total_rev;
	output out = tier_rev sum = ;
run;


/*
proc export data = cust_impacts_dol
	outfile = &output
	dbms = xlsx replace;
	sheet = dollars;
run;


proc export data = cust_impacts_pct
	outfile = &output
	dbms = xlsx replace;
	sheet = percent;
run;


proc export data = cust_impacts_pbf
	outfile = &output
	dbms = xlsx replace;
	sheet = pct_base_first;
run;

proc export data = tier_rev
	outfile = &output
	dbms = xlsx replace;
	sheet = tier_rev;
run;

*/

*****Calculating individual customer impacts BY DISTRICT and creating database with summary statistics*****;

proc sort data = rate_calc; by premise_id district; run;
proc summary data = rate_calc; 
	by premise_id district;
	id meter_size;
	var current_br_rev proposed_br_rev base_first pbase_first;
	output out = rate_calc2 sum =; 
run;

data rate_calc2; set rate_calc2 (drop = _type_);
	rate_diff = proposed_br_rev - current_br_rev;
	rate_diff_pct = proposed_br_rev/current_br_rev - 1;
	pbf_pct = pbase_first/proposed_br_rev;
run;


proc sort data = rate_calc2; by district meter_size; run;

proc summary data = rate_calc2 n clm nway; 
	by district meter_size;
	var rate_diff;
	output out = cust_impacts_dol n=n mean=mean std=sd median=median min=min max=max q1=q1 q3=q3 p10=p10 p90=p90;
run;


proc summary data = rate_calc2 n clm nway; 
	by district meter_size;
	var rate_diff_pct;
	output out = cust_impacts_pct n=n mean=mean std=sd median=median min=min max=max q1=q1 q3=q3 p10=p10 p90=p90;
run;

proc summary data = rate_calc2 n clm nway; 
	by district meter_size;
	var pbf_pct;
	output out = cust_impacts_pbf n=n mean=mean std=sd median=median min=min max=max q1=q1 q3=q3 p10=p10 p90=p90;
run;

proc sort data = rate_calc; by district meter_size; run;
proc summary data = rate_calc;
	by district meter_size;
	var base_rev tier1_rev tier2_rev tier3_rev tier4_rev tier5_rev tier6_rev total_rev;
	output out = tier_rev sum = ;
run;


/*
proc export data = cust_impacts_dol
	outfile = &districtoutput
	dbms = xlsx replace;
	sheet = dollars;
run;


proc export data = cust_impacts_pct
	outfile = &districtoutput
	dbms = xlsx replace;
	sheet = percent;
run;

proc export data = cust_impacts_pbf
	outfile = &districtoutput
	dbms = xlsx replace;
	sheet = pct_base_first;
run;

proc export data = tier_rev
	outfile = &districtoutput
	dbms = xlsx replace;
	sheet = tier_rev;
run;
*/

****Creating database for further analysis. Also calculating use by tier for Nick****;

proc sort data = rate_calc; by meter_size; run;
proc summary data = rate_calc;
	by meter_size;
	var pblk1_use pblk2_use pblk3_use;
	output out = tier_use sum = ;
run;


*Putting revenue, use, etc on annual basis rather than monthly;

proc sort data = rate_calc; by premise_id; run;
proc summary data = rate_calc; 
	id District_Id Rate Type Meter_Size District;
	by Premise_Id;
	var blk1_use blk2_use blk3_use blk4_use blk5_use blk6_use pblk1_use pblk2_use pblk3_use pblk4_use pblk5_use pblk6_use Current_BR_Rev Proposed_BR_Rev base_first pbase_first;
	output out = Annual_Output sum = ;
run;

data Annual_Output (drop = _type_);
	set Annual_Output;
		rev_diff = Proposed_BR_Rev - Current_BR_Rev;
		pct_diff = Proposed_BR_Rev/Current_BR_Rev - 1; 
run;


data Annual_Output2; set Annual_Output;


	***********Creating bins of customers based on pct impact**************;

if (pct_diff < -.20) then bin = 1;
if (-.20<= pct_diff < -.19) then bin = 2;
if (-.19<= pct_diff < -.18) then bin = 3;
if (-.18<= pct_diff < -.17) then bin = 4;
if (-.17<= pct_diff < -.16) then bin = 5;
if (-.16<= pct_diff < -.15) then bin = 6;
if (-.15<= pct_diff < -.14) then bin = 7;
if (-.14<= pct_diff < -.13) then bin = 8;
if (-.13<= pct_diff < -.12) then bin = 9;
if (-.12<= pct_diff < -.11) then bin = 10;
if (-.11<= pct_diff < -.10) then bin = 11;
if (-.10<= pct_diff < -.09) then bin = 12;
if (-.09<= pct_diff < -.08) then bin = 13;
if (-.08<= pct_diff < -.07) then bin = 14;
if (-.07<= pct_diff < -.06) then bin = 15;
if (-.06<= pct_diff < -.05) then bin = 16;
if (-.05<= pct_diff < -.04) then bin = 17;
if (-.04<= pct_diff < -.03) then bin = 18;
if (-.03<= pct_diff < -.02) then bin = 19;
if (-.02<= pct_diff < -.01) then bin = 20;
if (-.01<= pct_diff < 0) then bin = 21;
if (0<= pct_diff < .01) then bin = 22;
if (.01<= pct_diff < .02) then bin = 23;
if (.02<= pct_diff < .03) then bin = 24;
if (.03<= pct_diff < .04) then bin = 25;
if (.04<= pct_diff < .05) then bin = 26;
if (.05<= pct_diff < .06) then bin = 27;
if (.06<= pct_diff < .07) then bin = 28;
if (.07<= pct_diff < .08) then bin = 29;
if (.08<= pct_diff < .09) then bin = 30;
if (.09<= pct_diff < .10) then bin = 31;
if (.10<= pct_diff < .11) then bin = 32;
if (.11<= pct_diff < .12) then bin = 33;
if (.12<= pct_diff < .13) then bin = 34;
if (.13<= pct_diff < .14) then bin = 35;
if (.14<= pct_diff < .15) then bin = 36;
if (.15<= pct_diff < .16) then bin = 37;
if (.16<= pct_diff < .17) then bin = 38;
if (.17<= pct_diff < .18) then bin = 39;
if (.18<= pct_diff < .19) then bin = 40;
if (.19<= pct_diff <= .20) then bin = 41;
if (pct_diff > .20) then bin = 42;


	***********Creating second, larger bins of customers based on pct impact**************;

if (pct_diff < -1) then bin2 = 1;
if (-.9<= pct_diff < -.80) then bin2 = 2;
if (-.8<= pct_diff < -.7) then bin2 = 3;
if (-.7<= pct_diff < -.6) then bin2 = 4;
if (-.6<= pct_diff < -.5) then bin2 = 5;
if (-.5<= pct_diff < -.4) then bin2 = 6;
if (-.4<= pct_diff < -.3) then bin2 = 7;
if (-.3<= pct_diff < -.25) then bin2 = 8;
if (-.25<= pct_diff < -.2) then bin2 = 9;
if (-.2<= pct_diff < -.15) then bin2 = 10;
if (-.15<= pct_diff < -.10) then bin2 = 11;
if (-.10<= pct_diff < -.09) then bin2 = 12;
if (-.09<= pct_diff < -.08) then bin2 = 13;
if (-.08<= pct_diff < -.07) then bin2 = 14;
if (-.07<= pct_diff < -.06) then bin2 = 15;
if (-.06<= pct_diff < -.05) then bin2 = 16;
if (-.05<= pct_diff < -.04) then bin2 = 17;
if (-.04<= pct_diff < -.03) then bin2 = 18;
if (-.03<= pct_diff < -.02) then bin2 = 19;
if (-.02<= pct_diff < -.01) then bin2 = 20;
if (-.01<= pct_diff < 0) then bin2 = 21;
if (0<= pct_diff < .01) then bin2 = 22;
if (.01<= pct_diff < .02) then bin2 = 23;
if (.02<= pct_diff < .03) then bin2 = 24;
if (.03<= pct_diff < .04) then bin2 = 25;
if (.04<= pct_diff < .05) then bin2 = 26;
if (.05<= pct_diff < .06) then bin2 = 27;
if (.06<= pct_diff < .07) then bin2 = 28;
if (.07<= pct_diff < .08) then bin2 = 29;
if (.08<= pct_diff < .09) then bin2 = 30;
if (.09<= pct_diff < .10) then bin2 = 31;
if (.10<= pct_diff < .15) then bin2 = 32;
if (.15<= pct_diff < .2) then bin2 = 33;
if (.2<= pct_diff < .25) then bin2 = 34;
if (.25<= pct_diff < .3) then bin2 = 35;
if (.3<= pct_diff < .4) then bin2 = 36;
if (.4<= pct_diff < .5) then bin2 = 37;
if (.5<= pct_diff < .6) then bin2 = 38;
if (.6<= pct_diff < .7) then bin2 = 39;
if (.7<= pct_diff < .8) then bin2 = 40;
if (.8<= pct_diff <= .9) then bin2 = 41;
if (.9<= pct_diff <= 1) then bin2 = 42;
if (pct_diff > 1) then bin2 = 43;

run;

proc export data = Annual_Output2
	outfile = &annualoutput
	dbms = xlsx replace;
	sheet = Annual_Output;
run;

data rc.Annual_Impacts_&rate; set Annual_Output2; run;

%mend;



*%rcomp(rate1, 'U:\a-tx-projects\34805\029\SAS\RCOMP\Proposed Rates\Proposed Rate 1.xlsx', 'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Rate 1\RCOMP SAS Output',
		'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Rate 1\RCOMP SAS Output - by District');

*%rcomp(rate2, 'U:\a-tx-projects\34805\029\SAS\RCOMP\Proposed Rates\Proposed Rate 2.xlsx', 'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Rate 2\RCOMP SAS Output',
		'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Rate 2\RCOMP SAS Output - by District');

*%rcomp(rate3, 'U:\a-tx-projects\34805\029\SAS\RCOMP\Proposed Rates\Proposed Rate 3.xlsx', 'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Rate 3\RCOMP SAS Output',
		'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Rate 3\RCOMP SAS Output - by District');

*%rcomp(rate4, 'U:\a-tx-projects\34805\029\SAS\RCOMP\Proposed Rates\Proposed Rate 4.xlsx', 'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Rate 4\RCOMP SAS Output',
		'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Rate 4\RCOMP SAS Output - by District');

%rcomp(scenario1, 'U:\a-tx-projects\34805\029\SAS\RCOMP\Proposed Rates\Scenario 1.xlsx', 'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 1\RCOMP SAS Output',
		'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 1\RCOMP SAS Output - by District', 
		'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 1\Annual Database');

%rcomp(scenario2, 'U:\a-tx-projects\34805\029\SAS\RCOMP\Proposed Rates\Scenario 2.xlsx', 'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 2\RCOMP SAS Output',
		'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 2\RCOMP SAS Output - by District',
		 'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 2\Annual Database');

%rcomp(scenario3, 'U:\a-tx-projects\34805\029\SAS\RCOMP\Proposed Rates\Scenario 3.xlsx', 'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 3\RCOMP SAS Output',
		'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 3\RCOMP SAS Output - by District',
		'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 3\Annual Database');

%rcomp(scenario4, 'U:\a-tx-projects\34805\029\SAS\RCOMP\Proposed Rates\Scenario 4.xlsx', 'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 4\RCOMP SAS Output',
		'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 4\RCOMP SAS Output - by District',
		'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 4\Annual Database');

%rcomp(scenario5, 'U:\a-tx-projects\34805\029\SAS\RCOMP\Proposed Rates\Scenario 5.xlsx', 'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 5\RCOMP SAS Output',
		'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 5\RCOMP SAS Output - by District',
		'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\Scenario 5\Annual Database');
