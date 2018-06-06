/*
DELETE certain Values
This script loops over all selected products and deletes them
All Values provided through SELECT-Statement will be deleted
*/
-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
DECLARE @FactoryID			NVARCHAR(255)
DECLARE @ProductLineID		NVARCHAR(255)
DECLARE @ProductID			NVARCHAR(255)
DECLARE @ValueSeriesID		NVARCHAR(255)

-------------------------------------------------------------------------------------------------------------------
-- ##### DELETE ###########
DECLARE MyCursor CURSOR FOR

	SELECT FactoryID,ProductLineID,ProductID,ValueSeriesID
	FROM dbo.sx_pf_dValueSeries 
	WHERE FactoryID NOT IN ('ZT')     
		-- AND FactoryID IN (   )
		-- AND ProductlineID IN (   )
		-- AND ProductID IN (   )
		-- AND NameShort like '%xxx%'

OPEN MyCursor
FETCH MyCursor INTO  @FactoryID,@ProductLineID,@ProductID,@ValueSeriesID
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC dbo.sx_pf_DELETE_Values 'SQL',@FactoryID, @ProductlineID, @ProductID,@ValueSeriesID

      FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID,@ValueSeriesID
END
CLOSE MyCursor
DEALLOCATE MyCursor
