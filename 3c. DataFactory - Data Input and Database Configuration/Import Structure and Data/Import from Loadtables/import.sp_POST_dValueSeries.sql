/*
Stefan Lindenlaub
2018/04
Import ValueSeries from load.tdValueSeries

Textcall
	EXEC [import].[sp_POST_dValueSeries] 'SQL','','','','',''
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[import].[sp_POST_dValueSeries]') AND type in (N'P', N'PC'))
DROP PROCEDURE [import].[sp_POST_dValueSeries]
GO

CREATE PROCEDURE [import].[sp_POST_dValueSeries]
					(	 
						 @Username		 AS NVARCHAR(255)
						,@FactoryID       AS NVARCHAR(255)
						,@ProductlineID   AS NVARCHAR(255)
						,@ProductID		 AS NVARCHAR (255)
						,@ValueSeriesID	 AS NVARCHAR (255)
						,@Source		AS NVARCHAR(255)
					)		   

AS

BEGIN
	
	SET NOCOUNT ON

	-------------------------------------------------------------------------------------------------------------------
	-- ##### VARIABLES ###########
	DECLARE @TimestampCall		 DATETIME		= CURRENT_TIMESTAMP;
	DECLARE @ProcedureName		 NVARCHAR (255) = OBJECT_SCHEMA_NAME(@@PROCID) + N'.' + OBJECT_NAME(@@PROCID);
	DECLARE @ResultCode			 INT			= 501;
	DECLARE @EffectedRows		 INT			= 0;					
	DECLARE @TransactUsername	 NVARCHAR(255)	= N'';
	DECLARE @ParameterString	 NVARCHAR (MAX) = N''''
			+ ISNULL(@Username			, N'NULL')			 + N''',''' 
			+ ISNULL(@FactoryID			, N'NULL')			 + N''','''
			+ ISNULL(@ProductLineID		, N'NULL')			 + N''','''
			+ ISNULL(@ProductID			, N'NULL')			 + N''','''
			+ ISNULL(@ValueSeriesID		, N'NULL')			 + N''','''
			+ ISNULL(@Source			, N'NULL')			 + N'''';
	DECLARE @Comment			 NVARCHAR(2000) = N'';	

	DECLARE @RequestedValueSeriesNo		AS NVARCHAR (255)
	DECLARE @NameShort					AS NVARCHAR (255)
	DECLARE @NameLong					AS NVARCHAR (255)
	DECLARE @CommentUser				AS NVARCHAR (255)
	DECLARE @CommentDev					AS NVARCHAR (255)
	DECLARE @ImageName					AS NVARCHAR (255)
	DECLARE @IsNumeric					AS NVARCHAR (255)
	DECLARE @VisibilityLevel			AS NVARCHAR (255)
	DECLARE @ValueSource				AS NVARCHAR (255)
	DECLARE @ValueListID				AS NVARCHAR (255)
	DECLARE @ValueFormatID				AS NVARCHAR (255)
	DECLARE @Unit						AS NVARCHAR (255)
	DECLARE @Scale						AS NVARCHAR (255)
	DECLARE @Effect						AS NVARCHAR (255)
	DECLARE @EffectParameter			AS NVARCHAR (255)

	-------------------------------------------------------------------------------------------------------------------
	-- ##### DETERMINE TRANSACTION USER ###########
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);

	-------------------------------------------------------------------------------------------------------------------
	-- ##### TEMPORARY TABLES ###########
	IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
	CREATE TABLE #tmp 
		(		ProductID				NVARCHAR (255)
			   ,ProductLineID			NVARCHAR (255)
			   ,FactoryID				NVARCHAR (255)
			   ,ValueSeriesID			NVARCHAR (255)
			   ,RequestedValueSeriesNo	NVARCHAR (255)
			   ,NameShort				NVARCHAR (255)
			   ,NameLong				NVARCHAR (255)
			   ,CommentUser				NVARCHAR (255)
			   ,CommentDev				NVARCHAR (255)
			   ,ImageName				NVARCHAR (255)
			   ,IsNumeric				NVARCHAR (255)
			   ,VisibilityLevel			NVARCHAR (255)
			   ,ValueSource				NVARCHAR (255)
			   ,ValueListID				NVARCHAR (255)
			   ,ValueFormatID			NVARCHAR (255)
			   ,Unit					NVARCHAR (255)
			   ,Scale					NVARCHAR (255)
			   ,Effect					NVARCHAR (255)
			   ,EffectParameter			NVARCHAR (255))

	INSERT INTO #tmp
		SELECT   tdVS.ProductID				
				,tdVS.ProductLineID			
				,tdVS.FactoryID				
				,tdVS.ValueSeriesID			
				,tdVS.ValueSeriesNo	
				,tdVS.NameShort				
				,tdVS.NameLong				
				,tdVS.CommentUser				
				,tdVS.CommentDev				
				,tdVS.ImageName				
				,tdVS.IsNumeric				
				,tdVS.VisibilityLevel			
				,tdVS.ValueSource				
				,tdVS.ValueListID				
				,tdVS.ValueFormatID			
				,tdVS.Unit					
				,tdVS.Scale					
				,tdVS.Effect					
				,tdVS.EffectParameter	
		FROM	load.tdValueSeries tdVS
		WHERE	(@FactoryID = '' OR tdVS.FactoryID = @FactoryID)
		 AND    (@ProductLineID = '' OR tdVS.ProductLineID = @ProductLineID)
		 AND    (@ProductID = '' OR tdVS.ProductID = @ProductID)
		 AND    (@ValueSeriesID = '' OR tdVS.ValueSeriesID = @ValueSeriesID)

	-------------------------------------------------------------------------------------------------------------------
	-- ##### POST ###########
	DECLARE MyCursor CURSOR FOR
		SELECT *
		FROM #tmp t
	OPEN MyCursor
	FETCH MyCursor INTO @ProductID,@ProductLineID,@FactoryID,@ValueSeriesID,@RequestedValueSeriesNo,@NameShort,@NameLong,@CommentUser,@CommentDev,@ImageName,@IsNumeric,@VisibilityLevel,@ValueSource,@ValueListID,@ValueFormatID,@Unit,@Scale,@Effect,@EffectParameter

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXECUTE @ResultCode = [dbo].[sx_pf_POST_ValueSerie]
				 @Username
				,@ProductID
				,@ProductLineID
				,@FactoryID
				,@ValueSeriesID
				,@RequestedValueSeriesNo
				,@NameShort
				,@NameLong
				,@CommentUser
				,@CommentDev
				,@ImageName
				,@IsNumeric
				,@VisibilityLevel
				,@ValueSource
				,@ValueListID
				,@ValueFormatID
				,@Unit
				,@Scale
				,@Effect
				,@EffectParameter				
		Print @ResultCode
	FETCH MyCursor INTO @ProductID,@ProductLineID,@FactoryID,@ValueSeriesID,@RequestedValueSeriesNo,@NameShort,@NameLong,@CommentUser,@CommentDev,@ImageName,@IsNumeric,@VisibilityLevel,@ValueSource,@ValueListID,@ValueFormatID,@Unit,@Scale,@Effect,@EffectParameter
	END
	CLOSE MyCursor
	DEALLOCATE MyCursor

	SET @ResultCode = 200;
	EXEC dbo.sx_pf_pPOST_API_LogEntry @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;
	RETURN @ResultCode;

END;
-------------------------------------------------------------------------------------------------------------------
GO

