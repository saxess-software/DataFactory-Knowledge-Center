-- Reading and changing Rights is difficult- primary delete user and create it new with new rights.

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


-- Permissions which are not role based - its not easy to read, primary look if somebody should be here or not

SELECT pr.principal_id, pr.name, pr.type_desc,   
    pr.authentication_type_desc, pe.state_desc, pe.permission_name,pe.class,pe.class_desc,o.type_desc
	FROM sys.database_principals AS pr  
	LEFT JOIN sys.database_permissions AS pe  
		ON pe.grantee_principal_id = pr.principal_id
	LEFT JOIN sys.objects AS o  
    ON pe.major_id = o.object_id  
	LEFT JOIN sys.schemas AS s  
		ON o.schema_id = s.schema_id
ORDER BY pr.principal_id DESC



