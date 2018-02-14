# Call stored procedure with more than one parameter value

- Stored procedure provides one parameter as filter
- You would like to filter results not only by one value but by multiple values, for example @FactoryID = (1;2;4)
- Use function dbo.sx_pf_PivotStringIntoTable(@String,@Delimiter) to pass string and convert it into table

```sql

DECLARE @FactoryID NVARCHAR(255) = '1;2;3'

IF OBJECT_ID('tempdb..#FAC') IS NOT NULL DROP TABLE #FAC
CREATE TABLE #FAC
	(		FactoryID		NVARCHAR(255)		)
INSERT INTO #FAC
	SELECT * 
	FROM [dbo].sx_pf_PivotStringIntoTable(@FactoryID,';')

SELECT * 
FROM sx_pf_fValues
WHERE (@FactoryID = '' OR FactoryID IN (SELECT FactoryID FROM #FAC)



```