
/*
Author: 	Mandy Hauck
Created: 	2018/11
Summary:	Delete all or specified Products

	EXEC [control].[spDeleteProducts] 'SQL','','','2'
	SELECT * FROM dbo.sx_pf_dProducts
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[spDeleteProducts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [control].[spDeleteProducts]
GO

CREATE PROCEDURE [control].[spDeleteProducts]		
					(		@Username			NVARCHAR(255) = '',
							@FactoryID			NVARCHAR(255) = '',
							@ProductLineID		NVARCHAR(255) = '',
							@ProductID			NVARCHAR(255) = ''		)
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
													+ N'''';
													
-------------------------------------------------------------------------------------------------------------------
-- ##### GENERAL CHECKS ###########
BEGIN TRY
	BEGIN TRANSACTION [spDeleteProducts];
	
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

	SELECT  dP.FactoryID,dP.ProductLineID,dP.ProductID
	FROM	dbo.sx_pf_dProducts dP
	WHERE	dP.FactoryID NOT IN ('ZT') 
		AND	(@FactoryID = '' OR dP.FactoryID = @FactoryID)
		AND (@ProductLineID = '' OR dP.ProductLineID = @ProductLineID)
		AND (@ProductID = '' OR dP.ProductID = @ProductID)

OPEN MyCursor
FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
	EXECUTE @RC = [dbo].[sx_pf_DELETE_Product]	 @Username
												,@FactoryID
												,@ProductLineID
												,@ProductID
		PRINT @RC
FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID
END
CLOSE MyCursor
DEALLOCATE MyCursor
			
-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode = 200

	COMMIT TRANSACTION [spDeleteProducts];
END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION [spDeleteProducts];		

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
GRANT EXECUTE ON OBJECT ::[control].[spDeleteProducts]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[control].[spDeleteProducts]  TO pf_PlanningFactoryService;
GO















