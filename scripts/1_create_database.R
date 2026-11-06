# ---
# title: "Creation of necessary databases"
# author: "Natasha Besseling/Jock Currie"
# date: "2023-04-26"
# ---

## load libraries
library(DBI)
library(RPostgres)


## connect to PostGres

if (Sys.info()["sysname"] == "Windows") {
  con <- dbConnect(RPostgres::Postgres(),
                 port = Sys.getenv("DB_PORT"),
                 user = Sys.getenv("DB_USER"),
                 password = Sys.getenv("DB_PASSWORD"))
} else {
  con <- dbConnect(
    drv = Postgres(), # dbDriver("PostgreSQL"),
    # dbname=Sys.getenv("DB_DATABASE"),
    host = Sys.getenv("DB_HOST"),
    port = Sys.getenv("DB_PORT"),
    user = Sys.getenv("DB_USER"),
    password = Sys.getenv("DB_PASSWORD"))
}


## create three databases: 1. occur_stage where the raw data will be stored
##                         2. occur_clean where the cleaned data will be stored
##                         3. occurrence_dwh where the final tables for our databse will be stored
##
## This should be done only once at the start

# try(dbSendQuery(con, "DROP DATABASE occur_stage")) # DELETE THE DATABASE
# dbSendQuery(con, "CREATE DATABASE occur_stage")
# 
# try(dbSendQuery(con, "DROP DATABASE occur_clean")) # DELETE THE DATABASE
# dbSendQuery(con, "CREATE DATABASE occur_clean")
#
try(dbSendQuery(con, "DROP DATABASE sabi_hub_dwh")) # DELETE THE DATABASE
dbSendQuery(con, "CREATE DATABASE sabi_hub_dwh")

## disconnect from the database
dbDisconnect(con)

## remove all objects
rm(list=setdiff(ls(), "run_scripts")) #

## consider unloading packages not needed again (or calling their functions without loading them in the first place)
try(detach("package:RPostgreSQL", unload=TRUE), silent = TRUE)
try(detach("package:RPostgres", unload=TRUE), silent = TRUE)
detach("package:DBI", unload=TRUE)

print("DATABASES CREATED")

