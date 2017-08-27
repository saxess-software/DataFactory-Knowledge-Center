-- Delete all Productlines
-- This script loops over all selected Productlines and deletes them

DECLARE @FactoryID nvarchar(255)
DECLARE @ProductLineID nvarchar(255)

DECLARE MyCursor CURSOR FOR

	-- Filter the fitting products here !!!
	SELECT ProductLineID, FactoryID
	FROM sx_pf_dProductlines WHERE FactoryID <> 'ZT'      -- CONFIG HERE
		-- AND FactoryID IN (   )
		-- AND ProductlineID IN (   )
		-- AND NameShort like '%xxx%'


OPEN MyCursor
FETCH MyCursor INTO  @ProductLineID, @FactoryID
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC sx_pf_DELETE_Productline 'SQL', @FactoryID, @ProductlineID

      FETCH MyCursor INTO @ProductLineID, @FactoryID
END
CLOSE MyCursor
DEALLOCATE MyCursor
