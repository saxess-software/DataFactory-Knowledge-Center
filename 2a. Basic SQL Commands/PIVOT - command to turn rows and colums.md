The Pivot command turns rows from a table into colums.  

Example to show the positions as columns, where in a table the position is one column:

````SQL
SELECT 
	*
FROM calc.vAuftragserfolg_2

PIVOT
	(	
		MAX(Wert) FOR Position IN (	 [1. Offener Lieferbetrag]
									,[2. Offener Einkaufsbetrag]
									,[3. Aufbereitung]
									,[4. Aufbereitung RHB]
									,[5. Import]
									,[6. Produktkosten]
									,[7. Zoll]
									)
	) AS PivotTable
````


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
					,IIF(IsNumeric = 0,ValueText,CAST(CAST(ValueInt AS Money)/dVS.Scale AS NVARCHAR)) AS Value

				FROM sx_pf_fValues fV 
					LEFT JOIN sx_pf_dValueSeries dVS
						ON  fV.ValueSeriesKey = dVS.ValueSeriesKey

				WHERE 	
					-- the Product(s)	
					fV.FactoryID = 'ZT' AND fV.ProductLineID = 'BFW' AND fV.ProductID = 'M1' AND
					-- the needed ValueSeries of this Product
					fV.ValueSeriesID IN ('1','UV')
			) AS SourceTable

		PIVOT
			(	
				-- List of the needed ValueSeries in SquareBrackets
				MAX(Value) FOR ValueSeriesID IN ([1],[UV])
			) AS PivotTable
	)
 ````
 
 Known Problems:
 
 * you must know the data members of the row you pivot - you can't simple turn all existing and get as many columns as needed
 * this is mostly, as otherwise a changing column count would mean its dynamic and a view can't be dynamic
 
 
Knwn Solutions:
 * you can realize dynamic column output with dynamic SQL - query first the existing column members and create from this the 
 Pivot clause. Buffer the needed table rows in a temp table first, as the user otherwise needs read right on the basis table.



 The Unpivot Commad turns a Table with many column in a small long table with many rows
````SQL
 SELECT 
	  Spalte
	 ,Wert 

FROM dbo.sx_pf_dFactories dF

UNPIVOT (

	WERT FOR Spalte IN (FactoryID,NameShort)

) AS UnpivotTable
````

Know Problems:
* The Values must have the same DataType
