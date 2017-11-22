The Pivot command turns rows from a table into colums.   
Example to create a simple Mapping / Lookuptable from a single DataFactory Product use in WITH CLAUSE:

````SQL
WITH vlookupPC AS 
	(
		SELECT 
			 -- the needed ValueSeries
			 1 AS Profitcenter
			,UV
		FROM
			(
				SELECT 
					 TimeID
					,fV.ValueSeriesID
					--the Value, it must one column - so squeeze it if different types
					,IIF(IsNumeric = 0,ValueText,CAST(CAST(ValueInt AS Money)/100 AS NVARCHAR)) AS Value

				FROM sx_pf_fValues fV 
					LEFT JOIN sx_pf_dValueSeries dVS
						ON  fV.ValueSeriesKey = dVS.ValueSeriesKey

				WHERE 	
					-- the Product(s)	
					fV.FactoryID = 'ZT' AND fV.ProductLineID = 'BFW' AND fV.ProductID = 'M1' AND
					-- the needed ValueSeries of this Product
					ValueSeriesID IN ('1','UV')
			) AS SourceTable

		PIVOT
			(	
				-- List of the needed ValueSeries in SquareBrackets
				MAX(Value) FOR ValueSeriesID IN ([1],[UV])
			) AS PivotTable
	)
 ````
