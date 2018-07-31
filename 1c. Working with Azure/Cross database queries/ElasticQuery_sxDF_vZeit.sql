
/*

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
		,MitarbeiterStatusCode		INT NOT NULL					) WITH
(DATA_SOURCE = ElasticQuery_sxDF_vZeit)


SELECT * FROM result.vZeit