/*
DELETE all users
This script loops over all selected products and deletes them
All users provided through SELECT-Statement will be deleted
*/
-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
DECLARE @DeleteUserName		NVARCHAR(255)

-------------------------------------------------------------------------------------------------------------------
-- ##### DELETE ###########
DECLARE MyCursor CURSOR FOR

	SELECT UserName
	FROM dbo.sx_pf_rUser
	--WHERE UserName LIKE '%xxx%'  
		-- AND Status = ''
		-- AND LDAPIP like '%xxx%'

OPEN MyCursor
FETCH MyCursor INTO @DeleteUserName
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC dbo.sx_pf_DELETE_User 'SQL',@DeleteUserName

      FETCH MyCursor INTO @DeleteUserName
END
CLOSE MyCursor
DEALLOCATE MyCursor
