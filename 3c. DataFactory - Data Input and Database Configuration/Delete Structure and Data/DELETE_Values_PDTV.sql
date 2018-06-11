/*
DELETE all Values
This script loops over all selected products and deletes them
All Values provided through SELECT-Statement will be deleted
*/
-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
DECLARE @FactoryID			NVARCHAR(255)
DECLARE @ProductLineID		NVARCHAR(255)
DECLARE @ProductID			NVARCHAR(255)
DECLARE @DeleteFormulaFlag	INT				= 0		-- 1 Delete formulars and values, 0 Delete values only

-------------------------------------------------------------------------------------------------------------------
-- ##### DELETE ###########
DECLARE MyCursor CURSOR FOR

	SELECT FactoryID,ProductLineID,ProductID
	FROM dbo.sx_pf_dProducts
	WHERE FactoryID NOT IN ('ZT')     
		-- AND FactoryID IN (   )
		-- AND ProductlineID IN (   )
		-- AND ProductID IN (   )
		-- AND NameShort like '%xxx%'

OPEN MyCursor
FETCH MyCursor INTO  @FactoryID,@ProductLineID,@ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC dbo.sx_pf_DELETE_ProductDataTableValues 'SQL',@FactoryID, @ProductlineID, @ProductID,@DeleteFormulaFlag

      FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID
END
CLOSE MyCursor
DEALLOCATE MyCursor
