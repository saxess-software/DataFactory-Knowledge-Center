 /*
 DELETE all Productlines
 This script loops over all selected Productlines and deletes them
 All ProductLineIDs provided through SELECT-Statement will be deleted
 */

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
DECLARE @FactoryID			NVARCHAR(255)
DECLARE @ProductLineID		NVARCHAR(255)

-------------------------------------------------------------------------------------------------------------------
-- ##### DELETE ###########
DECLARE MyCursor CURSOR FOR

	SELECT FactoryID, ProductLineID
	FROM sx_pf_dProductlines 
	WHERE FactoryID NOT IN ('ZT')     
		-- AND FactoryID IN (   )
		-- AND ProductlineID IN (   )
		-- AND NameShort like '%xxx%'
		-- AND GlobalAttributSource1 IN (   )
		-- AND GlobalAttributAlias1 IN (   )

OPEN MyCursor
FETCH MyCursor INTO  @FactoryID,@ProductLineID
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC sx_pf_DELETE_Productline 'SQL', @FactoryID, @ProductlineID

      FETCH MyCursor INTO @FactoryID,@ProductLineID
END
CLOSE MyCursor
DEALLOCATE MyCursor
