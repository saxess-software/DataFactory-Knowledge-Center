CREATE VIEW [dbo].[sx_pf_vGeschäftsjahresmapping] 

AS

SELECT 
	 TimeID
	 ,CAST([SMGJ] AS INT) AS SMGJ
	 ,[GJName]
	 ,CAST([Periode] AS INT) AS Periode
	 ,[GJQ]
	 ,[GJHJ]
	
FROM 

	(
	SELECT
		 TimeID
		,ValueSeriesID
		,CASE ValueSeriesID
			WHEN 'SMGJ' THEN CAST(ValueInt AS NVARCHAR)
			WHEN 'Periode' THEN CAST(ValueInt AS NVARCHAR)
			ELSE ValueText
		 END AS Value
	FROM 
		sx_pf_fValues 
	WHERE
		FactoryID = 'ZT' AND
		ProductLineID = 'U' AND
		ProductID = 'GJM'
	) AS Souce

PIVOT
	(
	 MAX(Value) FOR ValueSeriesID IN ([SMGJ],[GJName],[Periode],[GJQ],[GJHJ])
	) AS Pivottable