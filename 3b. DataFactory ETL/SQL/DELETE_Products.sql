-- Delete all Products 
-- This script loops over all selected products and deletes them

DECLARE @FactoryID nvarchar(255)
DECLARE @ProductLineID nvarchar(255)
DECLARE @ProductID nvarchar(255)

DECLARE MyCursor CURSOR FOR

	-- Filter the fitting products here !!!
	SELECT ProductID, ProductLineID, FactoryID
	FROM sx_pf_dProducts WHERE FactoryID <> 'ZT'      -- CONFIG HERE
		-- AND FactoryID IN (   )
		-- AND ProductlineID IN (   )
		-- AND Template = 'Unikum_VM'
		-- AND NameShort like '%xxx%'


OPEN MyCursor
FETCH MyCursor INTO  @ProductID, @ProductLineID, @FactoryID
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC sx_pf_DELETE_Product 'SQL',@FactoryID, @ProductlineID, @ProductID

      FETCH MyCursor INTO @ProductID, @ProductLineID, @FactoryID
END
CLOSE MyCursor
DEALLOCATE MyCursor
