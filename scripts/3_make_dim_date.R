# ---
# title: "Creation of the date table in the occurrence_dwh database"
# author: "Natasha Besseling/Jock Currie"
# date: "2023-04-26"
# ---

##load libraries
library(createDB)
library(DBI)
#devtools::install_github("TashBes/createDB")

## To make the data table instead of adding dates from the data we will
## create a table with every date over a date range that our data is
## expected to cover. This may need to be extended as this work extends passed
## 2025, but extra rows can be added easily enough.
## It is easier to make the table in R so that we can use the lubridate functions


dim_date <- createDB::make_dim_date()



################################################################################

## connect to the occurrence_dwh and populate the dim_date table
## with the r dataframe just created

con <- sql_con("sabi_hub_dwh")


DBI::dbWriteTable(con, "dim_date", dim_date, row.names=FALSE, append=TRUE)

DBI::dbDisconnect(con)

rm(list=setdiff(ls(), "run_scripts")) #

print("DATE TABLE MADE")


################################################################################
### to add more dates
# con <- sql_con("occurrence_dwh")
#
#
# dim_date<-DBI::dbReadTable(con, "dim_date")
#
# add_date <- dim_date %>%
#   select(date_calendar_year_number) %>%
#   distinct()
#
# add_date <- dim_date %>%
#   select(date_calendar_year_number, date_month_number) %>%
#   distinct()%>%
#   bind_rows(add_date) %>%
#   filter(date_calendar_year_number !=0)
#
# DBI::dbWriteTable(con, "add_date", add_date, row.names=FALSE, append=TRUE)
#
#
# # Return column names and variable class
# desiredCols <- DBI::dbGetQuery(con, "SELECT column_name
#                                               FROM   information_schema.columns
#                                               WHERE  table_name = 'dim_date'
#                                               ORDER  BY ordinal_position")
#
# tableColumns <- DBI::dbGetQuery(con, "SELECT column_name
#                                               FROM   information_schema.columns
#                                               WHERE  table_name = 'add_date'
#                                               ORDER  BY ordinal_position")
#
#
#
# # Determine missing columns
# colDiffs <- as.list(setdiff(desiredCols, tableColumns))[["column_name"]]
#
# # add missing cols to the data
#
# add_date[colDiffs] <- NA
#
#
# add_date<-add_date[names
#                    (pivot_wider
#                      (mutate(desiredCols, value = NA),
#                        names_from = column_name))] %>%
#   select(-pk_date_id)
#
# DBI::dbSendQuery(con, "drop table add_date cascade")
# DBI::dbSendQuery(con, "create table add_date (
# date_full_date
# date,
# date_name
# varchar (10),
# date_day_Of_week_number
# integer,
# date_day_Of_week_name
# varchar (10),
# date_day_Of_month_number
# integer,
# date_day_Of_year_number
# integer,
# date_weekday_weekend
# varchar (10),
# date_week_Of_year_number
# int,
# date_month_name
# varchar (10),
# date_month_number
# int,
# date_last_day_Of_month_indicator
# varchar (10),
# date_calendar_quarter_number
# int,
# date_calendar_year_number
# int,
# date_calendar_year_season_name
# varchar (10))")
#
# DBI::dbWriteTable(con, "add_date", add_date, row.names=FALSE, append=TRUE)
#
#
# ## add to dim date
# DBI::dbSendQuery(con, "INSERT INTO dim_date (date_full_date,
# date_name,
# date_day_Of_week_number,
# date_day_Of_week_name,
# date_day_Of_month_number,
# date_day_Of_year_number,
# date_weekday_weekend,
# date_week_Of_year_number,
# date_month_name,
# date_month_number,
# date_last_day_Of_month_indicator,
# date_calendar_quarter_number,
# date_calendar_year_number,
# date_calendar_year_season_name)
#                              SELECT *
#                              FROM add_date;")
#
#
#
#
# # Close out the database connection
# DBI::dbDisconnect(con)


################################################################################
## to delete dates

# con <- sql_con("occurrence_dwh")
#
#
# DBI::dbSendQuery(con, "DELETE FROM dim_date WHERE pk_date_id BETWEEN 1 AND 136;")
#
#
# DBI::dbDisconnect(con)
#
#






