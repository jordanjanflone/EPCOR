***********************************************************************EPCOR Rate Scenario Analysis*****************************************************************************;

libname rc 'U:\a-tx-projects\34805\029\SAS\RCOMP\SAS Outputs\SAS DBs';


data s1; set rc.annual_impacts_scenario1; 
	format proposed_br_rev dollar.;
	format rev_diff dollar.;
	format pct_diff percent.;
run;

data s2; set rc.annual_impacts_scenario2; 
	format proposed_br_rev dollar.;
	format rev_diff dollar.;
	format pct_diff percent.;
run;

data s3; set rc.annual_impacts_scenario3; 
	format proposed_br_rev dollar.;
	format rev_diff dollar.;
	format pct_diff percent.;
run;

data s4; set rc.annual_impacts_scenario4; 
	format proposed_br_rev dollar.;
	format rev_diff dollar.;
	format pct_diff percent.;
run;

data s5; set rc.annual_impacts_scenario5; 
	format proposed_br_rev dollar.;
	format rev_diff dollar.;
	format pct_diff percent.;
run;

proc sort data = s1; by district meter_size; run;
proc sort data = s2; by district meter_size; run;
proc sort data = s3; by district meter_size; run;
proc sort data = s4; by district meter_size; run;
proc sort data = s5; by district meter_size; run;


**Option 1 for graphical output**; **Option 1 is unused*;
/*
	**Scenario 1 Rates*;

goptions reset = all;
ods pdf close;
ods graphics / AttrPriority = None;
ods pdf file = 'U:\a-tx-projects\34805\029\SAS\RCOMP\Rate Scenarios - 2019.1.10\Graph Comp 1.pdf' startpage = no;
options orientation = landscape;
*goptions hsize = 10in horigin = 1in vsize = 7.5in vorigin = 1in;
proc sgplot data = s1  noborder;
	title 'Individual Customer Impacts';
	label pct_diff = 'Annual Bill Change' proposed_br_rev = 'Proposed Rate Revenue';
	by district;
	scatter x = pct_diff y = proposed_br_rev / group = meter_size;
	xaxis grid; yaxis grid;
run; 
quit;
ods pdf close;

*/


**Option 2 for graphical output**;

	**Scenario 1 Rates*;


ods pdf close;
ods pdf file = 'U:\a-tx-projects\34805\029\SAS\RCOMP\Rate Scenarios - 2019.1.27\Customer Bill Impacts - Scenario 1.pdf' startpage = no;
ods graphics on / reset = all width = 4.7in;
ods pdf columns = 2;

options orientation = landscape;

ods startpage = now;
proc sgplot data = s1  noborder;
	title 'Individual Customer Impacts - 5/8" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '5/8';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods startpage = now;
proc sgplot data = s1  noborder;
	title 'Individual Customer Impacts - 5/8+" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '5/8 +';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;


ods pdf startpage = now;
proc sgplot data = s1  noborder;
	title 'Individual Customer Impacts - 3/4" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '3/4';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s1  noborder;
	title 'Individual Customer Impacts - 1" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '1';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s1  noborder;
	title 'Individual Customer Impacts - 1 1/2" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '1 1/2';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s1  noborder;
	title 'Individual Customer Impacts - 2" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '2';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s1  noborder;
	title 'Individual Customer Impacts - 4" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '4';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s1  noborder;
	title 'Individual Customer Impacts - 6" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '6';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;





	**Scenario 2 Rates*;

ods pdf close;
ods pdf file = 'U:\a-tx-projects\34805\029\SAS\RCOMP\Rate Scenarios - 2019.1.27\Customer Bill Impacts - Scenario 2.pdf' startpage = no;
ods graphics on / reset = all width = 4.75in;
ods pdf columns = 2;

options orientation = landscape;

ods pdf startpage = now;
proc sgplot data = s2  noborder;
	title 'Individual Customer Impacts - 5/8" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '5/8';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s2  noborder;
	title 'Individual Customer Impacts - 5/8+" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '5/8 +';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s2  noborder;
	title 'Individual Customer Impacts - 3/4" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '3/4';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s2  noborder;
	title 'Individual Customer Impacts - 1" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '1';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s2  noborder;
	title 'Individual Customer Impacts - 1 1/2" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '1 1/2';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s2  noborder;
	title 'Individual Customer Impacts - 2" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '2';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s2  noborder;
	title 'Individual Customer Impacts - 4" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '4';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s2  noborder;
	title 'Individual Customer Impacts - 6" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '6';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;




ods pdf close;
ods pdf file = 'U:\a-tx-projects\34805\029\SAS\RCOMP\Rate Scenarios - 2019.1.27\Customer Bill Impacts - Scenario 3.pdf' startpage = no;
ods graphics on / reset = all width = 4.75in;
ods pdf columns = 2;

options orientation = landscape;

ods pdf startpage = now;
proc sgplot data = s3  noborder;
	title 'Individual Customer Impacts - 5/8" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '5/8';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s3  noborder;
	title 'Individual Customer Impacts - 5/8+" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '5/8 +';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s3  noborder;
	title 'Individual Customer Impacts - 3/4" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '3/4';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s3  noborder;
	title 'Individual Customer Impacts - 1" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '1';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s3  noborder;
	title 'Individual Customer Impacts - 1 1/2" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '1 1/2';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s3  noborder;
	title 'Individual Customer Impacts - 2" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '2';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s3  noborder;
	title 'Individual Customer Impacts - 4" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '4';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s3  noborder;
	title 'Individual Customer Impacts - 6" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '6';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;



ods pdf close;
ods pdf file = 'U:\a-tx-projects\34805\029\SAS\RCOMP\Rate Scenarios - 2019.1.27\Customer Bill Impacts - Scenario 4.pdf' startpage = no;
ods graphics on / reset = all width = 4.75in;
ods pdf columns = 2;

options orientation = landscape;

ods pdf startpage = now;
proc sgplot data = s4  noborder;
	title 'Individual Customer Impacts - 5/8" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '5/8';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s4  noborder;
	title 'Individual Customer Impacts - 5/8+" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '5/8 +';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s4  noborder;
	title 'Individual Customer Impacts - 3/4" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '3/4';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s4  noborder;
	title 'Individual Customer Impacts - 1" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '1';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s4  noborder;
	title 'Individual Customer Impacts - 1 1/2" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '1 1/2';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s4  noborder;
	title 'Individual Customer Impacts - 2" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '2';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s4  noborder;
	title 'Individual Customer Impacts - 4" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '4';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s4  noborder;
	title 'Individual Customer Impacts - 6" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '6';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;



ods pdf close;
ods pdf file = 'U:\a-tx-projects\34805\029\SAS\RCOMP\Rate Scenarios - 2019.1.27\Customer Bill Impacts - Scenario 5.pdf' startpage = no;
ods graphics on / reset = all width = 4.75in;
ods pdf columns = 2;

options orientation = landscape;

ods pdf startpage = now;
proc sgplot data = s5  noborder;
	title 'Individual Customer Impacts - 5/8" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '5/8';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s5  noborder;
	title 'Individual Customer Impacts - 5/8+" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '5/8 +';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s5  noborder;
	title 'Individual Customer Impacts - 3/4" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '3/4';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s5  noborder;
	title 'Individual Customer Impacts - 1" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '1';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s5  noborder;
	title 'Individual Customer Impacts - 1 1/2" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '1 1/2';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s5  noborder;
	title 'Individual Customer Impacts - 2" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '2';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s5  noborder;
	title 'Individual Customer Impacts - 4" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '4';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf startpage = now;
proc sgplot data = s5  noborder;
	title 'Individual Customer Impacts - 6" Meters';
	label pct_diff = 'Annual Percentage Impact' rev_diff = 'Annual Dollar Impact';
	where meter_size = '6';
	by district;
	scatter x = pct_diff y = rev_diff;
	xaxis grid; yaxis grid;
run;

ods pdf close;
