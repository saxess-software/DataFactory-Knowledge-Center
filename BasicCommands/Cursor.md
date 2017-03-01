
A Cursor is a command of "Do-for-each-element" 
It contains two basic steps:
1. With a SELECT statement you select a number of rows to do something with
2. With a WHILE LOOP you do something with each of this rows

````SQL

-- Sample to export each Product in SQL Server Format

DECLARE @ProductID NVARCHAR(255)
DECLARE @ProductLineID NVARCHAR(255)
DECLARE @FactoryID NVARCHAR(255)
DECLARE MyCursor CURSOR FOR

	-- Query fills the Cursor
	SELECT ProductID, ProductLineID,FactoryID
	FROM sx_pf_dProductLines

OPEN MyCursor
-- Stuff the columns of the first row into the Cursor
FETCH MyCursor INTO @ProductID, @ProductLineID, @FactoryID
WHILE @@FETCH_STATUS = 0
	BEGIN
     	 	EXEC sx_pf_EXPORT_Product 'SQL', @FactoryID, @ProductlineID, @ProductID, 1

        -- Stuff the columns of the next row into the Cursor
      	FETCH MyCursor INTO @ProductID, @ProductLineID, @FactoryID
	END
CLOSE MyCursor
DEALLOCATE MyCursor
````
