
*******************************************************************EPCOR Proof of Revenue Calculations***************************************************************************;



***Importing in only Residential Rates***;

proc import datafile = 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Residential Rates.xlsx'
	out=ResRates
	dbms=xlsx
	replace;
	sheet="Sheet1";
run;


data resrates; set resrates;
	format Blk1_Amt best12.;
	format Blk2_Amt best12.;
	format Blk3_Amt best12.;
	format Blk4_Amt best12.;
	format Blk5_Amt best12.;
	format Blk6_Amt best12.;
run;
*/

*********Macro to calculate total class revenue and block consumption by rate, type, for each district********;

%macro res_totrevenue(dist,folder);

libname ep "U:\a-tx-projects\34805\029\SAS\Raw Bill Data\&folder";
libname pr "U:\a-tx-projects\34805\029\SAS\Proof of Revenue\&folder";
libname sd "U:\a-tx-projects\34805\029\SAS\Proof of Revenue\SAS Summary DBs";

data &dist; set ep.raw_combined; run;



data temp; set &dist;
	year = substr(bill_date, 1, 4);
	mon = substr(bill_date, 6, 2); 
	day = substr(bill_date, 9, 2);
	format date mmddyy10.;
	date = mdy(mon, day, year);
	month = month(date);
run;

proc sort data = temp; by premise_id month; run;


data temp (drop = rate_schedule_fee_type); set temp;
	rate = rate_schedule_fee_type;
run;

data temp; set temp
	(keep = Bill_id Premise_id Account_Id Account_name Meter_id utility_usage Meter_size District Bill_amount Tax_amount Charge_Amount Charge_rate Transaction_Description
			Charge_usage Journal_amount Category Date Month Rate Days);
run;


proc sort data = resrates; by rate meter_size; run;
proc sort data = temp; by rate meter_size; run;

data temp2; 
	merge resrates (in=x1) temp (in=y1);
	by rate meter_size;
	x=x1;
	y=y1;
run;

data temp2; set temp2;
	if x = 1 and y = 1;
run;

/*
proc freq data = temp; 
	tables transaction_description;
run;
*/

proc sort data = temp2; by premise_id month rate; run;

data temp3; set temp2;

	if blk1_chrg = 0 then blk1_chrg = '';
	if blk2_chrg = 0 then blk2_chrg = '';
	if blk3_chrg = 0 then blk3_chrg = '';
	if blk4_chrg = 0 then blk4_chrg = '';
	if blk5_chrg = 0 then blk5_chrg = '';
	if blk6_chrg = 0 then blk6_chrg = '';

	format blk1_chrg best12.;
	format blk2_chrg best12.;
	format blk3_chrg best12.;
	format blk4_chrg best12.;
	format blk5_chrg best12.;
	format blk6_chrg best12.;

	charge_rate = round(charge_rate, 0.0000001); 

	blk1_chrg = round(blk1_chrg, 0.0000001); 
	blk2_chrg = round(blk2_chrg, 0.0000001); 
	blk3_chrg = round(blk3_chrg, 0.0000001); 
	blk4_chrg = round(blk4_chrg, 0.0000001); 
	blk5_chrg = round(blk5_chrg, 0.0000001); 
	blk6_chrg = round(blk6_chrg, 0.0000001); 

	if (charge_rate = blk1_chrg and Type ^= 'Adj') or (charge_rate = blk2_chrg and Type ^= 'Adj') or (charge_rate = blk3_chrg and Type ^= 'Adj')
		or (charge_rate = blk4_chrg and Type ^= 'Adj') or (charge_rate = blk5_chrg and Type ^= 'Adj') or (charge_rate = blk6_chrg and Type ^= 'Adj')
		or Transaction_description = 'Water Basic Service' then base_rate = 1; else base_rate = 0;
	if Transaction_description = 'One-Time Tax Credit' or Transaction_description = 'Establishment Charge' then base_rate = 0;

	if blk1_chrg = charge_rate then blk1_use = charge_usage;
	if blk2_chrg = charge_rate then blk2_use = charge_usage;
	if blk3_chrg = charge_rate then blk3_use = charge_usage;
	if blk4_chrg = charge_rate then blk4_use = charge_usage;
	if blk5_chrg = charge_rate then blk5_use = charge_usage;
	if blk6_chrg = charge_rate then blk6_use = charge_usage;

run;

/*
   ******Running to show base rate charges for apartments do not align with rate file or rate pdf********;
data apt; set temp3; 
	if Rate = 'H1M3F' OR RATE = 'H1M3P' OR RATE = 'H1M3G' ;
RUN;

data apt_base_rates; set apt;
	if Category = 'BASIC';
run;
*/


proc sort data = temp3; by month rate type base_rate; run;
proc summary data = temp3; 
	by month rate type base_rate;
	var charge_amount blk1_use blk2_use blk3_use blk4_use blk5_use blk6_use;
	output out = blk_amts sum = ;
run;

/*			***This code was just used to figure out what was going on with Havasu***			


proc sort data = temp3 out = temp4 nodupkey; by bill_id month rate transaction_description; run;

proc sort data = temp4; by month rate type base_rate; run;
proc summary data = temp4; 
	by month rate type base_rate;
	var charge_amount blk1_use blk2_use blk3_use blk4_use blk5_use blk6_use;
	output out = blk_amts2 sum = ;
run;

*/

proc sort data = temp3 out = temp5 nodupkey; by premise_id month rate; run;

proc sort data = temp5; by month rate type; run;
proc summary data = temp5; 
	by month rate type;
	var bill_amount tax_amount charge_amount;
	output out = totrev sum = ;
run;


data sd.Res_Total_Revenue (drop = _Type_); set totrev; run;
data sd.Blk_consumption (drop = _Type_); set blk_amts; run;

proc export data = sd.Res_Total_Revenue
	outfile = 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\SAS Summary DBs\Res Total Revenue - SAS Output.xlsx'
	dbms = xlsx replace;
	sheet = &dist;
run;

proc export data = sd.Blk_consumption
	outfile = 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\SAS Summary DBs\Blk Use - SAS Output.xlsx'
	dbms = xlsx replace;
	sheet = &dist;
run;


proc export data = blk_amts2
	outfile = 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\SAS Summary DBs\Blk Use - SAS Output - HV.xlsx'
	dbms = xlsx replace;
	sheet = &dist;
run;

*****Just exporting a few accounts to try to re-calculate bills****;
/*
proc sort data = temp3; by premise_id month; run;
data accts_sample; set temp3 (obs = 50); run;

proc export data = accts_sample
	outfile = 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\SAS Summary DBs\Sample of Accounts.xlsx'
	dbms = xlsx replace;
	sheet = &dist;
run;
*/



%mend;



*%res_totrevenue(AF,Agua Fria);
*%res_totrevenue(ATM,Anthem);
*%res_totrevenue(ATM_NP,Anthem Non-Potable);     *Doesn't have any "residential" rates or services;
*%res_totrevenue(CP,Chaparral);
%res_totrevenue(HV,Havasu);
/*%res_totrevenue(MH,Mohave);
%res_totrevenue(NMH,Mohave North);
%res_totrevenue(PV,Paradise Valley);
%res_totrevenue(SC,Sun City);
%res_totrevenue(SCW,Sun City West);
%res_totrevenue(TB,Tubac);
%res_totrevenue(WV,Willow Valley);



