
/*

Mandy Hauck, Stefan Lindenlaub
2018/04

Import all values from load.tdFactories with specific load-procedure as source

EXEC [import].[sp_POST_dFactories] 'SQL','',''
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[import].[sp_POST_dFactories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [import].[sp_POST_dFactories]
GO

CREATE PROCEDURE [import].[sp_POST_dFactories]
				(  
				   @Username AS NVARCHAR(255)
				  ,@FactoryID AS NVARCHAR(255)
				  ,@Source AS NVARCHAR(255)
				)

AS

BEGIN
	SET NOCOUNT ON;

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
			+ ISNULL(@Source			, N'NULL')			 + N'''';
	DECLARE @Comment			 NVARCHAR(2000) = N'';					

	DECLARE @NameShort			AS NVARCHAR(255)
	DECLARE @NameLong			AS NVARCHAR(255)
	DECLARE @CommentUser		AS NVARCHAR(MAX)
	DECLARE @CommentDev			AS NVARCHAR(255)
	DECLARE @ResponsiblePerson	AS NVARCHAR(255)
	DECLARE @ImageName			AS NVARCHAR(255)
	
	-------------------------------------------------------------------------------------------------------------------
	-- ##### DETERMINE TRANSACTION USER ###########
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);
	-------------------------------------------------------------------------------------------------------------------
	-- ##### TEMPOARY TABLES ###########
	IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
	CREATE TABLE #tmp 
				(		 FactoryID			NVARCHAR(255)
						,NameShort			NVARCHAR(255)
						,NameLong			NVARCHAR(255)
						,CommentUser		NVARCHAR(255)
						,CommentDev			NVARCHAR(255)
						,ResponsiblePerson	NVARCHAR(255)
						,ImageName			NVARCHAR(255))
	INSERT INTO #tmp
		SELECT tdF.FactoryID,
			   tdF.NameShort,
			   tdF.NameLong,
			   tdF.CommentUser,
			   tdF.CommentDev,
			   tdF.ResponsiblePerson,
			   tdF.ImageName 
		FROM   load.tdFactories tdF
		WHERE	(@FactoryID = '' OR tdF.FactoryID = @FactoryID)
		AND		(@Source = '' OR tdF.Source = @Source) 

	-------------------------------------------------------------------------------------------------------------------
	-- ##### POST ###########
	DECLARE MyCursor CURSOR FOR
		SELECT *
		FROM #tmp t
	OPEN MyCursor
	FETCH MyCursor INTO @FactoryID,@NameShort,@NameLong,@CommentUser,@CommentDev,@ResponsiblePerson,@ImageName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXECUTE @ResultCode = [dbo].[sx_pf_POST_Factory]
				 @Username			--@Username
				,@FactoryID			--@FactoryID
				,@NameShort			--@NameShort
				,@NameLong			--@NameLong
				,@CommentUser		--@CommentUser
				,@CommentDev		--@CommentDev
				,@ResponsiblePerson	--@ResponsiblePerson
				,@ImageName			--@ImageName	
		Print @ResultCode
	FETCH MyCursor INTO @FactoryID,@NameShort,@NameLong,@CommentUser,@CommentDev,@ResponsiblePerson,@ImageName
	END
	CLOSE MyCursor
	DEALLOCATE MyCursor
	
	SET @ResultCode = 200;
	EXEC dbo.sx_pf_pPOST_API_LogEntry @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;
	RETURN @ResultCode;
END
-------------------------------------------------------------------------------------------------------------------
GO
