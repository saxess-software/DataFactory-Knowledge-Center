
-- View get data from globalattributs for a gantt chart which displays a duration (of a contract)
-- Start = GlobalAttribute4
-- Ende = GlobalAttribute5

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[cGanttChart]'))
DROP VIEW [cGanttChart]
GO

CREATE VIEW [cGanttChart]

AS

SELECT	dP.FactoryID,
		dF.NameShort AS FactoryName,
		dP.ProductLineID,
		dPL.NameShort AS ProductLineName,
		dP.ProductID,
		dP.NameShort AS ProductName,
		TRY_CAST(Convert(date,dP.GlobalAttribute4,104) AS Datetime) AS Beginn,
		TRY_CAST(Convert(date,dP.GlobalAttribute5,104) AS Datetime) AS Ende,
		DATEDIFF(DAY,Convert(date,dP.GlobalAttribute4,104),Convert(date,dP.GlobalAttribute5,104)) AS Laufzeit
		


FROM	sx_pf_dProducts dP
LEFT JOIN sx_pf_dFactories dF ON dP.FactoryKey = dF.FactoryKey
LEFT JOIN sx_pf_dProductLines dPL ON dP.ProductLineKey = dPL.ProductLineKey

WHERE	dP.FactoryID = 'BK' AND 
		TRY_CAST(Convert(date,dP.GlobalAttribute4,104) AS Datetime) <> 0 AND
		TRY_CAST(Convert(date,dP.GlobalAttribute5,104) AS Datetime) <> 0