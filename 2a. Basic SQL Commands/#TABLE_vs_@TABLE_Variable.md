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
* you can create an index on the #table

https://stackoverflow.com/questions/11857789/when-should-i-use-a-table-variable-vs-temporary-table-in-sql-server
