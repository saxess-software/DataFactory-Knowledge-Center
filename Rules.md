
### Rules for naming things in the database and around
The name of database objects (tables, views, procedures, triggers, helping scripts) would in perfect way reflect
* is it a standard object or and customer specific object 
* what is its type (table, view etc.)
* what is its use (staging data, calculation, materialization,....) 
* is is something temporary, self rebuild or something permanent

We must know this fast to:  
* transport all custom things fast to a new database in case of updates / rollouts
* create reports about all custom things in the database

For naming things, we can use   
* the schema 
* a prefix on object name
* a suffix on object name
* the description fields inside an object

List of typical strings, to name things  
* c - custom
* st or stage - staging (temporary saved source data
* p or sp - stored procedure
* t - table
* v - view
* fn - function
* qry - query

Rules (work in progress)  
* use the schema to exlain the use and type of things
    * stating_t.* for staging tables
    * staging_v.* for staging view
    * calc_v.* for internal calculation view
    * calc_sp.* for internal calcuation stored procedures
    * calc_mqt.* for internal calculated tables (materialized query table)
    * result_v.* for views, which deliver results to customer
    * result_t.* for tables, which deliver results to customer
    * result_sp.* for calculations, which deliver results to customer
