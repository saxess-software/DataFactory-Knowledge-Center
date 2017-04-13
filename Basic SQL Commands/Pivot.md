The Pivot command turns rows from a table into colums.   
Example to create a simple Mapping / Lookuptable from a single DataFactory Product:

````SQL
SELECT 
	 -- the needed ValueSeries
	 1 AS Profitcenter
	,UV
FROM
	(
		SELECT 
			TimeID
			,ValueSeriesID
			--the Value, it must one column - so squeeze it if different types
			,IIF(IsNumeric = 0,ValueText,CAST(CAST(ValueInt AS Money)/100 AS NVARCHAR)) AS Value

		FROM sx_pf_fValues 

		WHERE 	
			-- the Product(s)	
			FactoryID = 'ZT' AND ProductLineID = 'BFW' AND ProductID = 'M1' AND
			-- the needed ValueSeries of this Product
			ValueSeriesID IN ('1','UV')
	) AS SourceTable

PIVOT
	(	
		-- List of the needed ValueSeries in SquareBrackets
		MAX(Value) FOR ValueSeriesID IN ([1],[UV])
	) AS PivotTable
 ````
