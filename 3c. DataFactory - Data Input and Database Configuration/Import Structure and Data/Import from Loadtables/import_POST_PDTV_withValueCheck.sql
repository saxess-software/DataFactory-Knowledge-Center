/*
Stefan Lindenlaub
2018/01
Import Data from load.tfValues using PostProductDataTableValues
Check before Import if there are values which cannot be posted
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
DECLARE @Source					 			AS NVARCHAR (255)
DECLARE @SourceTimeStamp		 			AS DATETIME
DECLARE	@ErrorMessage		AS NVARCHAR(MAX) = ''

DECLARE @IsIncrementalValuesFlag			AS INT
DECLARE	@ValuesInBracketsCommaSeparated 	AS NVARCHAR(MAX) 

DECLARE @ToDoList AS TABLE
	(	 ProductID 							NVARCHAR (255)
		,ProductLineID 						NVARCHAR (255)
		,FactoryID 							NVARCHAR (255)
		,IsIncrementalValuesFlag 			INT
		,ValuesInBracketsCommaSeparated 	NVARCHAR(MAX))

-------------------------------------------------------------------------------------------------------------------
-- ##### TEMPORARY TABLES ###########
-- Tabelle zum Sammeln der Fehlermeldungen
IF OBJECT_ID('tempdb..#ERROR') IS NOT NULL DROP TABLE #ERROR
CREATE TABLE #ERROR
		(Identifier1		NVARCHAR (255)	NULL,			-- FactoryID_ProductLineID_ProductID_ValueSeriesID_TimeID   (_ValueFormular_ValueComment_ValueInt_ValueText)
		 Errormessage		NVARCHAR (255)	NULL	)

	-- Check if FACTORYID exists
	INSERT INTO #ERROR
		SELECT	 tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255))
				,'FactoryID doesnt exist'
		FROM [load].tfValues tfV
		WHERE tfV.FactoryID NOT IN (SELECT dF.FactoryID FROM dbo.sx_pf_dFactories dF)
				AND (@FactoryID = '' OR tfV.FactoryID = @FactoryID)
				AND (@ProductLineID = '' OR tfV.ProductLineID = @ProductLineID)
				AND	(@ProductID = '' OR tfV.ProductID = @ProductID)
				AND	(@ValueSeriesID = '' OR tfV.ValueSeriesID = @ValueSeriesID)
				AND (@TimeID = 0 OR tfV.TimeID = @TimeID)

	-- Check if PRODUCTLINEID exists
	INSERT INTO #ERROR
		SELECT	 tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255))  
				,'ProductLineID doesnt exist'
		FROM [load].tfValues tfV
		WHERE tfV.FactoryID + '_' + tfV.ProductLineID NOT IN (SELECT spdpl.FactoryID + '_' + spdpl.ProductLineID FROM dbo.sx_pf_dProductLines spdpl)
				AND tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255)) NOT IN (SELECT Identifier1 FROM #ERROR)
				AND (@FactoryID = '' OR tfV.FactoryID = @FactoryID)
				AND (@ProductLineID = '' OR tfV.ProductLineID = @ProductLineID)
				AND	(@ProductID = '' OR tfV.ProductID = @ProductID)
				AND	(@ValueSeriesID = '' OR tfV.ValueSeriesID = @ValueSeriesID)
				AND (@TimeID = 0 OR tfV.TimeID = @TimeID)

	-- Check if PRODUCTID exists
	INSERT INTO #ERROR
		SELECT	 tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255))  
				,'ProductID doesnt exist'
		FROM [load].tfValues tfV
		WHERE tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID NOT IN (SELECT dP.FactoryID + '_' + dP.ProductLineID + '_' + dP.ProductID  FROM dbo.sx_pf_dProducts dP)
				AND tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255)) NOT IN (SELECT Identifier1 FROM #ERROR)
				AND (@FactoryID = '' OR tfV.FactoryID = @FactoryID)
				AND (@ProductLineID = '' OR tfV.ProductLineID = @ProductLineID)
				AND	(@ProductID = '' OR tfV.ProductID = @ProductID)
				AND	(@ValueSeriesID = '' OR tfV.ValueSeriesID = @ValueSeriesID)
				AND (@TimeID = 0 OR tfV.TimeID = @TimeID)

	-- Check if VALUESERIESID exists
	INSERT INTO #ERROR
		SELECT	 tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255)) 
				,'ValueSeriesID doesnt exist'
		FROM [load].tfValues tfV
		WHERE tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID NOT IN (SELECT dVS.FactoryID + '_' + dVS.ProductLineID + '_' + dVS.ProductID + '_' + dVS.ValueSeriesID  FROM dbo.sx_pf_dValueSeries dVS)
				AND tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255)) NOT IN (SELECT Identifier1 FROM #ERROR)
				AND (@FactoryID = '' OR tfV.FactoryID = @FactoryID)
				AND (@ProductLineID = '' OR tfV.ProductLineID = @ProductLineID)
				AND	(@ProductID = '' OR tfV.ProductID = @ProductID)
				AND	(@ValueSeriesID = '' OR tfV.ValueSeriesID = @ValueSeriesID)
				AND (@TimeID = 0 OR tfV.TimeID = @TimeID)

	-- Check if TIMEID exists
	INSERT INTO #ERROR
		SELECT DISTINCT tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255))  
						,'TimeID doesnt exist'
		FROM [load].tfValues tfV
			LEFT JOIN dbo.sx_pf_dProducts dP	ON tfV.FactoryID = dP.FactoryID AND tfV.ProductLineID = dP.ProductLineID AND tfV.ProductID = dP.ProductID
			LEFT JOIN dbo.sx_pf_dTime spdt		ON dP.ProductKey = spdt.ProductKey
		WHERE tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255)) NOT IN (SELECT Identifier1 FROM #ERROR)
				AND tfV.TimeID != spdt.TimeID
				AND (@FactoryID = '' OR tfV.FactoryID = @FactoryID)
				AND (@ProductLineID = '' OR tfV.ProductLineID = @ProductLineID)
				AND	(@ProductID = '' OR tfV.ProductID = @ProductID)
				AND	(@ValueSeriesID = '' OR tfV.ValueSeriesID = @ValueSeriesID)
				AND (@TimeID = 0 OR tfV.TimeID = @TimeID)

	-- Tabelle, um Werte zu identifizieren, die GLEICHE DIMENSIONEN_KOMBINATIONEN (Factory/ProductLine/Product/ValueSeries/TimeID) haben
	IF OBJECT_ID('tempdb..#DOUBLE') IS NOT NULL DROP TABLE #DOUBLE
	CREATE TABLE #DOUBLE	
			(	 FactoryID			NVARCHAR (255)
				,ProductLineID		NVARCHAR (255)
				,ProductID			NVARCHAR (255)
				,ValueSeriesID		NVARCHAR (255)
				,TimeID				NVARCHAR (255)
				,FlagFormular		NVARCHAR (255)
				,FlagInt			NVARCHAR (255)
				,FlagText			NVARCHAR (255)
				,FlagComment		NVARCHAR (255)
				,Identifier1		NVARCHAR (255)
				,Identifier2		NVARCHAR (255)
				,[Count]			INT						)
		INSERT INTO #DOUBLE
			SELECT	 tfV.FactoryID,tfV.ProductLineID,tfV.ProductID,tfV.ValueSeriesID,tfV.TimeID
					,IIF(tfV.ValueFormula = '','0','1')
					,IIF(tfV.ValueInt = '','0','1')
					,IIF(tfV.ValueText = '','0','1')
					,IIF(tfV.ValueComment = '','0','1')
					,tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255))
					,tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID + '_' + CAST(tfV.TimeID AS NVARCHAR(255)) 
					+ '_' + IIF(tfV.ValueFormula = '','0','1')  + IIF(tfV.ValueComment = '','0','1') + IIF(tfV.ValueInt = '','0','1')  + IIF(tfV.ValueText = '','0','1') 
					,COUNT(tfV.TimeID)
			FROM [load].tfValues tfV
			WHERE tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255)) NOT IN (SELECT Identifier1 FROM #ERROR) 
			GROUP BY tfV.FactoryID,tfV.ProductLineID,tfV.ProductID,tfV.ValueSeriesID,tfV.TimeID
					,IIF(tfV.ValueFormula = '','0','1')
					,IIF(tfV.ValueInt = '','0','1')
					,IIF(tfV.ValueText = '','0','1')
					,IIF(tfV.ValueComment = '','0','1')
					,tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255))
					+ '_' + IIF(tfV.ValueFormula = '','0','1')  + IIF(tfV.ValueComment = '','0','1') + IIF(tfV.ValueInt = '','0','1')  + IIF(tfV.ValueText = '','0','1') 

	-- Check if DOUBLE VALUES exist
	INSERT INTO #ERROR
		SELECT	 d.Identifier2
				,'Dimension in double use'
		FROM #DOUBLE d
		WHERE d.[Count] > 1

	-- Check if VALUETYPE matches
	INSERT INTO #ERROR
		SELECT 	tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID + '_' + CAST(tfV.TimeID AS NVARCHAR(255)) 
				+ '_' + IIF(tfV.ValueFormula = '','0','1')  + IIF(tfV.ValueComment = '','0','1') + IIF(tfV.ValueInt = '','0','1')  + IIF(tfV.ValueText = '','0','1') 
				,IIF(IIF(tfV.ValueInt = '','0','1')  + IIF(tfV.ValueText = '','0','1') = '10','Value type is not numeric','Value type is not string')
		FROM [load].tfValues tfV
			LEFT JOIN dbo.sx_pf_dValueSeries dVS ON tfV.FactoryID = dVS.FactoryID AND tfV.ProductLineID = dVS.ProductLineID AND tfV.ProductID = dVS.ProductID AND tfV.ValueSeriesID = dVS.ValueSeriesID 
		WHERE tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255)) 
		  			 NOT IN (SELECT Identifier1 FROM #ERROR) 
			AND	tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255)) 
				+ '_' + IIF(tfV.ValueFormula = '','0','1')  + IIF(tfV.ValueComment = '','0','1') + IIF(tfV.ValueInt = '','0','1')  + IIF(tfV.ValueText = '','0','1') 
		  			 NOT IN (SELECT Identifier1 FROM #ERROR) 
			AND IIF(tfV.ValueInt = '','0','1') != dVS.[IsNumeric]

	-- SELECT * FROM #ERROR

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
		FROM	[load].tfValues tfV
		WHERE	(@FactoryID = '' OR tfV.FactoryID = @FactoryID)
		  AND 	(@ProductLineID = '' OR tfV.ProductLineID = @ProductLineID)
		  AND	(@ProductID = '' OR tfV.ProductID = @ProductID)
		  AND	(@ValueSeriesID = '' OR tfV.ValueSeriesID = @ValueSeriesID)
		  AND   (@TimeID = 0 OR tfV.TimeID = @TimeID)
				-- Identifier 1 or Identifier 2
		  AND	tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255)) 
		  		 NOT IN (SELECT Identifier1 FROM #ERROR) 
		  AND	tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID  + '_' + CAST(tfV.TimeID AS NVARCHAR(255)) 
				+ '_' + IIF(tfV.ValueFormula = '','0','1')  + IIF(tfV.ValueComment = '','0','1') + IIF(tfV.ValueInt = '','0','1')  + IIF(tfV.ValueText = '','0','1') 
		  		 NOT IN (SELECT Identifier1 FROM #ERROR) 

		-- SELECT * FROM #DATA

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
-- POST_ProductDataTableValues
	DECLARE MyCursor1 CURSOR STATIC FOR

		SELECT 	 tdl.ProductID
			,tdl.ProductLineID
			,tdl.FactoryID
			,tdl.IsIncrementalValuesFlag
			,''+LEFT(tdl.ValuesInBracketsCommaSeparated,LEN(tdl.ValuesInBracketsCommaSeparated)-1)+''
		FROM @ToDoList tdl

	OPEN MyCursor1
	FETCH MyCursor1 INTO @ProductID,@ProductLineID,@FactoryID, @IsIncrementalValuesFlag, @ValuesInBracketsCommaSeparated	
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
	FETCH MyCursor1 INTO @ProductID,@ProductLineID,@FactoryID, @IsIncrementalValuesFlag, @ValuesInBracketsCommaSeparated	
	END
	CLOSE MyCursor1
	DEALLOCATE MyCursor1

-- Schreiben in die Fehlertabelle tdImportErrors
	DECLARE MyCursor2 CURSOR STATIC FOR

		SELECT DISTINCT tfV.ProductID,tfV.ProductLineID,tfV.FactoryID,tfV.ValueSeriesID,tfV.TimeID,tfV.ValueFormula,tfV.ValueInt,tfV.ValueText,tfV.ValueComment,tfV.Source,tfV.SourceTimeStamp,e.ErrorMessage
		FROM #Error e
			LEFT JOIN [load].tfValues tfV 
				ON e.Identifier1 = (tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID + '_' + CAST(tfV.TimeID AS NVARCHAR(255))) 
					OR e.Identifier1 = (tfV.FactoryID + '_' + tfV.ProductLineID + '_' + tfV.ProductID + '_' + tfV.ValueSeriesID + '_' + CAST(tfV.TimeID AS NVARCHAR(255)) + '_' + IIF(tfV.ValueFormula = '','0','1') + IIF(tfV.ValueComment = '','0','1') + IIF(tfV.ValueInt = '','0','1')  + IIF(tfV.ValueText = '','0','1') )
	OPEN MyCursor2
	FETCH MyCursor2 INTO @ProductID,@ProductLineID,@FactoryID,@ValueSeriesID,@TimeID,@ValueFormula,@ValueInt,@ValueText,@ValueComment,@Source,@SourceTimeStamp,@ErrorMessage
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXECUTE [control].[sp_tdImportErrors] @ProductID,@ProductLineID,@FactoryID,@ValueSeriesID,@TimeID,@ValueFormula,@ValueInt,@ValueText,@ValueComment,@Source,@SourceTimeStamp,@ErrorMessage

	FETCH MyCursor2 INTO @ProductID,@ProductLineID,@FactoryID,@ValueSeriesID,@TimeID,@ValueFormula,@ValueInt,@ValueText,@ValueComment,@Source,@SourceTimeStamp,@ErrorMessage
	END
	CLOSE MyCursor2
	DEALLOCATE MyCursor2

-------------------------------------------------------------------------------------------------------------------
GO
GRANT EXECUTE ON OBJECT ::[import].[sp_POST_fValuesPDTV] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[import].[sp_POST_fValuesPDTV] TO pf_PlanningFactoryService;
GO