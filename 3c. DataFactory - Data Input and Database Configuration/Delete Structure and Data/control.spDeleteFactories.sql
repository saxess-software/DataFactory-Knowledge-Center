
/*
Author: 	Mandy Hauck
Created: 	2018/11
Summary:	Delete all or specified factories

	EXEC [control].[spDeleteFactories] 'SQL',''
	SELECT * FROM dbo.sx_pf_dFactories
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[spDeleteFactories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [control].[spDeleteFactories]
GO

CREATE PROCEDURE [control].[spDeleteFactories]		
					(		@Username			NVARCHAR(255) = '',
							@FactoryID			NVARCHAR(255) = ''		)
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
													+ N'''';
													
-------------------------------------------------------------------------------------------------------------------
-- ##### GENERAL CHECKS ###########
BEGIN TRY
	BEGIN TRANSACTION [spDeleteFactories];
	
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

	SELECT  dF.FactoryID
	FROM	dbo.sx_pf_dFactories dF
	WHERE	dF.FactoryID NOT IN ('ZT') 
		AND	(@FactoryID = '' OR dF.FactoryID = @FactoryID)

OPEN MyCursor
FETCH MyCursor INTO @FactoryID
WHILE @@FETCH_STATUS = 0
BEGIN
	EXECUTE @RC = [dbo].[sx_pf_Delete_Factory]	 @Username
												,@FactoryID
		PRINT @RC
FETCH MyCursor INTO @FactoryID
END
CLOSE MyCursor
DEALLOCATE MyCursor
			
-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode = 200

	COMMIT TRANSACTION [spDeleteFactories];
END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION [spDeleteFactories];		

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
GRANT EXECUTE ON OBJECT ::[control].[spDeleteFactories]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[control].[spDeleteFactories]  TO pf_PlanningFactoryService;
GO















