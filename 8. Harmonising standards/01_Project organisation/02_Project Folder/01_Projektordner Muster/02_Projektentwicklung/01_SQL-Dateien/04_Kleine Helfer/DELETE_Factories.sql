/*
DELETE all Factories
This script loops over all selected Factories and deletes them
All FactoryIDs provided through SELECT-Statement will be deleted
*/

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
DECLARE @FactoryID NVARCHAR(255)

-------------------------------------------------------------------------------------------------------------------
-- ##### DELETE ###########
DECLARE MyCursor CURSOR FOR

	SELECT FactoryID
	FROM sx_pf_dFactories 
	WHERE FactoryID NOT IN ('ZT')     
		-- AND FactoryID IN ()
		-- AND NameShort LIKE '%xxx%'
		-- AND ResponsiblePerson LIKE '%xxx%'

OPEN MyCursor
FETCH MyCursor INTO @FactoryID
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC sx_pf_DELETE_Factory 'SQL', @FactoryID
      
	  FETCH MyCursor INTO @FactoryID
END
CLOSE MyCursor
DEALLOCATE MyCursor
