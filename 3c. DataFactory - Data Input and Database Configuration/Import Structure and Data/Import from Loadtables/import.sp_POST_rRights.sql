
/*
Mandy Hauck, Stefan Lindenlaub
2018/04

Import rights from loadtable

Testcall
EXEC [import].[sp_POST_rRights] 'SQL', '','',''
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[import].[sp_POST_rRights]') AND type in (N'P', N'PC'))
DROP PROCEDURE [import].[sp_POST_rRights]
GO

CREATE PROCEDURE [import].[sp_POST_rRights]
			( 
				@Username AS NVARCHAR(255)
			   ,@PostUserName AS NVARCHAR(255)
			   ,@Right AS NVARCHAR(255)
			   ,@Source AS NVARCHAR(255)
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
			+ ISNULL(@Username								, N'NULL')			 + N''',''' 
			+ ISNULL(@PostUserName							, N'NULL')			 + N''','''
			+ ISNULL(@Right									, N'NULL')			 + N''','''
			+ ISNULL(@Source								, N'NULL')			 + N'''';
	DECLARE @Comment			 NVARCHAR(2000) = N'';		
			

	DECLARE @FactoryID				AS NVARCHAR(255)  = ''
	DECLARE @ProductLineID			AS NVARCHAR(255)  = ''
	DECLARE @ProductID				AS NVARCHAR(255)  = ''
	DECLARE	@ReadCommentMandatory   AS INT 	= ''
	DECLARE @WriteCommentMandatory  AS INT	= ''

	-------------------------------------------------------------------------------------------------------------------
	-- ##### DETERMINE TRANSACTION USER ###########
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);
	-------------------------------------------------------------------------------------------------------------------
	-- ##### TEMPORARY TABLES ###########
	IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
		CREATE TABLE #tmp 
						(	 UserName		 NVARCHAR(255)
							,FactoryID		 NVARCHAR(255)
							,ProductLineID   NVARCHAR(255)
							,ProductID		 NVARCHAR(255)
							,[Right]		 NVARCHAR(255)
							,ReadCommentMandatory INT
							,WriteCommentMandatory INT	 )
		INSERT INTO #tmp
			SELECT   trR.UserName		 
					,trR.FactoryID		 
					,trR.ProductLineID  
					,trR.ProductID		 
					,trR.[Right]		 
					,trR.ReadCommentMandatory
					,trR.WriteCommentMandatory
			FROM	load.trRights trR
			WHERE	(@PostUserName = '' OR trR.UserName = @PostUserName)
			AND 	(@Right = '' OR trR.[Right] = @Right)
			AND 	(@Source = '' OR trR.Source = @Source)   
			AND		trR.UserName <> @TransactUsername


	-------------------------------------------------------------------------------------------------------------------
	-- ##### POST ###########
	DECLARE MyCursor CURSOR FOR
		SELECT * 
		FROM #tmp t
	OPEN MyCursor
	FETCH MyCursor INTO @PostUserName, @FactoryID, @ProductLineID, @ProductID, @Right, @ReadCommentMandatory, @WriteCommentMandatory
	WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE @ResultCode = [dbo].[sx_pf_POST_Right]
			 @Username
			,@PostUserName				
			,@FactoryID				
			,@ProductLineID						
			,@Right					
			,@ReadCommentMandatory 
			,@WriteCommentMandatory

	Print @ResultCode
	FETCH MyCursor INTO @PostUserName, @FactoryID, @ProductLineID, @ProductID, @Right, @ReadCommentMandatory, @WriteCommentMandatory
	END
	CLOSE MyCursor
	DEALLOCATE MyCursor

	SET @ResultCode = 200;
	EXEC dbo.sx_pf_pPOST_API_LogEntry @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;
	RETURN @ResultCode;

END;

-------------------------------------------------------------------------------------------------------------------
GO
