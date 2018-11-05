
/*
Author: 	Mandy Hauck
Created: 	2018/11
Summary:	Delete all or specified rights

	EXEC [control].[spDeleteRights] 'SQL','','',''
	SELECT * FROM dbo.sx_pf_rRights
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[spDeleteRights]') AND type in (N'P', N'PC'))
DROP PROCEDURE [control].[spDeleteRights]
GO

CREATE PROCEDURE [control].[spDeleteRights]		
					(		@Username			NVARCHAR(255) = '',
							@DeleteUserName		NVARCHAR(255) = '',
							@FactoryID			NVARCHAR(255) = '',
							@ProductLineID		NVARCHAR(255) = ''		)
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
													+ ISNULL(@Username						, N'NULL')	+ N''','''	
													+ ISNULL(@DeleteUserName				, N'NULL')	+ N''','''
													+ ISNULL(@FactoryID						, N'NULL')	+ N''','''
													+ ISNULL(@ProductLineID					, N'NULL')	+ N''','''
													+ N'''';
													
-------------------------------------------------------------------------------------------------------------------
-- ##### GENERAL CHECKS ###########
BEGIN TRY
	BEGIN TRANSACTION [spDeleteRights];
	
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

	SELECT  spvur.UserName,spvur.FactoryID,spvur.ProductLineID
	FROM	dbo.sx_pf_vUserRights spvur
	WHERE	(@DeleteUserName = '' OR spvur.UserName = @DeleteUserName)
		AND	(@FactoryID = '' OR spvur.FactoryID = @FactoryID)
		AND (@ProductLineID = '' OR spvur.ProductLineID = @ProductLineID)
		AND spvur.UserName <> ORIGINAL_LOGIN()				-- nicht den eigenen User löschen

OPEN MyCursor
FETCH MyCursor INTO @DeleteUserName,@FactoryID,@ProductLineID
WHILE @@FETCH_STATUS = 0
BEGIN
	EXECUTE @RC = [dbo].[sx_pf_DELETE_Right] @Username
	                                        ,@DeleteUserName
	                                        ,@FactoryID
	                                        ,@ProductLineID
	
		PRINT @RC
FETCH MyCursor INTO @DeleteUserName,@FactoryID,@ProductLineID
END
CLOSE MyCursor
DEALLOCATE MyCursor
			
-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode = 200

	COMMIT TRANSACTION [spDeleteRights];
END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION [spDeleteRights];		

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
GRANT EXECUTE ON OBJECT ::[control].[spDeleteRights]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[control].[spDeleteRights]  TO pf_PlanningFactoryService;
GO















