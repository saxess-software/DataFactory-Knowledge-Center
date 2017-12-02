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

DECLARE  @LoginUser NVARCHAR(255) = 'sxTrainer'
DECLARE  @Password NVARCHAR(255) = '_tmp2017'
DECLARE  @SQL NVARCHAR(MAX)=''

IF  DB_NAME() = 'master'
	BEGIN
		-- 1. CREATE a LOGIN on the master Database
		SET @SQL = 'CREATE LOGIN ' + @LoginUser + ' WITH password= ''' + @Password + '''';
		EXEC (@SQL)

		-- 2. CREATE a USER in the master Database
		SET @SQL = 'CREATE USER ' + @LoginUser + ' FROM LOGIN ' + @LoginUser
		EXEC (@SQL)
	END

IF  DB_NAME() != 'master'
	BEGIN

		-- 2. CREATE USER in the destination Database
		SET  @SQL = 'CREATE USER ' + @LoginUser + ' FROM LOGIN ' + @LoginUser
		EXEC (@SQL)

		-- 3. Give a databbase role
		EXEC sp_addrolemember 'pf_PlanningFactoryUser', @LoginUser;
	END

-- Management of Azure AD Users

-- CREATES a Azure AD based User in a Database - can be done in master and all databases
CREATE USER [gerd.tautenhahn@saxess.onmicrosoft.com] FROM EXTERNAL PROVIDER

-- does a Azure AD based User also need an login if he is already contributer on the sql server ?
-- and if, how to do this ?

-- Get all member per Role - execute in each Database separatly
SELECT DP1.name AS DatabaseRoleName,   
   isnull (DP2.name, 'No members') AS DatabaseUserName   
 FROM sys.database_role_members AS DRM  
 RIGHT OUTER JOIN sys.database_principals AS DP1  
   ON DRM.role_principal_id = DP1.principal_id  
 LEFT OUTER JOIN sys.database_principals AS DP2  
   ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R'
ORDER BY DP1.name;


