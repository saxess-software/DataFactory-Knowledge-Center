

# Permanent Tables

IF OBJECT_ID('Demotabelle') IS NOT NULL
DROP TABLE Demotabelle 



# Temporary Tables

A #Table is a temporary table which lives and is visible only for connection which created this table.

There is also a ##Table, which lives till restart of SQL Server Service and is viewable for all. 


````SQL

DROP TABLE IF EXISTS #Neueinstellungen -- from SQL Server 2016 on

IF OBJECT_ID('tempdb..#Mapping') IS NOT NULL
DROP TABLE #Mapping

CREATE TABLE #Mapping 
    (
         RowKey BIGINT IDENTITY (1,1)
        ,SachkontoID_SKR03 NVARCHAR (255)	COLLATE DATABASE_DEFAULT	NOT NULL
        ,SachkontoID_SKR04 NVARCHAR (255)	COLLATE DATABASE_DEFAULT	NOT NULL

    )

````
