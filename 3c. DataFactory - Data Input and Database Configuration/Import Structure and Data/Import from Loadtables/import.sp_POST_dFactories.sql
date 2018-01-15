
/*
Stefan Lindenlaub
2018/01
Import Data from load.tfValues using PostProductDataTableValues
	EXEC [import].[sp_POST_fValuesPDTV] '','','','',0
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[import].[sp_POST_fValuesPDTV]') AND type in (N'P', N'PC'))
DROP PROCEDURE [import].[sp_POST_fValuesPDTV]
GO

CREATE PROCEDURE [import].[sp_POST_fValuesPDTV]
				(	@FactoryID 			AS NVARCHAR(255) = '',
					@ProductlineID 		AS NVARCHAR(255) = '',
					@ProductID			AS NVARCHAR(255) = '',
					@ValueSeriesID 		AS NVARCHAR (255) = '',
					@TimeID				AS INT = 0)	   

AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
DECLARE @TimestampCall 						AS DATETIME = CURRENT_TIMESTAMP
DECLARE @ProcedureName 						AS NVARCHAR (255) = OBJECT_NAME(@@PROCID)
DECLARE @RC 								AS INT

DECLARE @ValueFormula			 			AS NVARCHAR (255)
DECLARE @ValueINT							AS INT
DECLARE @ValueText							AS NVARCHAR (MAX)
DECLARE @ValueComment			 			AS NVARCHAR (255)

DECLARE @IsIncrementalValuesFlag			AS INT
DECLARE	@ValuesInBracketsCommaSeparated 	AS NVARCHAR(MAX) 

DECLARE @ToDoList							AS TABLE
	(	 ProductID 							NVARCHAR (255)
		,ProductLineID 						NVARCHAR (255)
		,FactoryID 							NVARCHAR (255)
		,IsIncrementalValuesFlag 			INT
		,ValuesInBracketsCommaSeparated 	NVARCHAR(MAX))
				
-------------------------------------------------------------------------------------------------------------------
-- ##### TEMPORARY TABLES ###########
-- Temporäre Tabelle als Datensammler
IF OBJECT_ID('tempdb..#DATA') IS NOT NULL DROP TABLE #DATA
CREATE TABLE #DATA	
		(ProductID			NVARCHAR (255)
		,ProductLineID		NVARCHAR (255)
		,FactoryID			NVARCHAR (255)
		,ValueSeriesID		NVARCHAR (255)
		,TimeID				INT
		,ValueFormula		NVARCHAR (255)
		,ValueINT			BIGINT
		,ValueText			NVARCHAR (MAX)
		,ValueComment		NVARCHAR (2555))

INSERT INTO #DATA
		SELECT   tfV.ProductID		
				,tfV.ProductLineID	
				,tfV.FactoryID		
				,tfV.ValueSeriesID	
				,tfV.TimeID			
				,tfV.ValueFormula	
				,tfV.ValueINT		
				,tfV.ValueText		
				,tfV.ValueComment			
		FROM	load.tfValues tfV
		WHERE	(@FactoryID = '' OR tfV.FactoryID = @FactoryID)
		  AND 	(@ProductLineID = '' OR tfV.ProductLineID = @ProductLineID)
		  AND	(@ProductID = '' OR tfV.ProductID = @ProductID)
		  AND	(@ValueSeriesID = '' OR tfV.ValueSeriesID = @ValueSeriesID)
		  AND   (@TimeID = 0 OR tfV.TimeID = @TimeID)

-- Tabelle für String
INSERT INTO @ToDoList
	SELECT	 d.ProductID
			,d.ProductLineId
			,d.FactoryID
			,1
			,(SELECT  N'[(''' 
				+ dxml.ValueSeriesID + N''','  
				+ CAST(dxml.TimeID AS NVARCHAR(255))+ N',''' 
				+ dxml.ValueFormula + N''',''' 
				+ CAST(dxml.ValueInt AS NVARCHAR(255)) + N''',''' 
				+ [dbo].[sx_pf_pMaskSQL] (dxml.ValueText) + N''',''' 
				+ [dbo].[sx_pf_pMaskSQL] (dxml.ValueComment) + N''')],'
			FROM #DATA dxml
			WHERE d.FactoryID = dxml.FactoryID AND d.ProductLineID = dxml.ProductLineID AND d.ProductID = dxml.ProductID
			FOR XML PATH(''), TYPE).value('.[1]', 'nvarchar(max)') AS ValuesInBracketsCommaSeparated
	FROM #DATA d
	GROUP BY   d.ProductID, d.ProductLineId, d.FactoryID

-------------------------------------------------------------------------------------------------------------------
-- ##### POST ###########
DECLARE MyCursor CURSOR STATIC FOR

	SELECT 	 tdl.ProductID
		,tdl.ProductLineID
		,tdl.FactoryID
		,tdl.IsIncrementalValuesFlag
		,''+LEFT(tdl.ValuesInBracketsCommaSeparated,LEN(tdl.ValuesInBracketsCommaSeparated)-1)+''
	FROM @ToDoList tdl

OPEN MyCursor
FETCH MyCursor INTO @ProductID,@ProductLineID,@FactoryID, @IsIncrementalValuesFlag, @ValuesInBracketsCommaSeparated	
WHILE @@FETCH_STATUS = 0
BEGIN
	EXECUTE @RC = sx_pf_POST_ProductDataTableValues
			 'SQL'
			,@ProductID		
			,@ProductLineID	
			,@FactoryID		
			,@IsIncrementalValuesFlag
			,@ValuesInBracketsCommaSeparated									
	Print @RC
FETCH MyCursor INTO @ProductID,@ProductLineID,@FactoryID, @IsIncrementalValuesFlag, @ValuesInBracketsCommaSeparated	
END
CLOSE MyCursor
DEALLOCATE MyCursor

-------------------------------------------------------------------------------------------------------------------
GO
GRANT EXECUTE ON OBJECT ::[import].[sp_POST_fValuesPDTV] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[import].[sp_POST_fValuesPDTV] TO pf_PlanningFactoryService;
GO
