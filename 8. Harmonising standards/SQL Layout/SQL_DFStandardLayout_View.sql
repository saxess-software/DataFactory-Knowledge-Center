
/*
Author: 	Heathcliff Power
Created: 	2018/01
Summary:	This template provides the layout used for creating or altering views

	SELECT * FROM [dbo].[ViewName]
*/

CREATE VIEW [dbo].[ViewName] AS

-------------------------------------------------------------------------------------------------------------------
-- ##### HILFSVIEW ###########
WITH	Hilfsview1 AS
			(	
				SELECT	 FactoryID,ProductLineID,ProductID,TimeID
						,[VSID1]						AS ValueSeries1
						,[VSID2]						AS ValueSeries2
				FROM 
					(	SELECT	 fV.FactoryID,fV.ProductLineID,fV.ProductID,TimeID,ValueSeriesID
								,ValueText
						FROM	dbo.sx_pf_fValues fV
						WHERE	fV.FactoryID <> 'ZT' AND fV.ProductLineID = '1' 	) AS Source
				PIVOT
					( 	MAX(ValueText) FOR ValueSeriesID IN ([VSID1],[VSID2]) 		) AS PT		
			),

		Hilfsview2 AS
			(	
				SELECT	*
				FROM	dbo.sx_pf_dProducts 
				WHERE	FactoryID <> 'ZT' 	
			)

-------------------------------------------------------------------------------------------------------------------
-- ##### SELECT ###########
SELECT	*
FROM Hilfsview1 Hv1
	LEFT JOIN Hilfsview2 Hv2		-- this join is needed for something
		ON	Hv1.FactoryID = Hv2.FactoryID AND Hv1.ProductLineID = Hv2.ProductLineID AND Hv1.ProductID = Hv2.ProductID

-------------------------------------------------------------------------------------------------------------------
GO


