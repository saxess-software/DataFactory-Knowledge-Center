

-- Change user password ********************************************************
ALTER LOGIN Testuser WITH PASSWORD = 'teste';  


-- CREATES a Azure AD based User in a Database - can be done in master and all databases *******************
CREATE USER [gerd.tautenhahn@saxess.onmicrosoft.com] FROM EXTERNAL PROVIDER 

-- Get all member per Role - execute in each Database separatly *******************
SELECT DP1.name AS DatabaseRoleName,   
   isnull (DP2.name, 'No members') AS DatabaseUserName   
 FROM sys.database_role_members AS DRM  
 RIGHT OUTER JOIN sys.database_principals AS DP1  
   ON DRM.role_principal_id = DP1.principal_id  
 LEFT OUTER JOIN sys.database_principals AS DP2  
   ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R'
ORDER BY DP1.name;
