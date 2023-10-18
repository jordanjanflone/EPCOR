libname epcor 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\';
libname conan 'U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Consumption Analysis\';

/*
%macro fls(dir, fname, dbname);

libname t &dir;

data &dbname;
  set t.&fname;
  keep district_id rate type meter_size premise_id utility_usage month;
run;

%mend;

%fls("U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Agua Fria\", base_rate_af, t1);
%fls("U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Anthem\", base_rate_atm, t2);
%fls("U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Chaparral\", base_rate_cp, t3);
%fls("U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Havasu\", base_rate_hv, t4);
%fls("U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Mohave\", base_rate_mh, t5);
%fls("U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Mohave North\", base_rate_nmh, t6);
%fls("U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Paradise Valley\", base_rate_pv, t7);
%fls("U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Sun City\", base_rate_sc, t8);
%fls("U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Sun City West\", base_rate_scw, t9);
%fls("U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Tubac\", base_rate_tb, t10);
%fls("U:\a-tx-projects\34805\029\SAS\Proof of Revenue\Willow Valley\", base_rate_wv, t11);


data t11;
  set t11;
  utility_usage = utility_usage/1000;
run;
*/

data conan.resraw;
  set t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11;
  use = utility_usage;
  drop utility_usage;
run;
