
/*
Stefan Lindenlaub
2018/01
Import User from load.trUser
	EXEC [import].[sp_POST_rUser] 'SQL','',''
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[import].[sp_POST_rUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [import].[sp_POST_rUser]
GO

CREATE PROCEDURE [import].[sp_POST_rUser]
			     (  
					@UserName AS NVARCHAR(255)
				   ,@PostUserName AS NVARCHAR(255)
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
			+ ISNULL(@Source								, N'NULL')			 + N'''';
	DECLARE @Comment			 NVARCHAR(2000) = N'';		

	DECLARE @PersonSurname		AS NVARCHAR(255)
	DECLARE @PersonFirstName	AS NVARCHAR(255)
	DECLARE @EMail				AS NVARCHAR(255)
	DECLARE @LDAPIP				AS NVARCHAR(255)
	DECLARE @Status				AS NVARCHAR(255)
	-------------------------------------------------------------------------------------------------------------------
	-- ##### DETERMINE TRANSACTION USER ###########
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);

	-------------------------------------------------------------------------------------------------------------------
	-- ##### TEMPORARY TABLES ###########
	IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
	CREATE TABLE #tmp 
			(	 UserName		 NVARCHAR(255)
				,PersonSurname	 NVARCHAR(255)
				,PersonFirstName NVARCHAR(255)
				,EMail			 NVARCHAR(255)
				,LDAPIP			 NVARCHAR(255)
				,Status			 NVARCHAR(255))

	INSERT INTO #tmp
		SELECT   trU.UserName
				,trU.PersonSurname
				,trU.PersonFirstName
				,trU.EMail		
				,trU.LDAPIP		
				,trU.Status		
		FROM	load.trUser trU
		WHERE	(@PostUserName = '' OR trU.UserName = @PostUserName)
		  AND   (@Source = '' OR trU.Source = @Source)
		  AND	trU.UserName <> @TransactUsername

	-------------------------------------------------------------------------------------------------------------------
	-- ##### POST ###########
	DECLARE MyCursor CURSOR FOR
		SELECT *
		FROM #tmp t
	OPEN MyCursor
	FETCH MyCursor INTO @PostUserName,@PersonSurname,@PersonFirstName,@EMail,@LDAPIP,@Status
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXECUTE @ResultCode = [dbo].[sx_pf_POST_User]
				 @UserName				
				,@PostUserName
				,@PersonSurname	
				,@PersonFirstName
				,@EMail			
				,@LDAPIP			
				,@Status			

		Print @ResultCode
	FETCH MyCursor INTO @PostUserName,@PersonSurname,@PersonFirstName,@EMail,@LDAPIP,@Status
	END
	CLOSE MyCursor
	DEALLOCATE MyCursor

	SET @ResultCode = 200;
	EXEC dbo.sx_pf_pPOST_API_LogEntry @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;
	RETURN @ResultCode;

END;

-------------------------------------------------------------------------------------------------------------------
GO
