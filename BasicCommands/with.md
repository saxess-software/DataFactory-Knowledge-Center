
## The WITH Statement creates helper views inside a Query

````SQL
CREATE VIEW 
--Helperquerys
WITH 	Helpertable1 AS (SELECT FROM ..),
      Helpertable2 AS(SELECT FROM.... )
-- Main Query
SELECT 
  * 
FROM Maintable 
  LEFT JOIN Helpertable1 ON ...
  LEFT JOIN Helpertable2 ON ...
````
 
### The WITH Statement inside a Stored Procedure

Its not possible to create a WITH Statement global for many Statements

**NOT possible:**
````SQL
WITH Helperview AS (SELECT * FROM ..)

IF @Condition = 1 
  BEGIN 
    SELECT * FROM Maintable
      LEFT JOIN Helpertable ON .....
  END
```` 
 
**Instead use:**
````SQL
IF @Condition = 1 
  BEGIN 
   WITH Helperview AS (SELECT * FROM ..)
   
    SELECT * FROM Maintable
      LEFT JOIN Helpertable ON .....
    
  END
 ````
 
 If you need a global WITH, you must write the values in a temporary table.
