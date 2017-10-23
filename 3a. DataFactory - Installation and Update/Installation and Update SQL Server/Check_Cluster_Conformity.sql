/*
View to check the conformity of a DataFactory Cluster
Gerd Tautenhahn, saxess Software
DataFactory 4.0
04/2017

Testcall
SELECT * FROM control.ClusterConformity
*/


CREATE VIEW control.ClusterConformity

AS 
-- Check for Keys with Value 0 ##################################
	SELECT   'ERROR - This Factorys have Factory Key 0.' AS Message
			,dF.FactoryID	AS FactoryID
			,'<none>'		AS ProductlineID
			,'<none>'		AS ProductID
			,'<none>'		AS ValueSeriesID
	FROM    dbo.sx_pf_dFactories dF
	WHERE   dF.FactoryKey = 0

UNION ALL

	SELECT   'ERROR - This ProductLines have FactoryKey 0 or ProductLine Key 0.'
			,dPL.FactoryID		AS FactoryID
			,dPL.ProductLineID	AS ProductlineID
			,'<none>'			AS ProductID
			,'<none>'			AS ValueSeriesID
	FROM    dbo.sx_pf_dProductLines dPL
	WHERE      dPL.FactoryKey = 0
			OR dPL.ProductLineKey = 0

UNION ALL

	SELECT   'ERROR - This Products have FactoryKey 0 or ProductLine Key 0 or Product Key 0.'
			,dP.FactoryID		AS FactoryID
			,dP.ProductLineID	AS ProductlineID
			,dP.ProductID		AS ProductID
			,'<none>'			AS ValueSeriesID

	FROM    dbo.sx_pf_dProducts dP
	WHERE      dP.FactoryKey = 0
			OR dP.ProductLineKey = 0
			OR dP.ProductKey = 0

UNION ALL

	SELECT  'ERROR - This ValueSeries have FactoryKey 0 or ProductLine Key 0 or Product Key 0 or ValueSeries Key 0.'
			,dVS.FactoryID		AS FactoryID
			,dVS.ProductLineID	AS ProductlineID
			,dVS.ProductID		AS ProductID
			,dVS.ValueSeriesID	AS ValueSeriesID
	FROM    dbo.sx_pf_dValueSeries dVS
	WHERE      dVS.FactoryKey = 0
			OR dVS.ProductLineKey = 0
			OR dVS.ProductKey = 0
			OR dVS.ValueSeriesKey = 0

UNION ALL

	SELECT  'ERROR - This TimeIDs in dTime have FactoryKey 0 or ProductLine Key 0 or Product Key 0'
			,dT.FactoryID		AS FactoryID
			,dT.ProductLineID	AS ProductlineID
			,dT.ProductID		AS ProductID
			,'<none>'			AS ValueSeriesID
	FROM    dbo.sx_pf_dTime dT
	WHERE      dT.FactoryKey = 0
			OR dT.ProductLineKey = 0
			OR dT.ProductKey = 0

UNION ALL

	SELECT  'ERROR - This Values have FactoryKey 0 or ProductLine Key 0 or Product Key 0 or ValueSeries Key 0.'
			,fV.FactoryID		AS FactoryID
			,fV.ProductLineID	AS ProductlineID
			,fV.ProductID		AS ProductID
			,fV.ValueSeriesID	AS ValueSeriesID
	FROM    dbo.sx_pf_fValues fV
	WHERE      fV.FactoryKey = 0
			OR fV.ProductLineKey = 0
			OR fV.ProductKey = 0
			OR fV.ValueSeriesKey = 0

-- Check for problems in Key Reference ##################################


-- Check Factory Key in all Tables
UNION ALL SELECT 'ERROR in dProductlines - FactoryKeys don''t exits', dPL.FactoryID, dPL.ProductLineID, '<none>','<none>'					FROM dbo.sx_pf_dProductLines dPL	WHERE dPL.FactoryKey		NOT IN (SELECT DISTINCT dF.FactoryKey FROM dbo.sx_pf_dFactories dF)
UNION ALL SELECT 'ERROR in dProduct - FactoryKeys don''t exits', dP.FactoryID, dP.ProductLineID, dP.ProductID,'<none>'						FROM dbo.sx_pf_dProducts dP			WHERE dP.FactoryKey			NOT IN (SELECT DISTINCT dF.FactoryKey FROM dbo.sx_pf_dFactories dF)
UNION ALL SELECT 'ERROR in dValueSeries - FactoryKeys don''t exits', dVS.FactoryID, dVS.ProductLineID, dVS.ProductID,dVS.ValueSeriesID		FROM dbo.sx_pf_dValueSeries	dVS		WHERE dVS.FactoryKey		NOT IN (SELECT DISTINCT dF.FactoryKey FROM dbo.sx_pf_dFactories dF)
UNION ALL SELECT 'ERROR in dTime - FactoryKeys don''t exits', dTM.FactoryID, dTM.ProductLineID, dTM.ProductID,'<none>'						FROM dbo.sx_pf_dTime dTM			WHERE dTM.FactoryKey		NOT IN (SELECT DISTINCT dF.FactoryKey FROM dbo.sx_pf_dFactories dF)
UNION ALL SELECT 'ERROR in fStatements - FactoryKeys don''t exits',fS.FactoryID, fS.ProductLineID, fS.ProductID,'<none>'					FROM dbo.sx_pf_fStatements fS		WHERE fS.FactoryKey			NOT IN (SELECT DISTINCT dF.FactoryKey FROM dbo.sx_pf_dFactories dF)
UNION ALL SELECT 'ERROR in fValues - FactoryKeys don''t exits',fV.FactoryID, fV.ProductLineID, fV.ProductID,fV.ValueSeriesID				FROM dbo.sx_pf_fValues fV			WHERE fV.FactoryKey			NOT IN (SELECT DISTINCT dF.FactoryKey FROM dbo.sx_pf_dFactories dF)
UNION ALL SELECT 'ERROR in gFactories - FactoryKeys don''t exits',gF.FactoryID,'<none>','<none>','<none>'									FROM dbo.sx_pf_gFactories gF		WHERE gF.FactoryKey			NOT IN (SELECT DISTINCT dF.FactoryKey FROM dbo.sx_pf_dFactories dF) AND gF.FactoryID != '' -- as this is usual
UNION ALL SELECT 'ERROR in gProductlines - FactoryKeys don''t exits', gPL.FactoryID, gPL.ProductLineID, '<none>','<none>'					FROM dbo.sx_pf_gProductlines gPL	WHERE gPL.FactoryKey		NOT IN (SELECT DISTINCT dF.FactoryKey FROM dbo.sx_pf_dFactories dF) 
UNION ALL SELECT 'ERROR in dProducts - FactoryKeys don''t exits',gP.FactoryID, gP.ProductLineID, gP.ProductID,'<none>'						FROM dbo.sx_pf_gProducts gP			WHERE gP.FactoryKey			NOT IN (SELECT DISTINCT dF.FactoryKey FROM dbo.sx_pf_dFactories dF)
UNION ALL SELECT 'ERROR in rRights - FactoryID don''t exits', rR.FactoryID, rR.ProductLineID, '<none>','<none>'								FROM dbo.sx_pf_rRights rR			WHERE rR.FactoryID			NOT IN (SELECT DISTINCT dF.FactoryID FROM dbo.sx_pf_dFactories dF) AND rR.FactoryID != '' -- as this is usual

-- Check ProductlineKey in all Tables
UNION ALL SELECT 'ERROR in dProducts - ProductlineKey don''t exits',dP.FactoryID, dP.ProductLineID, dP.ProductID,'<none>'					FROM dbo.sx_pf_dProducts dP			WHERE dP.ProductLineKey		NOT IN (SELECT DISTINCT dPL.ProductLineKey FROM dbo.sx_pf_dProductLines dPL)
UNION ALL SELECT 'ERROR in dValueSeries - ProductlineKey don''t exits', dVS.FactoryID, dVS.ProductLineID, dVS.ProductID,dVS.ValueSeriesID	FROM dbo.sx_pf_dValueSeries dVS		WHERE dVS.ProductLineKey	NOT IN (SELECT DISTINCT dPL.ProductLineKey FROM dbo.sx_pf_dProductLines dPL)
UNION ALL SELECT 'ERROR in dTime - ProductlineKey don''t exits', dTM.FactoryID, dTM.ProductLineID, dTM.ProductID,'<none>'					FROM dbo.sx_pf_dTime dTM			WHERE dTM.ProductLineKey	NOT IN (SELECT DISTINCT dPL.ProductLineKey FROM dbo.sx_pf_dProductLines dPL)
UNION ALL SELECT 'ERROR in fStatements - ProductlineKey don''t exits',fS.FactoryID, fS.ProductLineID, fS.ProductID,'<none>'					FROM dbo.sx_pf_fStatements fS		WHERE fS.ProductLineKey		NOT IN (SELECT DISTINCT dPL.ProductLineKey FROM dbo.sx_pf_dProductLines dPL)
UNION ALL SELECT 'ERROR in fValues - ProductlineKey don''t exits',fV.FactoryID, fV.ProductLineID, fV.ProductID,fV.ValueSeriesID				FROM dbo.sx_pf_fValues fV			WHERE fV.ProductLineKey		NOT IN (SELECT DISTINCT dPL.ProductLineKey FROM dbo.sx_pf_dProductLines dPL)
UNION ALL SELECT 'ERROR in gProductlines - ProductlineKey don''t exits',gPL.FactoryID, gPL.ProductLineID, '<none>','<none>'					FROM dbo.sx_pf_gProductlines gPL	WHERE gPL.ProductLineKey	NOT IN (SELECT DISTINCT dPL.ProductLineKey FROM dbo.sx_pf_dProductLines dPL) AND gPL.ProductlineID != '' -- as this is usual
UNION ALL SELECT 'ERROR in gProducts - ProductlineKey don''t exits',gP.FactoryID, gP.ProductLineID, gP.ProductID,'<none>'					FROM dbo.sx_pf_gProducts gP			WHERE gP.ProductLineKey		NOT IN (SELECT DISTINCT dPL.ProductLineKey FROM dbo.sx_pf_dProductLines dPL)
UNION ALL SELECT 'ERROR in rRights - ProductlineKey don''t exits',rR.FactoryID, rR.ProductLineID, '<none>','<none>'							FROM dbo.sx_pf_rRights rR			WHERE rR.ProductLineID		NOT IN (SELECT DISTINCT dPL.ProductlineID FROM dbo.sx_pf_dProductLines dPL) AND rR.ProductlineID != '' -- as this is usual


-- Check ProductKeys in all Tables
UNION ALL SELECT 'ERROR in dValueSeries - ProductKey don''t exits',dP.FactoryID, dP.ProductLineID, dP.ProductID,'<none>'					FROM dbo.sx_pf_dValueSeries dP		WHERE dP.ProductKey			NOT IN (SELECT DISTINCT dPL.ProductKey FROM dbo.sx_pf_dProducts dPL)
UNION ALL SELECT 'ERROR in dTime - ProductKey don''t exits', dTM.FactoryID, dTM.ProductLineID, dTM.ProductID,'<none>'						FROM dbo.sx_pf_dTime dTM			WHERE dTM.ProductKey		NOT IN (SELECT DISTINCT dPL.ProductKey FROM dbo.sx_pf_dProducts dPL)
UNION ALL SELECT 'ERROR in fStatements - ProductKey don''t exits',fS.FactoryID, fS.ProductLineID, fS.ProductID,'<none>'						FROM dbo.sx_pf_fStatements fS		WHERE fS.ProductKey			NOT IN (SELECT DISTINCT dPL.ProductKey FROM dbo.sx_pf_dProducts dPL)
UNION ALL SELECT 'ERROR in fValues - ProductKey don''t exits',fV.FactoryID, fV.ProductLineID, fV.ProductID,fV.ValueSeriesID					FROM dbo.sx_pf_fValues fV			WHERE fV.ProductKey			NOT IN (SELECT DISTINCT dPL.ProductKey FROM dbo.sx_pf_dProducts dPL)
UNION ALL SELECT 'ERROR in gProducts - ProductKey don''t exits',gP.FactoryID, gP.ProductLineID, gP.ProductID,'<none>'						FROM dbo.sx_pf_gProducts gP			WHERE gP.ProductKey			NOT IN (SELECT DISTINCT dPL.ProductKey FROM dbo.sx_pf_dProducts dPL)

-- Check ValueSeriesKeys in all Tables
UNION ALL SELECT 'ERROR in fValues - ValueSeriesKey don''t exits',fV.FactoryID, fV.ProductLineID, fV.ProductID,fV.ValueSeriesID				FROM dbo.sx_pf_fValues fV			WHERE fV.ValueSeriesKey		NOT IN (SELECT DISTINCT dVS.ValueSeriesKey FROM dbo.sx_pf_dValueSeries dVS)


-- Check for ValueSeries with non-unique number
UNION ALL SELECT  'ERROR in dValueSeries - ValueSeries number not unique ' + CAST(dVS.ValueSeriesNo AS NVARCHAR(255)), dVS.FactoryID, dVS.ProductLineID, dVS.ProductID,dVS.ValueSeriesID 
FROM    dbo.sx_pf_dValueSeries dVS
GROUP BY
	dVS.FactoryID
	,dVS.ProductLineID
	,dVS.ProductID
	,dVS.ValueSeriesID
	,dVS.ValueSeriesNo
HAVING COUNT(dVS.ValueSeriesNo) > 1

-- Check for ValueSeries with missing Value Series No 1
UNION ALL SELECT  'ERROR in dValueSeries - ValueSeries number one missing, smallest number is ' + CAST(MIN(dVS.ValueSeriesNo) AS NVARCHAR(255)), dVS.FactoryID, dVS.ProductLineID, dVS.ProductID,'<none>'
FROM    dbo.sx_pf_dValueSeries dVS
GROUP BY
	dVS.FactoryID
	,dVS.ProductLineID
	,dVS.ProductID
HAVING MIN(dVS.ValueSeriesNo) > 1

-- Check for ValueSeries with Gaps in Numbering
UNION ALL SELECT 'ERROR in dValueSeries - ValueSeries numbering has gaps.', dVS.FactoryID,  dVS.ProductlineID, dVS.ProductID, '<none>'	
FROM dbo.sx_pf_dValueSeries dVS 
GROUP BY FactoryID, ProductlineID, dVS.ProductID
HAVING MAX(dVS.ValueSeriesNo) <> COUNT(dVS.ValueSeriesNo)

--- Check for Products with Templatename missing useful suffix  eg. *_VM 
UNION ALL SELECT 'WARNING in dProducts - Templatename is missing useful suffix e.g. *_VM', dP.FactoryID, dP.ProductlineID, dP.ProductID, '<none>'	
FROM 	dbo.sx_pf_dProducts dP
WHERE	Right(Template,3) NOT IN ('_VT','_VM','_VW','_VJ','_HT','_HM','_HW','_HJ','_VN')
	
--- Check for Products with Templatename not fitting TimeType 
UNION ALL SELECT 'WARNING in dProducts - Templatename is not fitting TimeType', dP.FactoryID, dP.ProductlineID, dP.ProductID, '<none>'
FROM 	dbo.sx_pf_dProducts dP
WHERE	Right(Template,2) != TimeType





