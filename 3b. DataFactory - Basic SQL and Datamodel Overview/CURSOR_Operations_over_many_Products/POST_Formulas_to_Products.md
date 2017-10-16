````SQL
/*
Script to POST formulas from one ValueSeries of an Template to all Products
(to publish Formulas which were forgotten during design and POST Template should be avoided)

Gerd Tautenhahn for DataFactory 4.0
10/2017
*/


-- Change ValueSeries to XLS if its not already the case
UPDATE sx_pf_dValueSeries SET ValueSource = 'XLS' 
WHERE 
	FactoryID != 'ZT' AND
	ProductLineID = '1' AND 
	ValueSeriesID = '600100_5'

-- POST Formula to all Products
DECLARE @ToDoListe AS Table (
 FactoryID		NVARCHAR(255) NOT NULL
,ProductLineID	NVARCHAR(255) NOT NULL
,ProductID		NVARCHAR(255) NOT NULL
,TimeID			BIGINT NOT NULL
,ValueFormula	NVARCHAR(255)
)

INSERT INTO @ToDoListe 
	SELECT 
		 FactoryID
		,ProductLineID
		,ProductID
		,Formula.TimeID
		,Formula.ValueFormula
	FROM
		sx_pf_dTime dT LEFT JOIN
				
				-- The formulas of the Value Series from the Template - maybe with time restriction
				(
				SELECT
					  TimeID
					 ,ValueFormula
	 
				FROM sx_pf_fValues 

				WHERE 
					FactoryID = 'ZT' AND
					ProductLineID = 'BFW' AND
					ProductID = '10' AND
					ValueSeriesID = '600100_5' AND 
					TimeID > 20170715
				) Formula 
				ON dT.TimeID = Formula.TimeID


	WHERE 
		ProductLineID = '1' AND
		FactoryID != 'ZT' AND
		dT.TimeID > 20170715
		
		--AND FactoryID = 'ASSMBOR_S' AND ProductID = '2058'
		

SELECT * FROM @ToDoListe

DECLARE @FactoryID		NVARCHAR(255) 
DECLARE @ProductLineID	NVARCHAR(255) 
DECLARE @ProductID		NVARCHAR(255)
DECLARE @TimeID			INT
DECLARE @ValueFormula	NVARCHAR(255)

DECLARE MyCursor CURSOR FOR
	SELECT * FROM @ToDoListe
OPEN MyCursor
FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID,@TimeID,@ValueFormula
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC sx_pf_POST_Value 'SQL', @ProductID,@ProductLineID,@FactoryID,'600100_5',@TimeID,@ValueFormula,'0','',''

	  -- Resultprint
	  Print  @ProductID+'_'+@ProductLineID+'_'+@FactoryID + '_' + CAST(@TimeID AS NVARCHAR) + '_' + @ValueFormula + ' done.'

	  FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID,@TimeID,@ValueFormula
END
CLOSE MyCursor
DEALLOCATE MyCursor 

-- Powerloaden !
````
