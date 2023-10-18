
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

	format base_chrg best12.;
	format Blk1_chrg best12.;
	format Blk2_chrg best12.;
	format Blk3_chrg best12.;
	format Blk4_chrg best12.;
	format Blk5_chrg best12.;
	format Blk6_chrg best12.;
run;


proc import datafile = 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\MEs SAS.xlsx'
	out=ME
	dbms=xlsx
	replace;
	sheet="Sheet1";
run;




*********Macro to calculate total class revenue and block consumption by rate, type, for each district********;

%macro res_gds_calc(dist,folder);

libname ep "U:\a-tx-projects\34805\029\SAS\Raw Bill Data\&folder";
libname pr "U:\a-tx-projects\34805\029\SAS\Proof of Revenue\&folder";
libname sd "U:\a-tx-projects\34805\029\SAS\Proof of Revenue\SAS Summary DBs";

/*data &dist; set ep.raw_combined; run;*/


data temp; set &dist;

	year = substr(bill_date, 1, 4);
	mon = substr(bill_date, 6, 2); 
	day = substr(bill_date, 9, 2);
	format date mmddyy10.;
	date = mdy(mon, day, year);
	month = month(date);
run;

data temp (drop = rate_schedule_fee_type Number_of_Units); set temp;
	rate = rate_schedule_fee_type;
	units = number_of_units;
run;

data temp; set temp
	(keep = Bill_id Premise_id Account_Id Account_name Meter_id utility_usage Days Meter_size District Bill_amount Tax_amount Charge_Amount Charge_rate Transaction_Description
			Charge_usage Journal_amount Category Date Month Rate Units);
run;


proc sort data = temp out = temp2 nodupkey; by premise_id month rate; run;   


proc sort data = resrates; by rate meter_size; run;
proc sort data = temp2; by rate meter_size; run;

data temp3; 
	merge resrates (in=x1) temp2 (in=y1);
	by rate meter_size;
	x=x1;
	y=y1;
run;

data temp3; set temp3;
	if x = 1 and y = 1;
run;

data temp4 (drop = x y); set temp3; 

if district_ID ^= 2352 or district_ID ^= 2310 or district_ID ^= 2348 then do;

	if utility_usage < 0 then do;
		blk1_use = 0;
		blk2_use = 0;
		blk3_use = 0;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;

	if utility_usage <= blk1_amt then do;
		blk1_use = utility_usage;
		blk2_use = 0;
		blk3_use = 0;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;

	if (utility_usage > blk1_amt and utility_usage <= blk2_amt) then do;
		blk1_use = blk1_amt;
		blk2_use = utility_usage - blk1_amt;
		blk3_use = 0;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;
	
	if (utility_usage > blk2_amt and utility_usage <= blk3_amt) then do;
		blk1_use = blk1_amt;
		blk2_use = blk2_amt - blk1_amt;
		blk3_use = utility_usage - blk2_amt;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;
	
	if (utility_usage > blk3_amt and utility_usage <= blk4_amt) then do;
		blk1_use = blk1_amt;
		blk2_use = blk2_amt - blk1_amt;
		blk3_use = blk3_amt - blk2_amt;
		blk4_use = utility_usage - blk3_amt;
		blk5_use = 0;
		blk6_use = 0;
	end;
	
	if (utility_usage > blk4_amt and utility_usage <= blk5_amt) then do;
		blk1_use = blk1_amt;
		blk2_use = blk2_amt - blk1_amt;
		blk3_use = blk3_amt - blk2_amt;
		blk4_use = blk4_amt - blk3_amt;
		blk5_use = utility_usage - blk4_amt;
		blk6_use = 0;
	end;
	
	if (utility_usage > blk5_amt and utility_usage <= blk6_amt) then do;
		blk1_use = blk1_amt;
		blk2_use = blk2_amt - blk1_amt;
		blk3_use = blk3_amt - blk2_amt;
		blk4_use = blk4_amt - blk3_amt;
		blk5_use = blk5_amt - blk4_amt;
		blk6_use = utility_usage - blk5_amt;
	end;

	Present_BR_Rev = base_chrg + (blk1_use*blk1_chrg) + (blk2_use*blk2_chrg) + (blk3_use*blk3_chrg) + (blk4_use*blk4_chrg) + (blk5_use*blk5_chrg) + (blk6_use*blk6_chrg);

	****Code for Nick to match back to our Calculations****;
				base_revenue = base_chrg;
				vol_revenue = (blk1_use*blk1_chrg) + (blk2_use*blk2_chrg) + (blk3_use*blk3_chrg) + (blk4_use*blk4_chrg) + (blk5_use*blk5_chrg) + (blk6_use*blk6_chrg);

end;
	

if district_ID = 2310 or district_ID = 2348 then do;  ***PV and WV pro-rate their base charge and block amounts based on days in service/30.***;

if Days < 25 then prorate = days/30; else prorate = 1;

		if utility_usage < 0 then do;
		blk1_use = 0;
		blk2_use = 0;
		blk3_use = 0;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;

	if utility_usage <= blk1_amt*prorate then do;
		blk1_use = utility_usage;
		blk2_use = 0;
		blk3_use = 0;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;

	if (utility_usage > blk1_amt*prorate and utility_usage <= blk2_amt*prorate) then do;
		blk1_use = blk1_amt*prorate;
		blk2_use = utility_usage - blk1_amt*prorate;
		blk3_use = 0;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;
	
	if (utility_usage > blk2_amt*prorate and utility_usage <= blk3_amt*prorate) then do;
		blk1_use = blk1_amt*prorate;
		blk2_use = blk2_amt*prorate - blk1_amt*prorate;
		blk3_use = utility_usage - blk2_amt*prorate;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;
	
	if (utility_usage > blk3_amt*prorate and utility_usage <= blk4_amt*prorate) then do;
		blk1_use = blk1_amt*prorate;
		blk2_use = blk2_amt*prorate - blk1_amt*prorate;
		blk3_use = blk3_amt*prorate - blk2_amt*prorate;
		blk4_use = utility_usage - blk3_amt*prorate;
		blk5_use = 0;
		blk6_use = 0;
	end;
	
	if (utility_usage > blk4_amt*prorate and utility_usage <= blk5_amt*prorate) then do;
		blk1_use = blk1_amt*prorate;
		blk2_use = blk2_amt*prorate - blk1_amt*prorate;
		blk3_use = blk3_amt*prorate - blk2_amt*prorate;
		blk4_use = blk4_amt*prorate - blk3_amt*prorate;
		blk5_use = utility_usage - blk4_amt*prorate;
		blk6_use = 0;
	end;
	
	if (utility_usage > blk5_amt*prorate and utility_usage <= blk6_amt*prorate) then do;
		blk1_use = blk1_amt*prorate;
		blk2_use = blk2_amt*prorate - blk1_amt*prorate;
		blk3_use = blk3_amt*prorate - blk2_amt*prorate;
		blk4_use = blk4_amt*prorate - blk3_amt*prorate;
		blk5_use = blk5_amt*prorate - blk4_amt*prorate;
		blk6_use = utility_usage - blk5_amt*prorate;
	end;


	Present_BR_Rev = (base_chrg*prorate) + (blk1_use*blk1_chrg) + (blk2_use*blk2_chrg) + (blk3_use*blk3_chrg) + (blk4_use*blk4_chrg) + (blk5_use*blk5_chrg) + (blk6_use*blk6_chrg);

	****Code for Nick to match back to our Calculations****;
				base_revenue = base_chrg*prorate;
				vol_revenue = (blk1_use*blk1_chrg) + (blk2_use*blk2_chrg) + (blk3_use*blk3_chrg) + (blk4_use*blk4_chrg) + (blk5_use*blk5_chrg) + (blk6_use*blk6_chrg);

end;




if district_ID = 2352 then do; 	***HV pro-rates their base charge and block amounts based on days in service/30. 
																			***HV has apt units multiplied by base charge***;

	if Days < 25 then prorate = days/30; else prorate = 1;

		if utility_usage < 0 then do;
		blk1_use = 0;
		blk2_use = 0;
		blk3_use = 0;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;

	if utility_usage <= blk1_amt*prorate then do;
		blk1_use = utility_usage;
		blk2_use = 0;
		blk3_use = 0;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;

	if (utility_usage > blk1_amt*prorate and utility_usage <= blk2_amt*prorate) then do;
		blk1_use = blk1_amt*prorate;
		blk2_use = utility_usage - blk1_amt*prorate;
		blk3_use = 0;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;
	
	if (utility_usage > blk2_amt*prorate and utility_usage <= blk3_amt*prorate) then do;
		blk1_use = blk1_amt*prorate;
		blk2_use = blk2_amt*prorate - blk1_amt*prorate;
		blk3_use = utility_usage - blk2_amt*prorate;
		blk4_use = 0;
		blk5_use = 0;
		blk6_use = 0;
	end;
	
	if (utility_usage > blk3_amt*prorate and utility_usage <= blk4_amt*prorate) then do;
		blk1_use = blk1_amt*prorate;
		blk2_use = blk2_amt*prorate - blk1_amt*prorate;
		blk3_use = blk3_amt*prorate - blk2_amt*prorate;
		blk4_use = utility_usage - blk3_amt*prorate;
		blk5_use = 0;
		blk6_use = 0;
	end;
	
	if (utility_usage > blk4_amt*prorate and utility_usage <= blk5_amt*prorate) then do;
		blk1_use = blk1_amt*prorate;
		blk2_use = blk2_amt*prorate - blk1_amt*prorate;
		blk3_use = blk3_amt*prorate - blk2_amt*prorate;
		blk4_use = blk4_amt*prorate - blk3_amt*prorate;
		blk5_use = utility_usage - blk4_amt*prorate;
		blk6_use = 0;
	end;
	
	if (utility_usage > blk5_amt*prorate and utility_usage <= blk6_amt*prorate) then do;
		blk1_use = blk1_amt*prorate;
		blk2_use = blk2_amt*prorate - blk1_amt*prorate;
		blk3_use = blk3_amt*prorate - blk2_amt*prorate;
		blk4_use = blk4_amt*prorate - blk3_amt*prorate;
		blk5_use = blk5_amt*prorate - blk4_amt*prorate;
		blk6_use = utility_usage - blk5_amt*prorate;
	end;

	if Type = 'Res Apt' then do;

		Present_BR_Rev = (base_chrg*prorate*units) + (blk1_use*blk1_chrg) + (blk2_use*blk2_chrg) + (blk3_use*blk3_chrg) + (blk4_use*blk4_chrg)
						 + (blk5_use*blk5_chrg) + (blk6_use*blk6_chrg);

		****Code for Nick to match back to our Calculations****;
				base_revenue = base_chrg*prorate*units;
				vol_revenue = (blk1_use*blk1_chrg) + (blk2_use*blk2_chrg) + (blk3_use*blk3_chrg) + (blk4_use*blk4_chrg) + (blk5_use*blk5_chrg) + (blk6_use*blk6_chrg);
	end;

	if Type ^= 'Res Apt' then do;

		Present_BR_Rev = (base_chrg*prorate) + (blk1_use*blk1_chrg) + (blk2_use*blk2_chrg) + (blk3_use*blk3_chrg) + (blk4_use*blk4_chrg) + (blk5_use*blk5_chrg)
						 + (blk6_use*blk6_chrg);

		****Code for Nick to match back to our Calculations****;
				base_revenue = base_chrg*prorate;
				vol_revenue = (blk1_use*blk1_chrg) + (blk2_use*blk2_chrg) + (blk3_use*blk3_chrg) + (blk4_use*blk4_chrg) + (blk5_use*blk5_chrg) + (blk6_use*blk6_chrg);
	end;

end;

run;


****More code to check back to our calculations****;

proc sort data = temp4; by month meter_size; run;
proc summary data = temp4;
	by month meter_size;
	var base_revenue vol_revenue;
	output out = nick sum = ;
run;

data nick; set nick ( drop = _type_ _freq_); run;

proc export data = nick
	outfile = 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\SAS Summary DBs\Rev by Meter Size - SAS Output.xlsx'
	dbms = xlsx replace;
	sheet = &dist;
run;

*******;

/*

proc sort data = temp4; by month; run;
proc summary data = temp4; 
	by month;
	var Present_BR_Rev;
	output out = gds_base_rate_calc sum = ;
run;

data gds_base_rate_rev (drop = _Type_); set gds_base_rate_calc; run;


proc export data = gds_base_rate_rev
	outfile = 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\SAS Summary DBs\GDS Base Rate Rev - SAS Output.xlsx'
	dbms = xlsx replace;
	sheet = &dist;
run;




proc sort data = temp4; by meter_size; run;
proc sort data = me; by meter_size; run;
data temp5; 
	merge temp4 (in=x1) me (in=y1);
	by meter_size;
	x=x1;
	y=y1;
run;

data temp6; set temp5;
	if x = 1 and y = 1;
run;

data pr.base_rate_&dist;
	set temp6 (drop = District Bill_amount Tax_amount Charge_amount Charge_rate Transaction_description Charge_usage Journal_amount x y);
run;




/*

****Getting base rate revenue by premise id to compare to GDS base rate revenue. Only necessary for determining differences in calculated vs. reported revenue***;


proc sort data = resrates; by rate meter_size; run;
proc sort data = temp; by rate meter_size; run;

data temp10; 
	merge resrates (in=x1) temp (in=y1);
	by rate meter_size;
	x=x1;
	y=y1;
run;

data temp11; set temp10;
	if x = 1 and y = 1;
run;

data temp11; set temp11 (drop = x y);


	if (charge_rate = blk1_chrg and Type ^= 'Adj') or (charge_rate = blk2_chrg and Type ^= 'Adj') or (charge_rate = blk3_chrg and Type ^= 'Adj')
		or (charge_rate = blk4_chrg and Type ^= 'Adj') or (charge_rate = blk5_chrg and Type ^= 'Adj') or (charge_rate = blk6_chrg and Type ^= 'Adj')
		or Transaction_description = 'Water Basic Service' then base_rate = 1; else base_rate = 0;
	if Transaction_description = 'One-Time Tax Credit' or Transaction_description = 'Establishment Charge' then base_rate = 0;
run;

data id_rev; set temp11;
	if base_rate = 1;
run;

proc sort data = id_rev; by premise_id month rate; run;
proc summary data = id_rev; 
	by premise_id month rate;
	var Charge_Amount;
	output out = id_revenue sum = base_rate_revenue;
run;

data id_revenue; set id_revenue (drop = _Type_); 
	label base_rate_revenue = 'Base_Rate_Revenue';
run;


proc sort data = temp11 out = temp12; by premise_id month; run;
proc sort data = id_revenue; by premise_id month; run;
data id_revenue2; 
	merge temp12 (in=x1) id_revenue (in=y1);
	by premise_id month;
	x=x1;
	y=y1;
run;

data rev_comp; set id_revenue2;
	if x = 1 and y = 1;
run;

data rev_comp (keep = Premise_Id Month Base_Rate_Revenue); 
	set rev_comp;
run;


proc sort data = temp4; by premise_id month; run;

data rev_comp2; 
	merge rev_comp (in=x1) temp4 (in=y1);
	by premise_id month;
	x=x1;
	y=y1;
run;

data rev_comp3; set rev_comp2;
	if x = 1 and y = 1;
run;

data rev_comp3; set rev_comp3 (drop = x y); 
	BR_diff = Base_Rate_Revenue - Present_BR_Rev;
	pct_diff = (Base_Rate_Revenue/Present_BR_Rev)-1;
run;

proc sort data = temp; by premise_id month; run;
proc sort data = rev_comp3; by premise_id month; run;

data rev_comp4; 
	merge rev_comp3 (in=x1) temp (in=y1);
	by premise_id month;
	x = x1;
	y = y1;
run;

data rev_comp5; set rev_comp4;
	if x = 1 and y = 1;
run;

data rev_comp6; set rev_comp5;
	if pct_diff < -0.005 or pct_diff > 0.005;
run;

proc export data = rev_comp6
	outfile = 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\SAS Summary DBs\Base Rate Differences.xlsx'
	dbms = xlsx replace;
	sheet = &dist;
run;
*/

	 

%mend;



%res_gds_calc(AF,Agua Fria);
*%res_gds_calc(ATM,Anthem);
*%res_gds_calc(ATM_NP,Anthem Non-Potable);		*Doesn't have any "residential" rates or services;
*%res_gds_calc(CP,Chaparral);
%res_gds_calc(HV,Havasu);						
*%res_gds_calc(MH,Mohave);
*%res_gds_calc(NMH,Mohave North);
%res_gds_calc(PV,Paradise Valley); /*
%res_gds_calc(SC,Sun City);
%res_gds_calc(SCW,Sun City West);
%res_gds_calc(TB,Tubac);
%res_gds_calc(WV,Willow Valley);
