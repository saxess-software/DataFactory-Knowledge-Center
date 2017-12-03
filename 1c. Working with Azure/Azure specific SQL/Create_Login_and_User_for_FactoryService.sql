/*
FactoryService gets
- a Login in the master database
- a user in the destination database
- a the role FactoryService in the destination database

This account gets NOT a user in the master database, thats why the Service can create only connections to single databases, not to the server

*/

-- ONLY ONCE - Konfiguration of the Server *****************************

-- 1. CREATE a LOGIN on the master Database
CREATE LOGIN FactoryService WITH password='secret';


-- For every DataFactory Database *************************************** 

-- 2a. CREATE a USER in the destination Database
CREATE USER FactoryService FROM LOGIN FactoryService

-- 2b. Give the database role
EXEC sp_addrolemember 'pf_PlanningFactoryService', 'FactoryService';