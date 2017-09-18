
-- NO Use Database on Azure - you must switch the connection between the steps
-- https://www.youtube.com/watch?v=SDBy9JjsZBw

-- ONLY ONCE - Konfiguration of the Server

-- 1. CREATE a LOGIN on the master Database
CREATE LOGIN FactoryService WITH password='secret';

-- 2. CREATE a USER in the master Database
CREATE USER FactoryService FROM LOGIN FactoryService

-- For every DataFactory Database 

-- 2. CREATE a USER in the destination Database
CREATE USER FactoryService FROM LOGIN FactoryService

-- 3. Give a databbase role
EXEC sp_addrolemember 'pf_PlanningFactoryService', 'FactoryService';