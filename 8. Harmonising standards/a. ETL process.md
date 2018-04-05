# Schemas
## Staging
staging.t* &
staging.sp*
* Harmonising of clients
* Convert IDs in usable IDs for DF
* NULL elimination
* Adaption of collation to DF collation
* Data types
* Selection of relevant rows and columns
* Handling staging errors
  * Access denied
  * Timeout
  * Wrong or inconsistent data

## Load
load.t* &
load.sp*
* Fixed set of tables, parameterisation of load process
* Starting point for blocker in case of row error (comparison of existing data in table and new data to be loaded into the table)
* Reduction of cursors

## Import
import.sp* &
dbo.sx_pf_*
* Fixed set of procedures to import data into the dimension and facts tables

## Calc
* Calculation objects (all kind of objects with schema calc. are possible)

## Param
param.v*, param.mqt*
* Usually Views or tables to integrate parameters or auxiliary values from parameter products (e.g. mappings, price lists etc.)

## Control
control.sp*
* Monitoring processes and error 

## Result
result.td*, result.tf*, result.v*, result.sp*
* Yields results directly usable for external or downstream systems, reporting , BI Tools etc.

## Custom
* Use by clients for client created objects (e.g. views etc.)
* For identification and preservation in case of a system rebuilding

# Prefixes

.t: 	table
.sc: 	script
.sp: 	stored procedure
.v:		view
.fn:	function
.tr:	trigger
