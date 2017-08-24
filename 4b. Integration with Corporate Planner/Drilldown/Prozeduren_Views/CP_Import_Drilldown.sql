-- View for structure Import in CP - used for Drilldown Structure Type

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[sx_pf_CPImport_Drilldown]'))
DROP VIEW [dbo].[sx_pf_CPImport_Drilldown]
GO


CREATE VIEW [dbo].[sx_pf_CPImport_Drilldown]

AS

  SELECT 'skip' AS ValueSeriesID	-- A
		,'skip' AS ValueSeriesName	-- B
		,'CT ' + Replicate('0',8-Len(fV.ProductlineID) - Len(fV.ProductID) - 1) +  fV. ProductlineID + '_' + fV.ProductID	AS ProductID						-- C
		,dP.NameShort          AS ProductName		-- D
		,'CC '+ fV.FactoryID + '_' + fV.ProductLineID + '|'		AS ProductLineID			-- E
		,dPL.NameShort         AS ProductLineName	-- F
		,'CL '+ fV.FactoryID +'|'		AS FactoryID						-- G
		,dF.NameShort          AS FactoryName		-- H
         

  FROM   sx_pf_fValues fV
         LEFT JOIN sx_pf_dValueSeries dVS
                ON fV.ValueSeriesKey = dVS.ValueSeriesKey 
         LEFT JOIN sx_pf_dProducts dP
                ON fV.ProductKey = dP.ProductKey
         LEFT JOIN sx_pf_dProductLines dPL
                ON fV.ProductLineKey = dPL.ProductLineKey
         LEFT JOIN sx_pf_dFactories dF
                ON fV.FactoryKey = dF.FactoryKey
		 LEFT JOIN sx_pf_vUserRights vR
				ON fV.FactoryID = vR.FactoryID AND 
				   fV.ProductLineID = vR.ProductLineID			

  WHERE fV.ValueInt <> 0 AND dVS.[IsNumeric] = 1 
		AND vR.[Right] IN ('Write','Read') AND vR.Username = SYSTEM_USER

  GROUP BY 

  		'CT ' + Replicate('0',8-Len(fV.ProductlineID) - Len(fV.ProductID) - 1) +  fV. ProductlineID + '_' + fV.ProductID
		,dP.NameShort       
		,'CC '+ fV.FactoryID + '_' + fV.ProductLineID + '|'		
		,dPL.NameShort       
		,'CL '+ fV.FactoryID +'|'								
		,dF.NameShort     
		
		

GO


