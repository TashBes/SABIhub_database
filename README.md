# SABIhub_database


Workflow to design and create an indicator database for the SABI project. 

The script **1_create_database.R** creates an empty Postgresql database. 
There is an option to create three databases, stage, clean and final. I have only created the final database 
for now, but we could have a workflow where we add the raw data to a staging database, use and R script to 
clean it and save the cleaned version in the clean database and then move the cleaned data into the final
database. 

The next script **2_make_tables.R** creates all the tables in the database. This creates the schema, 
and sets all the resctrictions and connections among the tables. Tables are called dims (for dimensions)
and the central table is called the fact table (following a traditional star schema model).

The final script **3_make_dim_date.R** creates a date table that all other tables that have date fields
will draw from. This is optional but I have found it very useful. 

All scripts use a package I created for when I made my other databases called createDB. I have put some
useful helper functions that I used often in it, but it is not yet as polished as the nbaR package, 
as it has been only for my internal use so far. To install the package please use 
**remotes::install_github("TashBes/createDB")**