/*
  The DataFactory database schema must be created first
  NO Use Database on Azure - you must switch the connection between the steps
  https://www.youtube.com/watch?v=SDBy9JjsZBw

  You must create a User with Login only, if a User shall be able to access the 
  database direct, e.g. over SQL Managmentstudio to execute SQL.
  Give him usually the role 'pf_PlanningFactoryUser' then the right system is still 
  on and he can excecute public procedures over SSMS.
  For Access over DataFactory WebClient/Excel Client no User is nessecary, all
  requests go over User FactoryService. Any registered User can be created in the 
  DataFactory Right system to get access.
*/

DECLARE  @LoginUser			NVARCHAR(255)	= 'sxad.HansSommer';   -- give enduser the prefix "sxad" to signalize the this is a User from SX Active Directory B2C
DECLARE  @Password			NVARCHAR(255)	= 'qx7uOh3d';
DECLARE  @SQL				NVARCHAR(MAX)	= '';
DECLARE  @ChangePassword	INT				= 0;						-- set this to 1 if you want to change the password of an existing user

-- Login and password are created / changed if you execute this script in master database
IF  DB_NAME() = 'master' AND @ChangePassword = 0
	BEGIN
		-- 1. CREATE a LOGIN on the master Database
		SET @SQL = 'CREATE LOGIN [' + @LoginUser + '] WITH password= ''' + @Password + '''';
		EXEC (@SQL)

		-- 2. CREATE a USER in the master Database - Usually NOT - with this the user can start on server level and can see (not access) all other databases
		-- SET @SQL = 'CREATE USER ' + @LoginUser + ' FROM LOGIN ' + @LoginUser
		-- EXEC (@SQL)
	END

IF  DB_NAME() = 'master' AND @ChangePassword = 1
	BEGIN
		-- 3. Alter Password for LOGIN in the master Database
		SET @SQL = 'ALTER LOGIN [' + @LoginUser + '] WITH password= ''' + @Password + '''';
		EXEC (@SQL)

	END

-- User and database rights are created if you execute this script in the target database
IF  DB_NAME() != 'master'
	BEGIN

		-- 2. CREATE USER in the destination Database
		SET  @SQL = 'CREATE USER [' + @LoginUser + '] FROM LOGIN [' +  @LoginUser +']'
		EXEC (@SQL)

		-- 3. Give a databbase role
		EXEC sp_addrolemember 'pf_PlanningFactoryUser', @LoginUser;
	END


-- You can grant Access to groups or persons of Azure ActiveDirectory
-- You don't need to create an User in the master database for them
-- You must grant this access to each database

CREATE USER [sxMitarbeiterFest] FROM EXTERNAL PROVIDER;

DROP USER [sxMitarbeiterFest];

CREATE USER [gerd.tautenhahn@saxess.onmicrosoft.com] FROM EXTERNAL PROVIDER;

DROP USER [gerd.tautenhahn@saxess.onmicrosoft.com];

-- Rights for Tables / Views

GRANT SELECT ON OBJECT ::[result].[vZeit] TO [sxPersonal];

-- Rights for schema
GRANT SELECT ON SCHEMA :: sxDWH TO [sxMitarbeiterFest]

-- Right to create Views
GRANT CREATE VIEW TO [DataFactory_Developer]



-- Give UserRights to AD Group
CREATE USER [DataFactory_Developer] FROM EXTERNAL PROVIDER;

EXEC sp_addrolemember 'db_owner', [DataFactory_Developer];