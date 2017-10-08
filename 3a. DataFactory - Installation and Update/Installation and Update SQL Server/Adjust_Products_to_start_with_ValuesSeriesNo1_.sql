
-- Check for ProductIDs with missing ValuesSeries No 1

SELECT FactoryID, ProductLineID, ProductID, MIN(ValueSeriesNo) AS MinValueSeriesNo, MIN(ValueSeriesNo) - 1 AS Adjustment FROM sx_pf_dValueSeries GROUP BY FactoryID, ProductLineID, ProductID

HAVING MIN(ValueSeriesNo) > 1


-- A: Update not fitting Products
-- Update sx_pf_dValueSeries SET ValueSeriesNo = ValueSeriesNo - 2 WHERE ProductID = '1' AND ProductLineID = '1' AND FactoryID = 'PE'

BEGIN TRAN
-- B: Update not fitting Products all togehter
UPDATE dVS  SET dVS.ValueSeriesNo = dVS.ValueSeriesNo - t.Adjustment OUTPUT deleted.* FROM sx_pf_dValueSeries dVS, 

	(
	SELECT FactoryID, ProductLineID, ProductID, MIN(ValueSeriesNo) AS MinValueSeriesNo, MIN(ValueSeriesNo) - 1 AS Adjustment FROM sx_pf_dValueSeries GROUP BY FactoryID, ProductLineID, ProductID

	HAVING MIN(ValueSeriesNo) > 1

	) AS t

	WHERE
		dVS.FactoryID = t.FactoryID AND
		dVS.ProductlineID = t.ProductLineID AND 
		dVS.ProductID = t.ProductID 

ROLLBACK TRAN