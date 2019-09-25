/*
  The DataFactory database schema must be created first
  NO Use Database on Azure - you must switch the connection between the steps
  https://www.youtube.com/watch?v=SDBy9JjsZBw

  User Rights must be created only if the user must access its database directly - not for DataFactory use

  Admin Rights are create inside Azure Portal
	- there is always on SQL User as root admin
	- You add B2C AD Member to the Security Group

  There are three types of non-admin access you could grant
  1. Login in the master Database, User in the master Database and user in the Target Database
	 - can login on server level
	 - sees all Database names (but can't access)
	 - can access Databases where he has Userrights 

  2. Login in the master Database, user in one or more Target Databases
     - user can login into multiple Target Databases with the same user / pw
	 - can't login on server level

  3. User in the Target Database (Contained Database User without login) - STANDARD
     - user can login only in the Target Database 
	 - Access to multiple Database need multiple User / Password pairs

-- CASE 1 only for saxess user and services - Excute first on master, than on target database
-- ###########################################################################################

	DECLARE  @LoginUser			NVARCHAR(255)	= 'service_sxRunbooks';   -- give enduser the prefix "sxad" to signalize the this is a User from SX Active Directory B2C
	DECLARE  @Password			NVARCHAR(255)	= 'xx';
	DECLARE  @SQL				NVARCHAR(MAX)	= '';

	IF  DB_NAME() = 'master' 
		BEGIN
			-- 1. CREATE a LOGIN on the master Database
			SET @SQL = 'CREATE LOGIN [' + @LoginUser + '] WITH password= ''' + @Password + '''';
			EXEC (@SQL)

			-- 2. CREATE a USER in the master Database 
			SET @SQL = 'CREATE USER [' + @LoginUser + '] FROM LOGIN [' + @LoginUser + ']'
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


-- CASE 2 only for saxess customers with multiple Azure Databases- execute first on master, than on target database
-- ##################################################################################################################

	DECLARE  @LoginUser			NVARCHAR(255)	= 'sxad.x';   -- give enduser the prefix "sxad" to signalize the this is a User from SX Active Directory B2C
	DECLARE  @Password			NVARCHAR(255)	= 'xx';
	DECLARE  @SQL				NVARCHAR(MAX)	= '';

	IF  DB_NAME() = 'master' 
		BEGIN
			-- 1. CREATE a LOGIN on the master Database
			SET @SQL = 'CREATE LOGIN [' + @LoginUser + '] WITH password= ''' + @Password + '''';
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

-- CASE 3 for saxess customers with one Azure Database
-- ##################################################################################################################

	DECLARE  @LoginUser			NVARCHAR(255)	= 'sxad.x';   -- give enduser the prefix "sxad" to signalize the this is a User from SX Active Directory B2C
	DECLARE  @Password			NVARCHAR(255)	= 'xx';
	DECLARE  @SQL				NVARCHAR(MAX)	= '';

	-- 2. CREATE USER in the destination Database
	SET  @SQL = 'CREATE USER [' + @LoginUser + '] WITH Password = ''' + @Password + ''''
	EXEC (@SQL)

	-- 3. Give a databbase role
	EXEC sp_addrolemember 'pf_PlanningFactoryUser', @LoginUser;



-- Alter Password - exceute in master db (CASE 1+2) or in user db (CASE 3)
-- ##################################################################################################################
DECLARE  @LoginUser			NVARCHAR(255)	= 'service_x';  
DECLARE  @Password			NVARCHAR(255)	= 'xx';
DECLARE  @SQL				NVARCHAR(MAX)	= '';

-- 3. Alter Password for LOGIN in the master Database
SET @SQL = 'ALTER LOGIN [' + @LoginUser + '] WITH password= ''' + @Password + '''';
EXEC (@SQL)




-- Other Samples
-- ##################################################################################################################

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


-- INFORMATIONS
-- Excecute on master database
-- See all logins -> this are the logins you see also in SSMS under security -> a login enable to log in on server or database level
SELECT * FROM sys.sql_logins

-- See all User of Master -> People who can login on Server level (and maybe in many databases) - but you see not the user from external provider (Azure) here !
SELECT * FROM sys.sysusers WHERE islogin = 1 AND hasdbaccess = 1

-- Excectute on any database -> People who can login right on this database
SELECT * FROM sys.sysusers WHERE islogin = 1 AND hasdbaccess = 1 -- but you see not the user from external provider (Azure) here !


-- alle Datenbankprinzipale
SELECT pr.principal_id, pr.name, pr.type_desc,   
    pr.authentication_type_desc, pe.state_desc, pe.permission_name  
FROM sys.database_principals AS pr  
LEFT JOIN sys.database_permissions AS pe  
    ON pe.grantee_principal_id = pr.principal_id;  
*/