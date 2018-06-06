/*
DELETE all Products 
This script loops over all selected products and deletes them
All ProductIDs provided through SELECT-Statement will be deleted
*/
-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
DECLARE @FactoryID			NVARCHAR(255)
DECLARE @ProductLineID		NVARCHAR(255)
DECLARE @ProductID			NVARCHAR(255)

-------------------------------------------------------------------------------------------------------------------
-- ##### DELETE ###########
DECLARE MyCursor CURSOR FOR

	SELECT FactoryID,ProductLineID,ProductID
	FROM sx_pf_dProducts 
	WHERE FactoryID NOT IN ('ZT')     
		-- AND FactoryID IN (   )
		-- AND ProductlineID IN (   )
		-- AND Template = 'Unikum_VM'
		-- AND NameShort like '%xxx%'
		-- AND Status IN (	)
		-- AND GlobalAttribute1 IN (	)

OPEN MyCursor
FETCH MyCursor INTO  @FactoryID,@ProductLineID,@ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC sx_pf_DELETE_Product 'SQL',@FactoryID, @ProductlineID, @ProductID

      FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID
END
CLOSE MyCursor
DEALLOCATE MyCursor
