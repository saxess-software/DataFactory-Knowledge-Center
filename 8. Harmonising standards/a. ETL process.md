d## Staging
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
* Parameterisation of load process
* Starting point for blocker in case of row error (comparison of existing data in table and new data to be loaded into the table)
* Reduction of cursors

## Import
import.sp* &
dbo.sx_pf_*

## Calc

## Param

## Control

## Result
