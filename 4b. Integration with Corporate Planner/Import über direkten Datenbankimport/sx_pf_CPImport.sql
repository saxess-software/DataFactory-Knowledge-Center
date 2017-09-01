
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[sx_pf_CPImport]'))
DROP VIEW [dbo].[sx_pf_CPImport]
GO

CREATE VIEW sx_pf_CPImport

AS

  SELECT fV.ValueSeriesID							-- A
		,dVS.NameShort         AS ValueSeriesName	-- B
		,fV.ProductID								-- C
		,dP.NameShort          AS ProductName		-- D
		,fV.ProductLineID							-- E
		,dPL.NameShort         AS ProductLineName	-- F
		,fV.FactoryID								-- G
		,dF.NameShort          AS FactoryName		-- H
         
		 ,fV.TimeID															-- I
		 ,TRY_CAST(fV.TimeID AS Integer) / 10000 as Year					-- J
		 ,(TRY_CAST(fV.TimeID AS Integer) % 10000) /100 as Month			-- K
		 ,TRY_CAST(TRY_CAST(fV.TimeID as nvarchar) AS Datetime) as [Date]	--L

         ,dF.ResponsiblePerson  AS FResponsiblePerson	-- M
         ,dPL.ResponsiblePerson AS PLResponsiblePerson	-- N
         
         ,dP.ResponsiblePerson		-- O
         ,dP.[Status]				-- P
         ,dP.GlobalAttribute1		-- Q
         ,dP.GlobalAttribute2		-- R

		 ,TRY_CAST(fV.ValueInt as Money) / isnull(dVS.Scale,1) AS Value -- S

		 ,dP.GlobalAttribute3
         ,dP.GlobalAttribute4
         ,dP.GlobalAttribute5
         ,dP.GlobalAttribute6
         ,dP.GlobalAttribute7
         ,dP.GlobalAttribute8
         ,dP.GlobalAttribute9
         ,dP.GlobalAttribute10
         ,dVS.ValueSeriesNo
		 ,dVS.VisibilityLevel
         ,dVS.ValueSource
         ,dVS.Unit
         ,dVS.Effect
         ,dVS.EffectParameter

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
		
		
GO
