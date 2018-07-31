
/*
Cross-database queries on Azure (on one server)

on Azure it's called Elastic queries
In general, the elastic queries work like if you use linked servers
You create an external table in your central database which than works as an link to the source table in the other database
The external table is nothing more than a link, that's why you can get any information if you click on the table
The external table can be queried like every other table
In order to connect the relevant databases you need:
	- same user in both databases
	- Master Key encryption by password on your central database (not quite sure what it is yet)
	- database scoped credential on your central database (not quite sure what it is yet)
	- create a datasource pointing to your external database

*/

-- Create login on the server
USE master
GO

CREATE LOGIN ElasticQueryUser WITH PASSWORD = 'ElasticQuery123'
GO

-- Create user on the external database/database you want to query
USE sxDataFactory
GO

CREATE USER ElasticQueryUser FOR LOGIN ElasticQueryUser
ALTER ROLE [db_owner] ADD MEMBER [ElasticQueryUser]
GO

-- Create user on the central database/database you to store the data
USE sxDWH
GO

CREATE USER ElasticQueryUser FOR LOGIN ElasticQueryUser
ALTER ROLE [db_owner] ADD MEMBER [ElasticQueryUser]
GO

-- Create Master Key on central database
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'ElasticQuery123'
GO
CREATE DATABASE SCOPED CREDENTIAL ElasticQueryCredential WITH IDENTITY  = 'ElasticQueryUser', SECRET = 'ElasticQuery123'



-- Create an external datasource ElasticQuery_sxDF_vZeit pointing to the database sxDataFactory
CREATE EXTERNAL DATA SOURCE ElasticQuery_sxDF_vZeit WITH
	(	TYPE = RDBMS, 
		LOCATION = 'DataFactory01-sqlserver.database.windows.net', 
		DATABASE_NAME = 'sxDataFactory', 
		CREDENTIAL = ElasticQueryCredential, 
	) ;


-- If you want an exact copy of the table in the external database in your central database
-- Create scheme and a table which on central database which matches the on the external database
CREATE SCHEMA [result]
GO

CREATE EXTERNAL TABLE [result].[vZeit]
	(	 ZeitTyp					VARCHAR(4)	NOT NULL
		,MitarbeiterLogin			NVARCHAR(255)	NULL
		,MitarbeiterName			NVARCHAR(4000)	NULL
		,Jahr						INT NULL
		,Monat						INT NULL
		,Tag						INT NULL
		,Datum						DATE NULL
		,AdressID					VARCHAR(13)	NOT NULL
		,AdressName					VARCHAR(13)	NOT NULL
		,KostenträgerID				VARCHAR(17)	NOT NULL
		,KostenträgerName			VARCHAR(17)	NOT NULL
		,Beschreibung				NVARCHAR(MAX)	NULL
		,Rechnungstext				VARCHAR(18)	NOT NULL
		,IsAbrechenbarFlag			INT NOT NULL
		,[Stunden_Echtzeit]			MONEY NULL
		,[Stunden_Abrechnung]		INT NOT NULL
		,IsGesendetFlag				INT NOT NULL
		,TagIsGeschlossenFlag		INT NOT NULL
		,MitarbeiterStatusCode		INT NOT NULL					) 
WITH
(DATA_SOURCE = ElasticQuery_sxDF_vZeit)



-- If you want the copy of the table in the external database to be named differently in your central database

CREATE EXTERNAL TABLE [dbo].[tCustomizedName]
	(	 ZeitTyp					VARCHAR(4)	NOT NULL
		,MitarbeiterLogin			NVARCHAR(255)	NULL
		,MitarbeiterName			NVARCHAR(4000)	NULL
		,Jahr						INT NULL
		,Monat						INT NULL
		,Tag						INT NULL
		,Datum						DATE NULL
		,AdressID					VARCHAR(13)	NOT NULL
		,AdressName					VARCHAR(13)	NOT NULL
		,KostenträgerID				VARCHAR(17)	NOT NULL
		,KostenträgerName			VARCHAR(17)	NOT NULL
		,Beschreibung				NVARCHAR(MAX)	NULL
		,Rechnungstext				VARCHAR(18)	NOT NULL
		,IsAbrechenbarFlag			INT NOT NULL
		,[Stunden_Echtzeit]			MONEY NULL
		,[Stunden_Abrechnung]		INT NOT NULL
		,IsGesendetFlag				INT NOT NULL
		,TagIsGeschlossenFlag		INT NOT NULL
		,MitarbeiterStatusCode		INT NOT NULL					) 
WITH
(DATA_SOURCE = ElasticQuery_sxDF_vZeit,
	SCHEMA_NAME = 'result',
	OBJECT_NAME = 'vZeit'		)
