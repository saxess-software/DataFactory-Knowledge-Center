

## SELECT FROM Fake Tables

### Select a single fake Value
````SQL
SELECT 3 AS Number
SELECT 'A' AS Category
````

## Select multiple fake Values
````SQL
SELECT Monat FROM 
                (
                 VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)
                ) Monate (Monat)
````


## WINDOW Functions

### add a row Number to a table
You must order the rows therefore by any column(s)
````SQL
SELECT 
		 ROW_NUMBER () OVER (ORDER BY Spalte1, Spalte2) AS RowNumber
		,..

FROM table
````
