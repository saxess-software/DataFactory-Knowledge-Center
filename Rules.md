
### Rules for naming things in the database and around
The name of database objects (tables, views, procedures, triggers, helping scripts) would in perfect way reflect
* is it a standard object or and customer specific object 
* what is its type (table, view etc.)
* what is its use (staging data, calculation, materialization,....) 
* is is something temporary, self rebuild or something permanent



For naming things, we use   
[usage].[type][object]
in sxdf. / sudf. schema the object has a usage prefix (GET_, POST_, DATAOUTPUT_...)


List of typical strings, to name things  
* sp - stored procedure
* t - table
* v - view
* fn - function
* mqt - materialized query
* tr - trigger

Rules
* use the schema to exlain the use of things
    * sxdf.* for system objects DataFactory
    * staging.* for staging
    * sudf.* for solution
    * calc.* for internal calculation 
    * result.* for views, which deliver results to customer
    * tmp.* for temporary data
    * import.* for import process
 

