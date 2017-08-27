-- Delete all Factories
-- This script loops over all selected Factories and deletes them

DECLARE @FactoryID nvarchar(255)

DECLARE MyCursor CURSOR FOR

	-- Filter the fitting products here !!!
	SELECT FactoryID
	FROM sx_pf_dFactories WHERE FactoryID <> 'ZT'      -- CONFIG HERE
		-- AND FactoryID IN (   )
		-- AND NameShort like '%xxx%'

OPEN MyCursor
FETCH MyCursor INTO @FactoryID
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC sx_pf_DELETE_Factory 'SQL', @FactoryID
      
	  FETCH MyCursor INTO @FactoryID
END
CLOSE MyCursor
DEALLOCATE MyCursor
