# ---
# title: "Creation of tables in the occurrence_dwh database"
# author: "Natasha Besseling/Jock Currie"
# date: "2023-04-26"
# ---

##load libraries

library(DBI)
if (Sys.info()["sysname"] != "Windows") # load the appropriate packages depending on OS and approach; Windows seems to work with RPostgres but not with RPostgreSQL? and vice versa. this may need some further investigation
        library(RPostgreSQL) else
                library(RPostgres)
# library(RPostgres)
library(tidyverse)
library(createDB)

## connect to the occurrence_dwh database

con <- sql_con("sabi_hub_dwh")


## This database uses a star schema model. Therefore it consists of a fact table,
## which acts as the primary table for the schema. A fact table contains the primary measurements,
## metrics, or ‘facts’ the database, and many dimension tables associated
## with the fact table. Each dimension table contains ‘dimensions’ — that is,
## descriptive attributes of the fact table.
##
## to create the tables you need to use the create table sql command, followed by the tables
## name and a list of each field name and field data type. The first field should always
## be the primary key and will be automatically generated when adding data to the table.
## normally varchar is used for character data with the expected max number of characters
## in brackets. If you expect the field data to be unique you can add the function unique
## to it to ensure there will be no duplicates.
## Once the table has been created add the first row using -1 for primary key fields,
## unknown for any character fields, 0 for any numeric fields and '1800/01/01'::date
## for any date fields.
## if a field name is also a sql command use \"order\" to name it.
## for the final fact table you need to add a command to link the forign keys
## to the primary keys of their repective tables

##create date table
##---------------------------------------------------------------------------

try(dbSendQuery(con, "drop table dim_date cascade")) # this failes with error if the table does not exist; hence put it in try()

dbSendQuery(con, "create table dim_date (
pk_date_id
serial primary key,
date_full_date
date,
date_name
varchar (10),
date_day_Of_week_number
integer,
date_day_Of_week_name
varchar (10),
date_day_Of_month_number
integer,
date_day_Of_year_number
integer,
date_is_weekend
varchar (10),
date_week_Of_year_number
int,
date_month_name
varchar (10),
date_month_number
int,
date_last_day_Of_month
varchar (10),
date_calendar_quarter_number
int,
date_calendar_year_number
int,
date_calendar_year_season_name
varchar (10))")

##add first row
dbSendQuery(con, "INSERT INTO dim_date
VALUES (-1,'1800/01/01'::date, 'unknown',0, 'unknown', 0, 0,
           'unknown', 0, 'unknown', 0, 'unknown',0,0, 'unknown')")
##-------------------------------------------------------------------------


##create indicator methodology table
##-----------------------------------------------------------------
try(dbSendQuery(con, "drop table dim_indicator_method cascade ")) # this fails with error if the table does not exist; hence put it in try()

dbSendQuery(con, "CREATE TABLE dim_ind_method (
pk_ind_method_id
serial PRIMARY KEY,
scope
varchar (2000000) UNIQUE,
methodoloy
varchar (2000000),
methodology_reference
varchar (2000000),
doi
varchar (2000000),
indicator_type
varchar (2000000))")

##add first row
dbSendQuery(con, "INSERT INTO dim_ind_method
VALUES (-1, 'unknown', 'unknown', 'unknown','unknown',
            'unknown')")
##---------------------------------------------------------------------

##create indicator value
##---------------------------------------------------------------------
try(dbSendQuery(con, "drop table dim_ind_value cascade ")) # this fails with error if the table does not exist; hence put it in try()

dbSendQuery(con, "CREATE TABLE dim_ind_value (
pk_ind_value_id
serial PRIMARY KEY,
min_value
integer,
min_value_interpretation
varchar (2000000),
max_value
integer,
max_value_interpretation
varchar (2000000),
range
integer,
unit_of_measure
varchar (2000000))")

##add first row
dbSendQuery(con, "INSERT INTO dim_ind_value
VALUES (-1, 0, 'unknown', 0, 'unknown',
            0, 'unknown')")
##-------------------------------------------------------------------------

##create indicator literature table
##-------------------------------------------------------------------------

try(dbSendQuery(con, "drop table dim_ind_literature cascade ")) # this fails with error if the table does not exist; hence put it in try()

dbSendQuery(con, "CREATE TABLE dim_ind_literature (
pk_ind_literature_id
serial PRIMARY KEY,
doi
varchar (2000) UNIQUE,
refernce_text
varchar (200000),
reference_category
varchar (200000))")

##add first row
dbSendQuery(con, "INSERT INTO dim_ind_literature
VALUES (-1, 'unknown', 'unknown',
            'unknown')")
##---------------------------------------------------------------------------



##create indicator custodian table
##-------------------------------------------------------------------------
try(dbSendQuery(con, "drop table dim_ind_custodian cascade")) # this failes with error if the table does not exist; hence put it in try()

dbSendQuery(con, "CREATE TABLE dim_ind_custodian (
pk_ind_custodian_id
serial PRIMARY KEY,
custodian_name
varchar (100),
custodian_institute
varchar (100),
custodian_email
varchar (100) )")

##add first row
dbSendQuery(con, "INSERT INTO dim_ind_custodian
VALUES (-1, 'unknown','unknown', 'unknown')")
##---------------------------------------------------------------------------


##create indicator_data
##---------------------------------------------------------------------------

try(dbSendQuery(con, "drop table dim_ind_data cascade")) # this failes with error if the table does not exist; hence put it in try()

dbSendQuery(con, "create table dim_ind_data (
pk_ind_data_id
serial primary key,
fk_date_id
int,
indicator_value
integer,
indicator_value_min_error
integer,
indicator_value_max_error
integer,
indicator_value_interpretation
varchar (200000),
data_link
varchar (200000),
git_link
varchar (200000),
technical_report_link
varchar (200000),
fk_ind_custodian_id
int, 
            CONSTRAINT fk_ind_custodian_id FOREIGN KEY(fk_ind_custodian_id)
        REFERENCES dim_ind_custodian(pk_ind_custodian_id),
            CONSTRAINT fk_date_id FOREIGN KEY(fk_date_id)
        REFERENCES dim_date(pk_date_id))")

##add first row
dbSendQuery(con, "INSERT INTO dim_ind_data
VALUES (-1,-1, 0,0, 0, 'unknown',
           'unknown', 'unknown',  'unknown', -1)")
##-------------------------------------------------------------------------


##create agreement table
##---------------------------------------------------------------------------
try(dbSendQuery(con, "drop table dim_agreement cascade")) # this fails with error if the table does not exist; hence put it in try()

dbSendQuery(con, "CREATE TABLE dim_agreement (
pk_agreement_id
serial PRIMARY KEY,
agreement
varchar(200000),
abbreviation
varchar(50))")

##add first row
dbSendQuery(con, "INSERT INTO dim_agreement
VALUES (-1, 'unknown','unknown')")
##--------------------------------------------------------------------------

##create cbd_gaol table
##---------------------------------------------------------------------------
try(dbSendQuery(con, "drop table dim_cbd_goal cascade")) # this fails with error if the table does not exist; hence put it in try()

dbSendQuery(con, "CREATE TABLE dim_cbd_goal (
pk_cbd_goal_id
serial PRIMARY KEY,
fk_agreement_id
int,
goal_targte
varchar(200000),
target_description
varchar(200000),
target_source
varchar(200000),
fk_date_id
int, 
            CONSTRAINT fk_agreement_id FOREIGN KEY(fk_agreement_id)
        REFERENCES dim_agreement(pk_agreement_id),
            CONSTRAINT fk_date_id FOREIGN KEY(fk_date_id)
        REFERENCES dim_date(pk_date_id))")

##add first row
dbSendQuery(con, "INSERT INTO dim_cbd_goal
VALUES (-1, -1, 'unknown','unknown','unknown', -1)")
##--------------------------------------------------------------------------

##create cms_gaol table
##---------------------------------------------------------------------------
try(dbSendQuery(con, "drop table dim_cms_goal cascade")) # this fails with error if the table does not exist; hence put it in try()

dbSendQuery(con, "CREATE TABLE dim_cms_goal (
pk_cms_goal_id
serial PRIMARY KEY,
fk_agreement_id
int,
goal_targte
varchar(200000),
target_description
varchar(200000),
target_source
varchar(200000),
fk_date_id
int, 
            CONSTRAINT fk_agreement_id FOREIGN KEY(fk_agreement_id)
        REFERENCES dim_agreement(pk_agreement_id),
            CONSTRAINT fk_date_id FOREIGN KEY(fk_date_id)
        REFERENCES dim_date(pk_date_id))")

##add first row
dbSendQuery(con, "INSERT INTO dim_cms_goal
VALUES (-1, -1, 'unknown','unknown','unknown', -1)")
##--------------------------------------------------------------------------

##create cites_goal table
##---------------------------------------------------------------------------
try(dbSendQuery(con, "drop table dim_cites_goal cascade")) # this fails with error if the table does not exist; hence put it in try()

dbSendQuery(con, "CREATE TABLE dim_cites_goal (
pk_cites_goal_id
serial PRIMARY KEY,
fk_agreement_id
int,
goal_targte
varchar(200000),
target_description
varchar(200000),
target_source
varchar(200000),
fk_date_id
int, 
            CONSTRAINT fk_agreement_id FOREIGN KEY(fk_agreement_id)
        REFERENCES dim_agreement(pk_agreement_id),
            CONSTRAINT fk_date_id FOREIGN KEY(fk_date_id)
        REFERENCES dim_date(pk_date_id))")

##add first row
dbSendQuery(con, "INSERT INTO dim_cites_goal
VALUES (-1, -1, 'unknown','unknown','unknown', -1)")
##--------------------------------------------------------------------------

##create sdg_goal table
##---------------------------------------------------------------------------
try(dbSendQuery(con, "drop table dim_sdg_goal cascade")) # this fails with error if the table does not exist; hence put it in try()

dbSendQuery(con, "CREATE TABLE dim_sdg_goal (
pk_sdg_goal_id
serial PRIMARY KEY,
fk_agreement_id
int,
goal_targte
varchar(200000),
target_description
varchar(200000),
target_source
varchar(200000),
fk_date_id
int, 
            CONSTRAINT fk_agreement_id FOREIGN KEY(fk_agreement_id)
        REFERENCES dim_agreement(pk_agreement_id),
            CONSTRAINT fk_date_id FOREIGN KEY(fk_date_id)
        REFERENCES dim_date(pk_date_id))")

##add first row
dbSendQuery(con, "INSERT INTO dim_sdg_goal
VALUES (-1, -1, 'unknown','unknown','unknown', -1)")
##--------------------------------------------------------------------------

##create ramsar_goal table
##---------------------------------------------------------------------------
try(dbSendQuery(con, "drop table dim_ramsar_goal cascade")) # this fails with error if the table does not exist; hence put it in try()

dbSendQuery(con, "CREATE TABLE dim_ramsar_goal (
pk_ramsar_goal_id
serial PRIMARY KEY,
fk_agreement_id
int,
goal_targte
varchar(200000),
target_description
varchar(200000),
target_source
varchar(200000),
fk_date_id
int, 
            CONSTRAINT fk_agreement_id FOREIGN KEY(fk_agreement_id)
        REFERENCES dim_agreement(pk_agreement_id),
            CONSTRAINT fk_date_id FOREIGN KEY(fk_date_id)
        REFERENCES dim_date(pk_date_id))")

##add first row
dbSendQuery(con, "INSERT INTO dim_ramsar_goal
VALUES (-1, -1, 'unknown','unknown','unknown', -1)")
##--------------------------------------------------------------------------



##create indicator table
##--------------------------------------------------------------------------

try(dbSendQuery(con, "drop table fact_ind cascade")) # this fails with error if the table does not exist; hence put it in try()

dbSendQuery(con, "CREATE TABLE fact_ind (
pk_ind_id
serial PRIMARY KEY,
name
varchar (200000),
description
varchar (200000),
fk_ind_literature_id
int,
fk_ind_data_id
int,
fk_ind_method_id
int,
fk_ind_value_id
int,
fk_cbd_goal_id
int,
fk_cms_goal_id
int,
fk_cites_goal_id
int,
fk_sdg_goal_id
int,
fk_ramsar_goal_id
int,

            CONSTRAINT fk_ind_literature_id FOREIGN KEY(fk_ind_literature_id)
        REFERENCES dim_ind_literature(pk_ind_literature_id),
        
            CONSTRAINT fk_ind_data_id FOREIGN KEY(fk_ind_data_id)
        REFERENCES dim_ind_data(pk_ind_data_id),
        
            CONSTRAINT fk_ind_method_id FOREIGN KEY(fk_ind_method_id)
        REFERENCES dim_ind_method(pk_ind_method_id),
        
            CONSTRAINT fk_ind_value_id FOREIGN KEY(fk_ind_value_id)
        REFERENCES dim_ind_value(pk_ind_value_id),
        
            CONSTRAINT fk_cbd_goal_id FOREIGN KEY(fk_cbd_goal_id)
        REFERENCES dim_cbd_goal(pk_cbd_goal_id),
        
            CONSTRAINT fk_cms_goal_id FOREIGN KEY(fk_cms_goal_id)
        REFERENCES dim_cms_goal(pk_cms_goal_id),
        
            CONSTRAINT fk_cites_goal_id FOREIGN KEY(fk_cites_goal_id)
        REFERENCES dim_cites_goal(pk_cites_goal_id),
        
            CONSTRAINT fk_sdg_goal_id FOREIGN KEY(fk_sdg_goal_id)
        REFERENCES dim_sdg_goal(pk_sdg_goal_id),
        
            CONSTRAINT fk_ramsar_goal_id FOREIGN KEY(fk_ramsar_goal_id)
        REFERENCES dim_ramsar_goal(pk_ramsar_goal_id))")

##add first row
dbSendQuery(con, "INSERT INTO fact_ind
VALUES (-1, 'unknown','unknown', -1, -1, -1, 
            -1, -1, -1, -1, -1, -1)")
##----------------------------------------------------------------------------
dbDisconnect(con)

rm(list=setdiff(ls(), "run_scripts")) #

print("TABLES MADE")

