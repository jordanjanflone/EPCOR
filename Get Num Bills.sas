libname conan 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Consumption Analysis\';

data temp;
  set conan.resraw;
run;

proc sort data = temp; by use; run;

data temp; set temp;
	if use <= 0 then use = 0;
	use2 = ceil(use);
run;

data temp2; set temp;
	by use;
		do i = 0 to 2604;
			if use2 = i then do;
				block = i;
			end;
		end;
run;

	
proc sort data = temp2; by district_id meter_size block; run;

proc summary data=temp2;
 by district_id meter_size block;
 var use;
 output out=temp3 n= numbills;
run;


proc sort data = temp3; by district_id block; run;
proc transpose data = temp3 out = temp4;
	id meter_size; 
	by district_id block;
	var numbills;
run;

data temp4; retain district_id block _5_8 _5_8__ _3_4 _1 _1_1_2 _2 _3 _4 _6; set temp4; run;

proc export data = temp4
	outfile = 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Consumption Analysis\Number of Bills - all blocks.xlsx'
	dbms = xlsx replace;
	sheet = 'SAS Output';
run;
