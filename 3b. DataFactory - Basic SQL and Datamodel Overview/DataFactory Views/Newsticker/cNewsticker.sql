
-- Create View for Newsticker

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[sx_pf_cNewsticker]'))
	DROP VIEW [dbo].[sx_pf_cNewsticker]
	GO

	CREATE VIEW sx_pf_cNewsticker

	AS 


SELECT		dF.FactoryID AS FactoryID,
			dF.NameShort AS FactoryName,
			dF.FactoryID + ' ' + dF.NameShort AS FactoryIDName,
			dPL.ProductLineID AS ProductLineID,
			dPL.NameShort AS ProductLineName,
			dPL.ProductLineID + ' ' + dPL.NameShort AS ProductLineIDName,
			dP.ProductID AS ProductID,	
			dP.NameShort AS ProductName,
			dP.ProductID + ' ' + dP.NameShort AS ProductIDName,
			fS.ActionType AS Aktion,
			fS.UserName AS Benutzer,
			fS.PCName AS PCName,
			fS.Statement AS Kommentar,
			fS.Timestamp AS Zeit,
			TRY_CAST(TRY_CAST(left(fS.Timestamp,8) as nvarchar) AS Datetime)		AS [Date]
			
FROM		sx_pf_fStatements fS
LEFT JOIN	sx_pf_dFactories dF ON fS.FactoryKey = dF.FactoryKey
LEFT JOIN	sx_pf_dProductLines dPL ON fS.ProductLineKey = dPL.ProductLineKey
LEFT JOIN	sx_pf_dProducts dP ON fS.ProductKey = dP.ProductKey

WHERE fS.FactoryID NOT IN ('ZT')