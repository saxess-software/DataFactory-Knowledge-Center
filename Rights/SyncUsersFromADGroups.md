
````SQL
/*
Script for syncing DataFactory Users with  Members of given ActiveDirectory Groups
- every AD Group Member will be created as User in DataFactory with Status "Inactive"
- Rights to the users must be assigned manually
- existing users will not be changed by this script
- the source group of the user will be writen in field LDAPID
- User which are removed from the AD Group are also removed from users, if the have the LDAPID
- so manually created users are not touched by this process
- if user is switched to a different AD Group he will deleted and recreated
- user with multiple membership will be created from there primary AD GROUP
- users in subgroups are not considered
Gerd Tautenhahn, Saxess Software GmbH 2016/11
*/

DECLARE @Username NVARCHAR(255) = ''
DECLARE @UserNachname NVARCHAR(255) = ''
DECLARE @UserVorname NVARCHAR(255) = ''
DECLARE @UserMail NVARCHAR(255) = ''
DECLARE @PermissionPath NVARCHAR(255) = ''
DECLARE @ADGroupName1 NVARCHAR(255) = ''
DECLARE @ADGroupName2 NVARCHAR(255) = ''

--******************CONFIG*************************************************************************
SET @ADGroupName1 = 'WSB-GROUP\b_VSB Holding GmbH'                         --Enter Name of primary ActiveDirectory Group
SET @ADGroupName2 = 'WSB-GROUP\b_VSB Neue Energien Deutschland GmbH'       --Enter Name of secondard ActiveDirectory Group
--******************CONFIG*************************************************************************

--1. Determine AD Group Members
---------------------------------------------------------------------------------------------------------
-- temporary table to cache all AD GROUP Members of type user
IF OBJECT_ID('tempdb..#Users') IS NOT NULL
DROP TABLE #Users

CREATE TABLE #Users(
                    AccountName NVARCHAR(255)
                    ,[Type] NVARCHAR(255)
                    ,Privilege NVARCHAR(255)
                    ,MappedLoginName NVARCHAR(255)
                    ,PermissionPath NVARCHAR(255)
                    )

INSERT INTO #Users
    EXEC xp_logininfo @ADGroupName1, 'members'

INSERT INTO #Users
    EXEC xp_logininfo @ADGroupName2, 'members'

--SELECT * FROM #Users order by AccountName 

-- keep only real users, no groups - in the users may be doublettes due to multiple group membership
DELETE FROM #Users WHERE Type != 'user';

-- delete user from second group, which are already in first group
DELETE FROM #Users WHERE PermissionPath = @ADGroupName2 AND MappedLoginName IN (SELECT MappedLoginName FROM #Users WHERE PermissionPath = @ADGroupName1);


-- SELECT * FROM #Users order by AccountName

--2. delete users, which were created earlier from this process, but are no longer member of the AD Groups
---------------------------------------------------------------------------------------------------------
DELETE
FROM sx_pf_rUser 
WHERE  
	-- user was created from this sync process
	LDAPIP != '' AND
	-- user exists not longer or is switched in different AD Group
	Username + '_' + LDAPIP NOT IN (SELECT MappedLoginName + '_' + PermissionPath FROM #Users)

DELETE
FROM sx_pf_rRights
WHERE  
	-- cascading delete based on users
	Username NOT IN (SELECT Username FROM sx_pf_rUser)

-- 3. create new users
---------------------------------------------------------------------------------------------------------
DECLARE MyCursor CURSOR FOR
	-- Don't load doublettes
    SELECT DISTINCT 
		MappedLoginName,PermissionPath
	FROM #Users 
	WHERE 
		--which are not user at the moment
		MappedLoginName NOT IN (SELECT Username FROM dbo.sx_pf_rUser)
OPEN MyCursor

FETCH MyCursor INTO @Username,@PermissionPath
WHILE @@FETCH_STATUS = 0
    BEGIN

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
                   ,@PermissionPath
                   ,'Inactive')

            FETCH MyCursor INTO @Username,@PermissionPath
    END
CLOSE MyCursor
DEALLOCATE MyCursor
````
