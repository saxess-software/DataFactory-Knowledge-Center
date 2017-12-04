It is possible to Query User and Groups direct from the Active Directory as linked Server 
You need sysadmin privileges to create a linked Server.
Its used to get the real names and properties for login names.

````SQL
-- 1. Register ActiveDirectory as linked Server
-- set Username / PW !!

USE [master]
GO 
EXEC master.dbo.sp_addlinkedserver @server = N'ADSI', @srvproduct=N'Active Directory Service Interfaces', @provider=N'ADSDSOObject', @datasrc=N'adsdatasource'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'ADSI',@useself=N'False',@locallogin=NULL,@rmtuser=N'sx\gta-admin',@rmtpassword='*****' -- set password to execute
GO 
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'collation compatible',  @optvalue=N'false'
GO 
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'data access', @optvalue=N'true'
GO 
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'dist', @optvalue=N'false'
GO 
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'pub', @optvalue=N'false'
GO 
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'rpc', @optvalue=N'false'
GO 
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'rpc out', @optvalue=N'false'
GO 
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'sub', @optvalue=N'false'
GO 
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'connect timeout', @optvalue=N'0'
GO 
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'collation name', @optvalue=null
GO 
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'lazy schema validation',  @optvalue=N'false'
GO 
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'query timeout', @optvalue=N'0'
GO 
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'use remote collation',  @optvalue=N'true'
GO 
EXEC master.dbo.sp_serveroption @server=N'ADSI', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO

-- 2. Query AD, Name of Domaincontroller must be set in Query
-- determine Domaincontroller with DOS Command: echo %LOGONSERVER%
-- get FQDN from PC Properties e.g. Domain.intern with "whoami  /FQDN"
-- LDAP://Domaincontroller/DC=FQDN1, DC=FQDN2


SELECT * FROM OpenQuery ( 
  ADSI,  
  'SELECT streetaddress, pager, company, title, displayName, telephoneNumber, sAMAccountName, 
  mail, mobile, facsimileTelephoneNumber, department, physicalDeliveryOfficeName, givenname,lastLogon,isDeleted,userAccountControl
  FROM  ''LDAP://sxDC-01/DC=sx,DC=intern'' 
  ') AS tblADSI
WHERE sAMAccountName IS NOT NULL

ORDER BY displayname

````
