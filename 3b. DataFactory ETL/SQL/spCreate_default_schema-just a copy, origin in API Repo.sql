/*
Script to create the DataFactory Default Schemas
Gerd Tautenhahn for saxess-software gmbh
03/2017 for DataFactory 4.0
*/


IF NOT EXISTS (
	SELECT  schema_name
	FROM    information_schema.schemata
	WHERE   schema_name = 'sxdf' ) 
 
	BEGIN
		EXEC sp_executesql N'CREATE SCHEMA sxdf AUTHORIZATION dbo'   
	END
GO


IF NOT EXISTS (
	SELECT  schema_name
	FROM    information_schema.schemata
	WHERE   schema_name = 'staging' ) 
 
	BEGIN
		EXEC sp_executesql N'CREATE SCHEMA staging AUTHORIZATION dbo'   
	END
GO

IF NOT EXISTS (
	SELECT  schema_name
	FROM    information_schema.schemata
	WHERE   schema_name = 'load' ) 
 
	BEGIN
		EXEC sp_executesql N'CREATE SCHEMA load AUTHORIZATION dbo'   
	END
GO

IF NOT EXISTS (
	SELECT  schema_name
	FROM    information_schema.schemata
	WHERE   schema_name = 'import' ) 
 
	BEGIN
		EXEC sp_executesql N'CREATE SCHEMA import AUTHORIZATION dbo'   
	END
GO

IF NOT EXISTS (
	SELECT  schema_name
	FROM    information_schema.schemata
	WHERE   schema_name = 'calc' ) 
 
	BEGIN
		EXEC sp_executesql N'CREATE SCHEMA calc AUTHORIZATION dbo'   
	END
GO

IF NOT EXISTS (
	SELECT  schema_name
	FROM    information_schema.schemata
	WHERE   schema_name = 'param' ) 
 
	BEGIN
		EXEC sp_executesql N'CREATE SCHEMA param AUTHORIZATION dbo'   
	END
GO


IF NOT EXISTS (
	SELECT  schema_name
	FROM    information_schema.schemata
	WHERE   schema_name = 'control' ) 
 
	BEGIN
		EXEC sp_executesql N'CREATE SCHEMA control AUTHORIZATION dbo'   
	END
GO

IF NOT EXISTS (
	SELECT  schema_name
	FROM    information_schema.schemata
	WHERE   schema_name = 'result' ) 
 
	BEGIN
		EXEC sp_executesql N'CREATE SCHEMA result AUTHORIZATION dbo'   
	END
GO






