
### Rules for naming things in the database and around
The name of database objects (tables, views, procedures, triggers, helping scripts) would in perfect way reflect
* is it a standard object or and customer specific object 
* what is its type (table, view etc.)
* what is its use (staging data, calculation, materialization,....) 
* is is something temporary, self rebuild or something permanent

For naming things, we use   
[usage].[type][object]
in sxdf. schema the object has a usage prefix (GET_, POST_, DATAOUTPUT_...) if it is public

List of typical strings, to name things  
* sp - stored procedure
* t - table
* v - view
* fn - function
* mqt - materialized query
* tr - trigger
* script - SQL Script (for manual execution)

Rules
* use the schema to exlain the use of things
    * sxdf.* for system objects DataFactory (tables, views, sp, fn)
    * staging.* for staging source data in raw format (same dataformat, null values possible) or adjusting this
    * load.* fixed schema, for data prepared for loading, already in datafactory consistency (correct types, scaled, no null values) 
    * import.* for import processes, which writes to final destination tables (sxdf.*, param.*)
    * calc.* for internal calculation 
    * param.* for parameter and mapping tables (maybe materialized Products)
    * control.* for controlling and monitoring objects
    * result.* for objects, which deliver results to customer


### Rules for issues
Create small issues, it should be possible to close a issues with one commit


