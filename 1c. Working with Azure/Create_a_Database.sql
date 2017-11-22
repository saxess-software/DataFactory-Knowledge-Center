/*
 This script creates a new Azure Database, optional within a pool
 After that you must
	- Create the user for this Cluster in this master database if they don't exist there already
	- Create the user for this Cluster in this database
*/

CREATE DATABASE DE68
	-- optional, within a database pool
	( SERVICE_OBJECTIVE = ELASTIC_POOL ( name = [DataFactory01-EDP01] ) ) 
GO
