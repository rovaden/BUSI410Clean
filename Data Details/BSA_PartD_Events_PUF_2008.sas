
/*********************************************************************************\

PROGRAM:      		BSA_PartD_Events_PUF_2008.sas

DESCRIPTION:  		To read csv format Part D PUF to SAS dataset
 	
INPUT FILES:   		BSA_PartD_Events_PUF_2008.csv

OUTPUT FILES:       BSA_PartD_Events_PUF_2008.sas7bdat

OTHER OUTPUT:		Contents, proc print and freq distribution

                       
\*********************************************************************************/
              
FOOTNOTE 'BSA_PartD_Events_PUF_2008.sas';
* Log/List Options *;
options ls=120 ps=42 missing=' ' nocenter validvarname=upcase compress=binary;

/*Run the code for each file below by uncommenting one by one*/
%let BSA_PUF_FILE =BSA_PartD_Events_PUF_2008_1;
*%let BSA_PUF_FILE =BSA_PartD_Events_PUF_2008_2;
*%let BSA_PUF_FILE =BSA_PartD_Events_PUF_2008_3;
*%let BSA_PUF_FILE =BSA_PartD_Events_PUF_2008_4;
*%let BSA_PUF_FILE =BSA_PartD_Events_PUF_2008_5;
 
* Input File Reference *;
%let in1= INSERT_INPUT_DIRECTORY_NAME;*Place  File Path where csv files are downloaded ; 

filename in_file "&in1.\&BSA_PUF_FILE..csv" ;  * <-- Place Input File Path Here *;

* Output SAS Library *;
libname PUF 'INSERT_OUPUT_DIRECTORY_NAME'; * <-- Place Output Library Path Here *;

 

*Formats Code : Uncomment the following if want to include formats *;


/*
Proc format;

Value SEXF
	1 = 'MALE '
	2 = 'FEMALE'
;

Value AGEF
	1	= 'Under  65 '
	2	= '65 - 69 '
	3	= '70 - 74 '
	4	= '75 - 79 '
	5	= '80 - 84 '
	6	= '85 & Older'

;

Value DAYS_SUPLYF
	1 =  '1-7 days'
	2 =  '8-14 days'
	3 =  '15-21 days'
	4 =  '22-29 days'
	5 =  '30-59 days'
	6 =  '60-89 days'
	7 =  '90 or more days'
;

Value PTNT_PAYF
	1 =  'Patient did not pay any amount'
	2 =  'Patient paid an amount greater than $0 but less than the total drug cost'
	3 =  'Patient paid the total drug cost'
	

;

Value PDE_DRUG_TYPEF
	0 =  'Unknown\Missing'
	1 =  'Brand Name'
	2 =  'Generic Name'
		

;

run;  
*/


data  PUF.&BSA_PUF_FILE(label='BSA PART D PUBLIC USE FILE');
infile in_file dlm=','   dsd missover truncover firstobs=2 ;

* Input Record *;
input 	PDE_EVENT_ID	 						   :$20.	
       	BENE_SEX_IDENT_CD
		BENE_AGE_CAT_CD 
       	PDE_DRUG_CD 
		PDE_DRUG_STR_CD
		PDE_DRUG_STR_UNITS_CD
		PDE_DRUG_DOSE_CD
		PDE_DRUG_CLASS_CD
		PDE_DRUG_QTY_DIS
		PDE_DRUG_DAY_SPLY_CD 
		PDE_DRUG_COST 
		PDE_DRUG_PAT_PAY_CD 
		PDE_DRUG_TYPE_CD
  ;

 
  * Formats *;
 
*** Uncomment following to apply formats ;	

/*
BENE_SEX_IDENT=	BENE_SEX_IDENT_CD;
BENE_AGE_CAT=BENE_AGE_CAT_CD;
PDE_DRUG_DAY_SPLY=PDE_DRUG_DAY_SPLY_CD;
PDE_DRUG_PAT_PAY=PDE_DRUG_PAT_PAY_CD;
PDE_DRUG_TYPE=PDE_DRUG_TYPE_CD;

format  
	BENE_SEX_IDENT                    SEXF.
    BENE_AGE_CAT					  AGEF.
    PDE_DRUG_DAY_SPLY			      DAYS_SUPLYF.
	PDE_DRUG_PAT_PAY				  PTNT_PAYF.
	PDE_DRUG_TYPE				      PDE_DRUG_TYPEF.
;	

  
label		
	BENE_SEX_IDENT              = "Beneficiary gender"
   	BENE_AGE_CAT				= "Beneficiary Age category"		   
   	PDE_DRUG_DAY_SPLY			= "PartD Drug Days Supply"
    PDE_DRUG_PAT_PAY			= "PartD Patient Pay "	       
	PDE_DRUG_TYPE				= "PartD Drug Type "  
;
         
*/
 
  * Labels *;


  label 		PDE_EVENT_ID				= "PARTD Cryptographic event ID "
				BENE_SEX_IDENT_CD   		= "Beneficiary gender code"
				BENE_AGE_CAT_CD  			= "Beneficiary Age category code "
       			PDE_DRUG_CD  				= "Rxnorm Drug name category code"
				PDE_DRUG_STR_CD				= "Rxnorm Drug Strength Code"
				PDE_DRUG_STR_UNITS_CD 		= "Rxnorm Drug Strength Units code"
				PDE_DRUG_DOSE_CD 			= "NDF Drug Class Code"
				PDE_DRUG_CLASS_CD 			= "Rxnorm Drug Doseform Code"
				PDE_DRUG_QTY_DIS 			= "Rxnorm Drug Quantity Dispensed"
				PDE_DRUG_DAY_SPLY_CD  		= "PartD Drug Days Supply Code"
				PDE_DRUG_COST  				= "PartD Drug Cost"
				PDE_DRUG_PAT_PAY_CD  		= "PartD Patient Pay Code"
				PDE_DRUG_TYPE_CD 			= "PartD Drug Type Code"
 
             
	;
  
  
run;
/* Use this code if you need descriptions for the codes for Drug Name,Drug Doseform, Drug Strength,Drug Strength Units,
Drug Class */

/*
data  drug_name;
infile "&in1.\DRUG_NAME_TABLE.csv" dsd  missover truncover firstobs=2;
input  PDE_DRUG_CD  RXNORM_GENERIC_NAME :$1500.;
run;

data  drug_doseform_name;
infile "&in1.\DRUG_DOSEFORM_TABLE.csv" dsd  missover truncover firstobs=2;
input  PDE_DRUG_DOSE_CD  RXNORM_DOSE_FORM :$1500.;
run;

data  drug_strength_name;
infile "&in1.\DRUG_STRENGTH_TABLE.csv" dsd  missover truncover firstobs=2;
input  PDE_DRUG_STR_CD  RXNORM_STRENGTH :$1500.;
run;

data  drug_strength_units_name;	
infile "&in1.\DRUG_STRENGTH_UNITS_TABLE.csv" dsd  missover truncover firstobs=2;
input  PDE_DRUG_STR_UNITS_CD  RXNORM_STRENGTH_UNITS :$1500.;
run;

data  drug_class_name;
infile "&in1.\DRUG_CLASS_TABLE.csv" dsd  missover truncover firstobs=2;
input  PDE_DRUG_CLASS_CD  NDF_VA_MAJOR_CLASS :$1500.;
run;


Proc SQL;
Create Table  PUF.&BSA_PUF_FILE as select  a.*, b.RXNORM_GENERIC_NAME,c.RXNORM_DOSE_FORM
,d.RXNORM_STRENGTH,e.RXNORM_STRENGTH_UNITS,F.NDF_VA_MAJOR_CLASS from PUF.&BSA_PUF_FILE as a left join Drug_name as b 
on  a.PDE_DRUG_CD = b.PDE_DRUG_CD	left join  Drug_Doseform_name as c on a.PDE_DRUG_DOSE_CD=c.PDE_DRUG_DOSE_CD 
left join Drug_Strength_name as d on a.PDE_DRUG_STR_CD = d.PDE_DRUG_STR_CD left join Drug_Strength_Units_name as e on a.PDE_DRUG_STR_UNITS_CD=e.PDE_DRUG_STR_UNITS_CD
left join Drug_Class_name as f on a.PDE_DRUG_CLASS_CD =f.PDE_DRUG_CLASS_CD;
Quit;

data  PUF.&BSA_PUF_FILE;
retain 	PDE_EVENT_ID  BENE_SEX_IDENT_CD BENE_SEX_IDENT  BENE_AGE_CAT_CD	BENE_AGE_CAT PDE_DRUG_CD  RXNORM_GENERIC_NAME
PDE_DRUG_STR_CD	RXNORM_STRENGTH  PDE_DRUG_STR_UNITS_CD RXNORM_STRENGTH_UNITS PDE_DRUG_CLASS_CD  NDF_VA_MAJOR_CLASS 
PDE_DRUG_DOSE_CD 	RXNORM_DOSE_FORM PDE_DRUG_QTY_DIS  PDE_DRUG_DAY_SPLY_CD PDE_DRUG_DAY_SPLY PDE_DRUG_PAT_PAY_CD 
PDE_DRUG_PAT_PAY PDE_DRUG_COST PDE_DRUG_TYPE_CD PDE_DRUG_TYPE ;

set PUF.&BSA_PUF_FILE;
run;

Proc sort data=&PUF.BSA_PUF_FILE;
by PDE_EVENT_ID;
run;

*/

 
title 'PARTD EVENTS PUBLIC USE FILE';
proc contents data=PUF.&BSA_PUF_FILE varnum;
proc print data=PUF.&BSA_PUF_FILE (obs=10);
  title2 'Sample Listing - 10 Rows';
run;


proc freq data=PUF.&BSA_PUF_FILE;
  title2 'Freqs';

  table BENE_SEX_IDENT_CD
		BENE_AGE_CAT_CD 
       	PDE_DRUG_CD 
		PDE_DRUG_STR_CD
		PDE_DRUG_STR_UNITS_CD
		PDE_DRUG_DOSE_CD
		PDE_DRUG_CLASS_CD
		PDE_DRUG_QTY_DIS
		PDE_DRUG_DAY_SPLY_CD 
		PDE_DRUG_COST 
		PDE_DRUG_PAT_PAY_CD 
		PDE_DRUG_TYPE_CD /missing;
run;
/* After preparing all five files, use this code to append them together */
 
/*
data puf.BSA_PartD_Events_PUF_2008;
set puf.BSA_PartD_Events_PUF_2008_1 
puf.BSA_PartD_Events_PUF_2008_2
puf.BSA_PartD_Events_PUF_2008_3 
puf.BSA_PartD_Events_PUF_2008_4
puf.BSA_PartD_Events_PUF_2008_5;
run;
*/


* End of Program *;
