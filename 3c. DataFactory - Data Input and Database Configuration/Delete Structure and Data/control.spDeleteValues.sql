
/*
Author: 	Mandy Hauck
Created: 	2018/11
Summary:	Delete all or specified Values

	EXEC [control].[spDeleteValues] 'SQL','','','','',20190415
	SELECT * FROM dbo.sx_pf_fValues
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[spDeleteValues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [control].[spDeleteValues]
GO

CREATE PROCEDURE [control].[spDeleteValues]		
					(		@Username			NVARCHAR(255) = '',
							@FactoryID			NVARCHAR(255) = '',
							@ProductLineID		NVARCHAR(255) = '',
							@ProductID			NVARCHAR(255) = '',
							@ValueSerieID		NVARCHAR(255) = '',
	                        @TimeID				BIGINT = 0		)
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
													+ ISNULL(@FactoryID						, N'NULL')	+ N''','''
													+ ISNULL(@ProductLineID					, N'NULL')	+ N''','''
													+ ISNULL(@ProductID						, N'NULL')	+ N''','''
													+ ISNULL(@ValueSerieID					, N'NULL')	+ N''','''
													+ ISNULL(CAST(@TimeID AS NVARCHAR(255))	, N'NULL')	+ N''','''
													+ N'''';
													
-------------------------------------------------------------------------------------------------------------------
-- ##### GENERAL CHECKS ###########
BEGIN TRY
	BEGIN TRANSACTION [spDeleteValues];
	
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

	SELECT  fV.FactoryID,fV.ProductLineID,fV.ProductID,fV.ValueSeriesID,fV.TimeID
	FROM	dbo.sx_pf_fValues fV
	WHERE	fV.FactoryID NOT IN ('ZT') 
		AND	(@FactoryID = '' OR fV.FactoryID = @FactoryID)
		AND (@ProductLineID = '' OR fV.ProductLineID = @ProductLineID)
		AND (@ProductID = '' OR fV.ProductID = @ProductID)
		AND (@ValueSerieID = '' OR fV.ValueSeriesID = @ValueSerieID)
		AND (@TimeID = 0 OR fV.TimeID = @TimeID)

OPEN MyCursor
FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID,@ValueSerieID,@TimeID
WHILE @@FETCH_STATUS = 0
BEGIN
	EXECUTE @RC = [dbo].[sx_pf_DELETE_Value] @Username 
	                                        ,@FactoryID
	                                        ,@ProductLineID 
	                                        ,@ProductID 
	                                        ,@ValueSerieID 
	                                        ,@TimeID 
	
		PRINT @RC
FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID,@ValueSerieID,@TimeID
END
CLOSE MyCursor
DEALLOCATE MyCursor
			
-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode = 200

	COMMIT TRANSACTION [spDeleteValues];
END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION [spDeleteValues];		

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
GRANT EXECUTE ON OBJECT ::[control].[spDeleteValues]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[control].[spDeleteValues]  TO pf_PlanningFactoryService;
GO















