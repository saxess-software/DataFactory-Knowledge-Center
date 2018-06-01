/*
Mandy Hauck, Stefan Lindenlaub
2018/06
Import all values from load.tfValues with specific load-procedure as source
	 EXEC [import].[sp_POST_fValues] 'SQL','','','','',0,''
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[import].[spPOST_fValues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [import].[spPOST_fValues]
GO

CREATE PROCEDURE [import].[spPOST_fValues]
				(		@Username		AS NVARCHAR(255),
						@FactoryID		AS NVARCHAR(255),
						@ProductlineID	AS NVARCHAR(255),
						@ProductID		AS NVARCHAR(255),
						@ValueSeriesID	AS NVARCHAR(255),
						@TimeID			AS INT,
						@Source			AS NVARCHAR(255)		)
		   
AS

BEGIN
	SET NOCOUNT ON

	-------------------------------------------------------------------------------------------------------------------
	-- ##### VARIABLES ###########
	DECLARE @TimestampCall				DATETIME		= CURRENT_TIMESTAMP;
	DECLARE @ProcedureName				NVARCHAR(255)	= OBJECT_SCHEMA_NAME(@@PROCID) + N'.' + OBJECT_NAME(@@PROCID);
	DECLARE @ResultCode					INT				= 501;
	DECLARE @EffectedRows				INT				= 0;					
	DECLARE @TransactUsername			NVARCHAR(255)	= N'';
	DECLARE @ParameterString			NVARCHAR(MAX)	= N''''
														+ ISNULL(@Username							, N'NULL')	 + N''',''' 
														+ ISNULL(@FactoryID							, N'NULL')	 + N''','''
														+ ISNULL(@ProductLineID						, N'NULL')	 + N''','''
														+ ISNULL(@ProductID							, N'NULL')	 + N''','''
														+ ISNULL(@ValueSeriesID						, N'NULL')	 + N''','''
														+ ISNULL(TRY_CAST(@TimeID AS NVARCHAR(255))	, N'NULL')	 + N''','''
														+ ISNULL(@Source							, N'NULL')	 + N'''';
	DECLARE @Comment					NVARCHAR(2000)	= N'';	
	DECLARE @ValueFormula				NVARCHAR(255)
	DECLARE @ValueINT					INT
	DECLARE @ValueText					NVARCHAR(MAX)
	DECLARE @ValueComment				NVARCHAR(255)

	-------------------------------------------------------------------------------------------------------------------
	-- ##### DETERMINE TRANSACTION USER ###########
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);

	-------------------------------------------------------------------------------------------------------------------
	-- ##### TEMPORARY TABLES ###########
	IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
	CREATE TABLE #tmp 
		(	 ProductID		NVARCHAR(255)
			,ProductLineID	NVARCHAR(255)
			,FactoryID		NVARCHAR(255)
			,ValueSeriesID	NVARCHAR(255)
			,TimeID			INT
			,ValueFormula	NVARCHAR(255)
			,ValueINT		INT
			,ValueText		NVARCHAR(MAX)
			,ValueComment	NVARCHAR(255)		)

	INSERT INTO #tmp
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
		 AND    (@ProductLineID = '' OR tfV.ProductLineID = @ProductLineID)
		 AND    (@ProductID = '' OR tfV.ProductID = @ProductID)
		 AND    (@ValueSeriesID = '' OR tfV.ValueSeriesID = @ValueSeriesID)
		 AND    (@TimeID = 0 OR tfV.TimeID = @TimeID)
		 AND    (@Source = '' OR tfV.Source = @Source)

	-------------------------------------------------------------------------------------------------------------------
	-- ##### POST ###########
	DECLARE MyCursor CURSOR FOR
		SELECT *
		FROM #tmp t
	OPEN MyCursor
	FETCH MyCursor INTO @ProductID,@ProductLineID,@FactoryID,@ValueSeriesID,@TimeID,@ValueFormula,@ValueINT,@ValueText,@ValueComment
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXECUTE @ResultCode = [dbo].[sx_pf_POST_Value]
				 @Username
				,@ProductID		
				,@ProductLineID	
				,@FactoryID		
				,@ValueSeriesID	
				,@TimeID			
				,@ValueFormula	
				,@ValueINT		
				,@ValueText		
				,@ValueComment	
										
		Print @ResultCode
	FETCH MyCursor INTO @ProductID,@ProductLineID,@FactoryID,@ValueSeriesID,@TimeID,@ValueFormula,@ValueINT,@ValueText,@ValueComment
	END
	CLOSE MyCursor
	DEALLOCATE MyCursor

	SET @ResultCode = 200;

	EXEC dbo.sx_pf_pPOST_API_LogEntry @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;

	RETURN @ResultCode;

END;

-------------------------------------------------------------------------------------------------------------------
GO
GRANT EXECUTE ON OBJECT ::[import].[spPOST_fValues] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[import].[spPOST_fValues] TO pf_PlanningFactoryService;
GO

