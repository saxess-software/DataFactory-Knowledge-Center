
A #Table is a temporary table which lives and is visible only for connection which created this table.

There is also a ##Table, which lives till restart of SQL Server Service and is viewable for all. 


````SQL
IF OBJECT_ID('tempdb..#Mappping') IS NOT NULL
DROP TABLE #Mapping

CREATE TABLE #Mapping 
    (
         RowKey BIGINT IDENTITY (1,1)
        ,SachkontoID_SKR03 NVARCHAR (255)
        ,SachkontoID_SKR04 NVARCHAR (255)

    )

````