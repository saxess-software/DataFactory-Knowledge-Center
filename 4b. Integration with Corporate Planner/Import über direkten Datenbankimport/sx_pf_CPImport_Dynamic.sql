-- includes dynamic TimeCalculation from ValueSeries

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[sx_pf_CPImport_Dynamic]'))
DROP VIEW [dbo].[sx_pf_CPImport_Dynamic]
GO

CREATE VIEW sx_pf_CPImport_Dynamic

AS

  SELECT 
		 fV.ValueSeriesID							-- A
		,dVS.NameShort         AS ValueSeriesName	-- B
		,fV.ProductID								-- C
		,dP.NameShort          AS ProductName		-- D
		,fV.ProductLineID							-- E
		,dPL.NameShort         AS ProductLineName	-- F
		,fV.FactoryID								-- G
		,dF.NameShort          AS FactoryName		-- H
         
		,COALESCE(dTD.Y, fV.TimeID/10000)			AS [Year]	-- I
		,COALESCE(dTD.M,(fV.TimeID/100)%100)		AS [Month]	-- J
		,COALESCE(dTD.D,fV.TimeID%100)				AS [Day]	-- K
		,TRY_CAST(CAST(fV.TimeID AS NVARCHAR(255)) AS DATETIME) AS [Date] -- L
		,TRY_CAST(TRY_CAST(COALESCE(dTD.Y, fV.TimeID/10000) *10000+ COALESCE(dTD.M,(fV.TimeID/100)%100)*100 + COALESCE(dTD.D,fV.TimeID%100) AS NVARCHAR(255))AS DATETIME) AS Date_Dynamic --M
		,Saison.Saison --N
        ,dF.ResponsiblePerson  AS FResponsiblePerson	-- O
        ,dPL.ResponsiblePerson AS PLResponsiblePerson	-- P
         
        ,dP.ResponsiblePerson		-- Q
        ,dP.[Status]				-- R

		,TRY_CAST(fV.ValueInt as Money) / isnull(dVS.Scale,1) AS Value -- S
		
		,dP.GlobalAttribute1		
        ,dP.GlobalAttribute2		
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
		
		-- dynamic Time from Template Columns
		LEFT JOIN (
					SELECT
						 ProductKey
						,TimeID
						,[Y] 
						,[M] 
						,[D] 
					FROM
						(
						SELECT 
							 ProductKey
							,ValueSeriesID
							,TimeID
							,ValueInt

						FROM sx_pf_fValues

						WHERE 
							ValueSeriesID IN ('Y','M','D') AND
							ValueInt > 0
						) AS Source

					PIVOT(MAX(ValueInt) FOR ValueSeriesID IN ([Y],[M],[D])

						) AS Pivottable

					) AS dTD 
				ON  fV.ProductKey = dTD.ProductKey AND 
					fV.TimeID = dTD.TimeID	
		-- Saison
		LEFT JOIN
			(
			SELECT TimeID, ValueText AS Saison FROM sx_pf_fValues WHERE FactoryID = 'ZT' AND ProductlineID = 'FB' AND ProductID = 'P1' AND ValueSeriesID = 'S' 
			) AS Saison ON fV.TimeID/100 = Saison.TimeID/100

  WHERE 
	fV.ValueInt <> 0 AND
    fV.ValueSeriesID NOT IN ('Y','M','D','S') AND
    dF.FactoryID != 'ZT' AND -- Filter the Templates
	vR.[Right] IN ('Write','Read') AND vR.Username = SYSTEM_USER
		
GO
