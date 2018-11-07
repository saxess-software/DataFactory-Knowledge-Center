
/*
Author: 	Heathcliff Power
Created: 	2018/11
Summary:	Initialisieren von DataFactory: Laden & Import der Struktur, Laden & Import der Werte

	EXEC [control].[spInitialisiereDataFactory] 'SQL','','','','',0
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[spInitialisiereDataFactory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [control].[spInitialisiereDataFactory]
GO

CREATE PROCEDURE [control].[spInitialisiereDataFactory]		
					(		@Username			NVARCHAR(255)	= '',
							@FactoryID			NVARCHAR(255)	= '',
							@ProductLineID		NVARCHAR(255)	= '',
							@ProductID			NVARCHAR(255)	= '',
							@ValueSeriesID		NVARCHAR(255)	= '',
							@TimeID				BIGINT			= 0		)
AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
	-- Procedure specific
	DECLARE @Source					NVARCHAR(255)	= OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)
	DECLARE @RC						BIGINT			= 0

	-- API log
	DECLARE @TransactUsername		NVARCHAR(255)	= N'';
	DECLARE @ProcedureName			NVARCHAR(255)	= OBJECT_SCHEMA_NAME(@@PROCID) + N'.' + OBJECT_NAME(@@PROCID);
	DECLARE @EffectedRows			INT 			= 0;						
	DECLARE @ResultCode				INT 			= 501;						
	DECLARE @TimestampCall			DATETIME 		= CURRENT_TIMESTAMP;
	DECLARE @Comment				NVARCHAR(2000) 	= N'';
	DECLARE @ParameterString		NVARCHAR(MAX)	= N''''
													+ ISNULL(@Username						, N'NULL')	+ N''','''	
													+ ISNULL(@FactoryID						, N'NULL')	+ N''','''
													+ ISNULL(@ProductLineID					, N'NULL')	+ N''','''
													+ ISNULL(@ProductID						, N'NULL')	+ N''','''
													+ ISNULL(@ValueSeriesID					, N'NULL')	+ N''','''
													+ ISNULL(CAST(@TimeID AS NVARCHAR(255))	, N'NULL')	+ N''','''
													+ N'''';
													
-------------------------------------------------------------------------------------------------------------------
-- ##### GENERAL CHECKS ###########
BEGIN TRY
	BEGIN TRANSACTION [spInitialisiereDataFactory];
	
	-- Determine transaction user
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);
	
	IF @TransactUsername  = N'403' 
		BEGIN
			SET @ResultCode = 403;
			RAISERROR('Transaction user don`t exists', 16, 10);
		END;

-------------------------------------------------------------------------------------------------------------------
-- ##### Load & Import all Factories ###########
BEGIN
	SET @Source = 'load.spdFactories'			

	PRINT 'Start LOAD ' + RIGHT(@Source,LEN(@Source)-CHARINDEX('.',@Source))	
		BEGIN
			EXEC @RC = [load].[spdFactories] @Username,@FactoryID
			PRINT @RC
		END

	PRINT 'Start IMPORT ' + RIGHT(@Source,LEN(@Source)-CHARINDEX('.',@Source))
		BEGIN
			EXEC @RC = [import].[spPOST_dFactories] @Username,@FactoryID,@Source	
			PRINT @RC 
		END
END

-------------------------------------------------------------------------------------------------------------------
-- ##### Load & Import Factory #1 ###########
BEGIN
	SET @Source = 'load.spdProductLines'

	PRINT 'Start LOAD ' + RIGHT(@Source,LEN(@Source)-CHARINDEX('.',@Source))	
		BEGIN
		EXEC @RC = [load].[spdProductLines] @Username,@FactoryID,@ProductLineID	
			PRINT @RC
		END

	PRINT 'Start IMPORT ' + RIGHT(@Source,LEN(@Source)-CHARINDEX('.',@Source))
		BEGIN
		EXEC @RC = [import].[spPOST_dProductlines] @Username,@FactoryID,@ProductLineID,@Source	
			PRINT @RC 
		END
END

-- Products
BEGIN
	SET @Source = 'load.spdProducts'

	PRINT 'Start LOAD ' + RIGHT(@Source,LEN(@Source)-CHARINDEX('.',@Source))	
		BEGIN
		EXEC @RC = [load].[spdProducts] @Username,@FactoryID,@ProductLineID,@ProductID	
			PRINT @RC
		END

	PRINT 'Start IMPORT ' + RIGHT(@Source,LEN(@Source)-CHARINDEX('.',@Source))
		BEGIN
		EXEC @RC = [import].[spPOST_dProducts] @Username,@FactoryID,@ProductLineID,@ProductID,@Source	
			PRINT @RC 
		END
END

-- Values
BEGIN
	SET @Source = 'load.spfValuesPDTV'

	PRINT 'Start LOAD ' + RIGHT(@Source,LEN(@Source)-CHARINDEX('.',@Source))	
		BEGIN
		EXEC @RC = [load].[spfValuesPDTV] @Username,@FactoryID,@ProductLineID,@ProductID,@ValueSeriesID,@TimeID	
			PRINT @RC
		END

	PRINT 'Start IMPORT ' + RIGHT(@Source,LEN(@Source)-CHARINDEX('.',@Source))
		BEGIN
		EXEC @RC = [import].[spPOST_fValuesPDTV] @Username,@FactoryID,@ProductlineID,@ProductID,@ValueSeriesID,@TimeID,@Source
			PRINT @RC 
		END
END

-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode		= 200	

	COMMIT TRANSACTION [spInitialisiereDataFactory];
END TRY
BEGIN CATCH
	DECLARE @Error_state INT = ERROR_STATE();
	SET @Comment = ERROR_MESSAGE();

	ROLLBACK TRANSACTION [spInitialisiereDataFactory];		

	IF @Error_state <> 10
	BEGIN
		SET @ResultCode = 500;		
		PRINT 'Rollback due to not executable command.';
	END
	ELSE IF @ResultCode IS NULL OR @ResultCode/100 = 2
	BEGIN
		SET @ResultCode = 500;	
	END;
END CATCH

EXEC dbo.sx_pf_pPOST_API_LogEntry @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;

RETURN @ResultCode;

-------------------------------------------------------------------------------------------------------------------
GO
GRANT EXECUTE ON OBJECT ::[control].[spInitialisiereDataFactory]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[control].[spInitialisiereDataFactory]  TO pf_PlanningFactoryService;
GO















