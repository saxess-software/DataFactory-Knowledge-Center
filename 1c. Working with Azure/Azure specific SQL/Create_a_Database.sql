/*
 This script creates a new Azure Database, optional within a pool
 After that you must
	- Execute the Create Script in DE or EN for a Cloud Cluster (this will also create the User FactoryService in this Database)
	- Create the user for this Cluster in this master database if they don't exist there already
	- Create the user for this Cluster in this database
*/

CREATE DATABASE AD00XXX_Kunde_Zweck  -- SET Name here !

	-- optional, but usual - within a database pool
	( SERVICE_OBJECTIVE = ELASTIC_POOL ( name = [DataFactory01-EDP01] ) ) 