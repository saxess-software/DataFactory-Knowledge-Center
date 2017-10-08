

````SQL
/*
Script for creating PanningFactory Users for all Members of a ActiveDirectory Group
Gerd Tautenhahn, Saxess Software GmbH 2016/11
*/

DECLARE @Username NVARCHAR(255) = ''
DECLARE @UserNachname NVARCHAR(255) = ''
DECLARE @UserVorname NVARCHAR(255) = ''
DECLARE @UserMail NVARCHAR(255) = ''
DECLARE @ADGroupName NVARCHAR(255) = ''

--******************CONFIG*************************************************************************
SET @ADGroupName = 'Domain\Group'                         --Enter Name of ActiveDirecotry Group
--******************CONFIG*************************************************************************


IF OBJECT_ID('tempdb..#Users') IS NOT NULL
DROP TABLE #Users

-- temporary table to cache all users
CREATE TABLE #Users(
					AccountName NVARCHAR(255)
					,[Type] NVARCHAR(255)
					,Privilege NVARCHAR(255)
					,MappedLoginName NVARCHAR(255)
					,PermissionPath NVARCHAR(255)
					)

INSERT INTO #Users
	EXEC xp_logininfo @ADGroupName, 'members'

-- load all user in a cursor
DECLARE MyCursor CURSOR FOR
	SELECT MappedLoginName FROM #Users
OPEN MyCursor
FETCH MyCursor INTO @Username
WHILE @@FETCH_STATUS = 0
	BEGIN
		--1. Delete if already exits
		DELETE FROM sx_pf_rUser WHERE UserName = @Username
		DELETE FROM sx_pf_rRights WHERE UserName = @Username

		DECLARE @UserKey Integer
    
    -- 2. Create the users
		INSERT INTO sx_pf_rUser
				   (UserName
				   ,PersonSurname
				   ,PersonFirstName
				   ,Email
				   ,LDAPIP
				   ,[Status])
			 VALUES
				   (@Username 
				   ,@UserNachname
				   ,@UserVorname 
				   ,@UserMail
				   ,''
				   ,'Active')

		SELECT @UserKey = scope_identity()

    --3. give rights to the user
		INSERT INTO sx_pf_rRights
				   (UserKey
				   ,UserName
				   ,FactoryID
				   ,ProductLineID
				   ,ProductID
				   ,[Right]
				   ,ReadCommentMandatory
				   ,WriteCommentMandatory)
			 VALUES
				   (@UserKey
				   ,@Username
				   ,''
				   ,''
				   ,''
				   ,'Write'   -- !!!!! Config Right
				   ,0
				   ,0)

      		FETCH MyCursor INTO @Username
	END
CLOSE MyCursor
DEALLOCATE MyCursor

````
