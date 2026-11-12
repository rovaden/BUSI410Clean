CMS 2008 BSA PDE PUF data file is split into five parts to optimize data handling and processing. 
Data files can be read in to SAS dataset and concatenated/appended using the BSA_PartD_Events_PUF_2008.sas program.

The files are named:
BSA_PartD_Events_PUF_2008_1.csv
BSA_PartD_Events_PUF_2008_2.csv
BSA_PartD_Events_PUF_2008_3.csv
BSA_PartD_Events_PUF_2008_4.csv
BSA_PartD_Events_PUF_2008_5.csv

The user should 
1) Run BSA_PartD_Events_PUF_2008.sas program five times for each of files (by uncommenting the necessary lines).
2) Formats and descriptions can be added to the individual files (by uncommenting the necessary lines). Please be advised that this step requires significant computational and storage resources.
3) Concatenate/append all five SAS files by uncommenting the necessary piece in the SAS program once individual files are created.

Please verify the total record count which can be found in the General Documentation for the PUF.

