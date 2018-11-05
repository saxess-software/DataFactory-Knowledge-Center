
/*
Author: 	Mandy Hauck
Created: 	2018/11
Summary:	Delete all or specified ValueSeries

	EXEC [control].[spDeleteValueSeries] 'SQL','','3','',''
	SELECT * FROM dbo.sx_pf_dValueSeries
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[spDeleteValueSeries]') AND type in (N'P', N'PC'))
DROP PROCEDURE [control].[spDeleteValueSeries]
GO

CREATE PROCEDURE [control].[spDeleteValueSeries]		
					(		@Username			NVARCHAR(255) = '',
							@FactoryID			NVARCHAR(255) = '',
							@ProductLineID		NVARCHAR(255) = '',
							@ProductID			NVARCHAR(255) = '',
							@ValueSerieID		NVARCHAR(255) = ''		)
AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
	-- Procedure specific
	DECLARE @RC						BIGINT			= 0
	
	-- API log
	DECLARE @TransactUsername		NVARCHAR(255)	= N'';
	DECLARE @ProcedureName			NVARCHAR(255)	= OBJECT_SCHEMA_NAME(@@PROCID) + N'.' + OBJECT_NAME(@@PROCID);
	DECLARE @EffectedRows			INT 			= 0;						
	DECLARE @ResultCode				INT 			= 501;						
	DECLARE @TimestampCall			DATETIME 		= CURRENT_TIMESTAMP;
	DECLARE @Comment				NVARCHAR(2000) 	= N'';
	DECLARE @ParameterString		NVARCHAR(MAX)	= N''''
													+ ISNULL(@Username		, N'NULL')	+ N''','''	
													+ ISNULL(@FactoryID		, N'NULL')	+ N''','''
													+ ISNULL(@ProductLineID	, N'NULL')	+ N''','''
													+ ISNULL(@ProductID		, N'NULL')	+ N''','''
													+ ISNULL(@ValueSerieID	, N'NULL')	+ N''','''
													+ N'''';
													
-------------------------------------------------------------------------------------------------------------------
-- ##### GENERAL CHECKS ###########
BEGIN TRY
	BEGIN TRANSACTION [spDeleteValueSeries];
	
	-- Determine transaction user
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);
	
	IF @TransactUsername  = N'403' 
		BEGIN
			SET @ResultCode = 403;
			RAISERROR('Transaction user don`t exists', 16, 10);
		END;
													
-------------------------------------------------------------------------------------------------------------------
-- ##### SELECT ###########
DECLARE MyCursor CURSOR FOR

	SELECT  dVS.FactoryID,dVS.ProductLineID,dVS.ProductID,dVS.ValueSeriesID
	FROM	dbo.sx_pf_dValueSeries dVS
	WHERE	dVS.FactoryID NOT IN ('ZT') 
		AND	(@FactoryID = '' OR dVS.FactoryID = @FactoryID)
		AND (@ProductLineID = '' OR dVS.ProductLineID = @ProductLineID)
		AND (@ProductID = '' OR dVS.ProductID = @ProductID)
		AND (@ValueSerieID = '' OR dVS.ValueSeriesID = @ValueSerieID)

OPEN MyCursor
FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID,@ValueSerieID
WHILE @@FETCH_STATUS = 0
BEGIN
	EXECUTE @RC = [dbo].[sx_pf_DELETE_ValueSerie] @Username
	                                             ,@FactoryID
	                                             ,@ProductLineID
	                                             ,@ProductID
	                                             ,@ValueSerieID
	
		PRINT @RC
FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID,@ValueSerieID
END
CLOSE MyCursor
DEALLOCATE MyCursor
			
-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode = 200

	COMMIT TRANSACTION [spDeleteValueSeries];
END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION [spDeleteValueSeries];		

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
GRANT EXECUTE ON OBJECT ::[control].[spDeleteValueSeries]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[control].[spDeleteValueSeries]  TO pf_PlanningFactoryService;
GO















