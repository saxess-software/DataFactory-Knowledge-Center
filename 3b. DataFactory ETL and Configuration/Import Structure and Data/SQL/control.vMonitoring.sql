
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[control].[vMonitoring]'))
DROP VIEW [control].[vMonitoring]
GO

CREATE VIEW control.vMonitoring

AS 

SELECT 
	 MainGroup
	,SubGroup
	,Measure
	,MonitoringDateTime
	,YEAR(MonitoringDateTime) as Year
	,Month(MonitoringDateTime) AS Month
	,Day(MonitoringDateTime) AS Day
	,ValueType
	,ValueInt
	,ValueMoney
	,ValueString
	,CASE ValueType
		WHEN 'INT' THEN CAST(ValueInt AS NVARCHAR(255)) 
		WHEN 'MONEY' THEN CAST(ValueMoney AS NVARCHAR(255)) 
		WHEN 'STRING' THEN ValueString
	 END AS Value_all_String
	,CASE ValueType
		WHEN 'INT' THEN CAST(ValueInt AS Money)
		WHEN 'MONEY' THEN ValueMoney  
		WHEN 'STRING' THEN 0
	 END AS Value_all_Numeric
	,Message

FROM control.tMonitoring