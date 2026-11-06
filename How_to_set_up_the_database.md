# Project folders

  
- data (All raw data files)

- outputs (spatial and csv output files)

- plots (exploratory data plots/ graphs)

- renv (all locally installed packages)

- rscripts (all scripts used to make and analyse the occurrence database)


# Database creation

To make the database you should just run the SetUpDatabase_master.R script, that sources all scripts in the correct order. If you run into issues with this script or want to run the scripts individually follow the below order:
  
 - install_packages (all packages used in the database)
 - create_database (creating the empty sql databases)
 - make_tables (make tables for the final database)
 - make_dim_date (making the date table)
 - extract_ scripts in any order (extract raw data and place in staging database)
 - clean_ scripts in the numbered order (clean data and place in clean database)
 - make scripts in the numbered order(put data into the final database)
 - add_demersPelagic_field (adding habitat classification to records)
 - IUCN_list (adding IUCN category to records)
 
 To analyse the outputs you can run:
 - data_extract (extract data from database)
 - explore_occurrence_datasets

Scripts that are no longer used are stored in obsolete (obsolete scripts) and scripts for functions that were eventually added to the createDB package are stored in the functions folder. 
 


# To add datasets to the database

## Extract

1. Extract each dataset to be used into r and write it as a table/ tables into the staging database using the scripts with the prefix extract_

2. If you are making a new script please prefix it with extract followed by a clear name for the database. Place all tables from the original database as is into the staging  database with the original names if possible, with the abbreviation of the dataset attached the table name as a prefix (and always use only lower case when working with postgresql).

example:

Database = Demersal Inshore Trawl

Table = dit_catch

script = extract_DIT


## Clean

1. Extract the tables from the staging database and clean any errors that are found.
Errors could be misspellings, incorrect values or random characters.
Please use the clean_names function to clean the species names.
The columns that must all have data are the longs and lats, and taxa names.
If there are no longs or lats please add them and add a radius of uncertainty column, otherwise remove the record.
If the species name is missing remove the record (or if the species name is ambiguous eg redfish)

2. Fix any formatting issues between the tables and the final database format.
L:ongs and lats must be in decimal form,
dates must be in year/month/day (no times)

3. Name the scripts with the prefix clean_

- Name any script with the prefix clean_ plus the database abreviation.
Name all the tables the data abreviation plus the table name plus clean

example:

Database = Demersal Inshore Trawl

Table = dit_catch_clean

script = clean_DIT

## Make the final database

1. Create the project, expedition, station, location, taxon and catch/sample table from the tables in the clean database.
3. Name the scripts with the prefix make_

- Follow the formatting of the other datasets within the make scripts to align the new dataset to the correct formatting.

# To restore the database from a backup 

make an empty sql database with the name you want the backup to take

Go to the comand line and change the directory to the postgreaql bin using this command: cd C:\Program Files\PostgreSQL\16\bin (you may have to change the 16 depening on your version of postgres)

Then paste in this command: psql -h localhost -U postgres -p 5433 -d  occurrence_dwh_2024_12_06 -f C:\Users\N.Besseling\Documents\postgreSQL_backups\backup-occurrence_dwh-202412061125.sql

You will need to change the port number (-p 5433) to your port number, the name of the sql database you want to write it to, and the folder path where you are storing your backup, e.g.

psql -h localhost -U postgres -p YOUR_PORT_NUMBER -d  DATABASE_NAME -f PATH_TO_BACKUP_FILE\BACKUP_FILE_NAME


 
