/*
Procedure for collection basic monitoring informations on a daily base
Gerd Tautenhahn for saxess-software gmbh
04/2017 for DataFactory 4.0

Testcall
EXEC [control].[spBasicMonitoring]

*/


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[spBasicMonitoring]') AND type in (N'P', N'PC'))
DROP PROCEDURE [control].[spBasicMonitoring]
GO

CREATE PROCEDURE control.spBasicMonitoring

AS 
	-- Datenbankgröße gesamt
	INSERT INTO control.tMonitoring
		SELECT
			 '00. Basic' AS MainGroup
			,'Database' AS SubGroup
			,'1. Gesamt Datenbankgröße in MB' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'MONEY' AS ValueType
			,0 AS ValueInt
			,CAST(SUM(size) * 8. / 1024 AS DECIMAL(8,2)) AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sys.master_files WITH(NOWAIT)
			 WHERE database_id = DB_ID()
		GROUP BY database_id

	-- BASIC - Database **********************************************************************************************
	-- Datenbankgröße Daten
	INSERT INTO control.tMonitoring
		SELECT
			 '00. Basic' AS MainGroup
			,'Database' AS SubGroup
			,'2. Daten Datenbankgröße in MB' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'MONEY' AS ValueType
			,0 AS ValueInt
			,CAST(SUM(CASE WHEN type_desc = 'ROWS' THEN size END) * 8. / 1024 AS DECIMAL(8,2))  AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sys.master_files WITH(NOWAIT)
			 WHERE database_id = DB_ID()
		GROUP BY database_id

	-- Datenbankgröße Log
	INSERT INTO control.tMonitoring
		SELECT
			 '00. Basic' AS MainGroup
			,'Database' AS SubGroup
			,'3. Log Datenbankgröße in MB' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'MONEY' AS ValueType
			,0 AS ValueInt
			,CAST(SUM(CASE WHEN type_desc = 'LOG' THEN size END) * 8. / 1024 AS DECIMAL(8,2))  AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sys.master_files WITH(NOWAIT)
			 WHERE database_id = DB_ID()
		GROUP BY database_id

	-- Structure - Structure **********************************************************************************************
	-- Anzahl der Factories
	INSERT INTO control.tMonitoring
		SELECT
			 '01. Structure' AS MainGroup
			,'Structure' AS SubGroup
			,'1. Anzahl Factories (ohne ZT)' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'INT' AS ValueType
			,COUNT(FactoryID) AS ValueInt
			,0 AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sx_pf_dFactories
		WHERE FactoryID != 'ZT'

	-- Anzahl der Factories
	INSERT INTO control.tMonitoring
		SELECT
			 '01. Structure' AS MainGroup
			,'Structure' AS SubGroup
			,'2. Anzahl Productlines (ohne ZT)' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'INT' AS ValueType
			,COUNT(ProductLineID) AS ValueInt
			,0 AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sx_pf_dProductLines
		WHERE FactoryID != 'ZT'

	-- Anzahl der Products
	INSERT INTO control.tMonitoring
		SELECT
			 '01. Structure' AS MainGroup
			,'Structure' AS SubGroup
			,'3. Anzahl Products (ohne ZT)' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'INT' AS ValueType
			,COUNT(ProductID) AS ValueInt
			,0 AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sx_pf_dProducts 
		WHERE FactoryID != 'ZT'

	-- Anzahl der Templates
	INSERT INTO control.tMonitoring
		SELECT
			 '01. Structure' AS MainGroup
			,'Structure' AS SubGroup
			,'4. Anzahl Templates (ohne Unikums)' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'INT' AS ValueType
			,COUNT(ProductID) AS ValueInt
			,0 AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sx_pf_dProducts 
		WHERE FactoryID = 'ZT' AND ProductLineID !='U'

	-- Structure - User **********************************************************************************************
	-- Anzahl der User
	INSERT INTO control.tMonitoring
		SELECT
			 '01. Structure' AS MainGroup
			,'User' AS SubGroup
			,'1. Anzahl angelegte User' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'INT' AS ValueType
			,COUNT(UserName) AS ValueInt
			,0 AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sx_pf_rUser
		
	-- Anzahl der User
	INSERT INTO control.tMonitoring
		SELECT
			 '01. Structure' AS MainGroup
			,'User' AS SubGroup
			,'2. Anzahl User im Status "Active"' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'INT' AS ValueType
			,COUNT(UserName) AS ValueInt
			,0 AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sx_pf_rUser
		WHERE Status = 'Active'


	-- Activity - User **********************************************************************************************

	-- Anzahl der GET LogEntrys am Vortag
	INSERT INTO control.tMonitoring
		SELECT
			 '02. Activity am Vortag' AS MainGroup
			,'User' AS SubGroup
			,'1. Anzahl GET' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'INT' AS ValueType
			,COUNT(Logkey) AS ValueInt
			,0 AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sx_pf_API_Log
		WHERE 
			CONVERT(Date,TimestampCall) = CONVERT(Date,GETDATE() -1) AND
			ProcedureName LIKE 'sx_pf_GET%'

	-- Anzahl der POST LogEntrys am Vortag
	INSERT INTO control.tMonitoring
		SELECT
			 '02. Activity am Vortag' AS MainGroup
			,'User' AS SubGroup
			,'2. Anzahl POST' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'INT' AS ValueType
			,COUNT(Logkey) AS ValueInt
			,0 AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sx_pf_API_Log
		WHERE 
			CONVERT(Date,TimestampCall) = CONVERT(Date,GETDATE() -1) AND
			ProcedureName LIKE 'sx_pf_POST%'

	-- Anzahl der MOVE LogEntrys am Vortag
	INSERT INTO control.tMonitoring
		SELECT
			 '02. Activity am Vortag' AS MainGroup
			,'User' AS SubGroup
			,'3. Anzahl MOVE' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'INT' AS ValueType
			,COUNT(Logkey) AS ValueInt
			,0 AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sx_pf_API_Log
		WHERE 
			CONVERT(Date,TimestampCall) = CONVERT(Date,GETDATE() -1) AND
			ProcedureName LIKE 'sx_pf_MOVE%'

	-- Anzahl der DELETE LogEntrys am Vortag
	INSERT INTO control.tMonitoring
		SELECT
			 '02. Activity am Vortag' AS MainGroup
			,'User' AS SubGroup
			,'4. Anzahl DELETE' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'INT' AS ValueType
			,COUNT(Logkey) AS ValueInt
			,0 AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sx_pf_API_Log
		WHERE 
			CONVERT(Date,TimestampCall) = CONVERT(Date,GETDATE() -1) AND
			ProcedureName LIKE 'sx_pf_DELETE%'

	-- Activity - Error **********************************************************************************************
	-- Anzahl der 4XX ReturnCodes am Vortag
	INSERT INTO control.tMonitoring
		SELECT
			 '02. Activity am Vortag' AS MainGroup
			,'ERROR' AS SubGroup
			,'1. Anzahl 4XX' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'INT' AS ValueType
			,COUNT(Logkey) AS ValueInt
			,0 AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sx_pf_API_Log
		WHERE 
			CONVERT(Date,TimestampCall) = CONVERT(Date,GETDATE() -1) AND
			ReturnCode BETWEEN 400 AND 499

	-- Anzahl der 5XX ReturnCodes am Vortag
	INSERT INTO control.tMonitoring
		SELECT
			 '02. Activity am Vortag' AS MainGroup
			,'ERROR' AS SubGroup
			,'2. Anzahl 5XX' AS Measure
			,GETDATE() AS MonitoringDateTime
			,'INT' AS ValueType
			,COUNT(Logkey) AS ValueInt
			,0 AS ValueMoney
			,'' AS ValueString
			,'' AS Message
		FROM sx_pf_API_Log
		WHERE 
			CONVERT(Date,TimestampCall) = CONVERT(Date,GETDATE() -1) AND
			ReturnCode BETWEEN 500 AND 599

	

			
