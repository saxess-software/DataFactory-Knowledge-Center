

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
