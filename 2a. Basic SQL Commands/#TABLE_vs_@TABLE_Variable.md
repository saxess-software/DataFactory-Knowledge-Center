To store temporary Values inside a procedure you can use 

## A: a temporary table

````SQL

DELETE TABLE IF EXISTS #ToDoList

CREATE TABLE #ToDoList (
 FactoryID  NVARCHAR(255) NOT NULL
,ProductLineID NVARCHAR(255) NOT NULL
,ProductID NVARCHAR(255) NOT NULL
)
````

## B: a table variable
````SQL
DECLARE @ToDoListe AS Table (
 FactoryID  NVARCHAR(255) NOT NULL
,ProductLineID NVARCHAR(255) NOT NULL
,ProductID NVARCHAR(255) NOT NULL
)
````


The Way A is usually the better one, as
* your can separate execute the SQL Block to fill the # Table and it stays filled
* you can create an index on the #table and you have advantages in execution plan due to table statistics

https://stackoverflow.com/questions/11857789/when-should-i-use-a-table-variable-vs-temporary-table-in-sql-server


Deeper insight:
* the #Table requires two compilations of the procedure during runtime (you can see in Profiler), one due to schema change, one due to include the table statistics after Insert
* the @Table variable requires no recompoliation, but execution plan uses always estimated rowcount of 1
* for many rows you should use #table due to the advantages of statistics
* for up to 10 rows, you should use table variables due to advantage of not recompiling
