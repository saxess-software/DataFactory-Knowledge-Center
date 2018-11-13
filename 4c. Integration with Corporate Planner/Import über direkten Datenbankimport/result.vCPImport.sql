
/*
Author: 	Heathcliff Power
Created: 	2018/11
Summary:	This view provides data for import into Corporate Planner from result.tBuchungsjournal
	SELECT * FROM [result].[vCPImport]
*/

IF EXISTS (SELECT * FROM sys.views WHERE OBJECT_ID = OBJECT_ID(N'[result].[vCPImport]'))
DROP VIEW [result].[vCPImport]
GO

CREATE VIEW [result].[vCPImport] AS

-------------------------------------------------------------------------------------------------------------------
-- ##### SELECT ###########
SELECT	 tb.KontoID
		,tpkh.KTOBEZ																									AS KontoName
		,tb.KostenstellenID
		,tpk.KSTBEZ																										AS KostenstellenName
		,tb.MandantenID
		,dF.NameShort																									AS MandantenName
		,tb.Jahr*10000 + tb.Monat *100 + tb.Tag																			AS TimeID
		,tb.Jahr
		,tb.Monat
		,tb.Tag
		,TRY_CAST(TRY_CAST(tb.Jahr*10000 + tb.Monat *100 + tb.Tag AS NVARCHAR(255)) AS DATETIME)						AS Datum
		,'CL ' + tb.MandantenID + ' |CC ' + tb.KostenstellenID + ' |CT ' + RIGHT('000000' + LEFT(tb.KontoID,6),8)		AS CPKey
FROM result.tfBuchungsjournal tb
	LEFT JOIN param.tPivotKST tpk		-- Kostenstellenbezeichnung
		ON tb.KostenstellenID = tpk.KSTID
	LEFT JOIN param.tPivotKTO_HGB tpkh	-- Kontenbezeichnung
		ON tb.KontoID = tpkh.KTOID
	LEFT JOIN dbo.sx_pf_dFactories dF	-- Mandantenbezeichnung
		ON tb.MandantenID = dF.FactoryID

-------------------------------------------------------------------------------------------------------------------
GO
GRANT SELECT ON OBJECT:: [result].[vCPImport] TO pf_PlanningFactoryUser;
GRANT SELECT ON OBJECT:: [result].[vCPImport] TO pf_PlanningFactoryService;
GO