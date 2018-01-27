
A Cursor is a command of "Do-for-each-element"  
It contains two basic steps:  

1. With a SELECT statement you select a number of rows to do something with
1. With a WHILE LOOP you do something with each of this rows

````SQL

-- Sample to export each Product in SQL Server Format

DECLARE	 @ProductID		NVARCHAR(255) = ''
	,@ProductLineID		NVARCHAR(255) = ''
	,@FactoryID		NVARCHAR(255) = ''

DECLARE MyCursor CURSOR FOR

	-- Query fills the Cursor
	SELECT 
		 ProductID
		,ProductLineID
		,FactoryID
	FROM dbo.sx_pf_dProducts
	WHERE 
		FactoryID <> 'ZT'

OPEN MyCursor
	-- Stuff the columns of the first row into the Cursor
	FETCH MyCursor INTO @ProductID, @ProductLineID, @FactoryID
	WHILE @@FETCH_STATUS = 0
		BEGIN
     	 		EXEC dbo.sx_pf_EXPORT_Product 'SQL', @FactoryID, @ProductlineID, @ProductID, 1

			-- Stuff the columns of the next row into the Cursor
      		FETCH MyCursor INTO @ProductID, @ProductLineID, @FactoryID
		END
CLOSE MyCursor
DEALLOCATE MyCursor
````

Sometimes a cursor loops endlessly...

Solution... FetchStatus is global...so the cursor should be static
http://www.dotnettricks.com/learn/sqlserver/sql-server-different-types-of-cursors
https://www.sqlservercentral.com/Forums/1514994/Cursor-fetch-loops-endlessly?PageIndex=3
