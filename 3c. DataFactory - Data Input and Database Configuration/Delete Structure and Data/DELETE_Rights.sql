/*
DELETE all rights
This script loops over all selected products and deletes them
All rights provided through SELECT-Statement will be deleted
*/
-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
DECLARE @FactoryID			NVARCHAR(255)
DECLARE @ProductLineID		NVARCHAR(255)
DECLARE @DeleteUserName		NVARCHAR(255)

-------------------------------------------------------------------------------------------------------------------
-- ##### DELETE ###########
DECLARE MyCursor CURSOR FOR

	SELECT UserName,FactoryID,ProductLineID
	FROM dbo.sx_pf_rRights
	WHERE FactoryID NOT IN ('ZT')     
		-- AND FactoryID IN (   )
		-- AND ProductlineID IN (   )
		-- AND Right = ''

OPEN MyCursor
FETCH MyCursor INTO @DeleteUserName,@FactoryID,@FactoryID
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC dbo.sx_pf_DELETE_Right 'SQL',@DeleteUserName,@FactoryID,@FactoryID

      FETCH MyCursor INTO @DeleteUserName,@FactoryID,@FactoryID
END
CLOSE MyCursor
DEALLOCATE MyCursor
