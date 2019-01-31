1. AUTHORIZATION defines the owner of an securable (any object with righs like an view, table, stored procedure etc.)
1. the owner is very import for the owership chains (https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2008-r2/ms188676(v=sql.105))
1. ownership chains are very important if an object calls another object
1. permissons on objects are not checked if both objects have the same owner
1. you must not leave the batch to keep in the ownership chain - you must call the subobjects within one transaction
1. Dynamic SQL will kill the ownership chain rules - from this object on you need always rights on the underlying object (you can only go deeper into trick box and use EXECUTE AS)
1. all objects in DataFactory database should be owned by dbo
1. schema has nothing to do with owner (schema is an security container) but is often wrong treated as owner 



The only reliable way to find the owner of a object is to query the sys.objects catalog view. The owner of an object is not visible in SSMS.


Sample - check the owner of all objects in control schema
````SQL

SELECT 'OBJECT' AS entity_type  
    ,USER_NAME(OBJECTPROPERTY(object_id, 'OwnerId')) AS owner_name  
    ,name   
FROM sys.objects WHERE SCHEMA_NAME(schema_id) = 'control'

````


````SQL
ALTER AUTHORIZATION ON OBJECT::control.spTest TO dbo; 
````

Microsoft
https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-authorization-transact-sql?view=sql-server-2017

Helpful article about nested procedure rights
https://stackoverflow.com/questions/3815411/stored-procedure-and-permissions-is-execute-enough/3815444

Very helpful for right overview
https://dba.stackexchange.com/questions/18610/what-is-the-purpose-of-the-database-owner/18616#18616?s=4bbbe3a471e24421a28f6c81b3f8be7d

The default owner of an object may be different, depending on how (SSMS or script) it is created
http://www.sqlservercentral.com/articles/Advanced/understandingobjectownership/1966/


You can enable dynamic SQL Calls in the ownership chain with the "EXECUTE AS" Option
https://www.mssqltips.com/sqlservertip/1822/dynamic-sql-and-ownership-chaining-in-sql-server/