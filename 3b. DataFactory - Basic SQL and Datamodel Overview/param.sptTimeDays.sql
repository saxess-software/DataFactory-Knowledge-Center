
/*
Author: 	Mandy Hauck
Created: 	2018/10
Summary:	This procedure fills table param.tTimeDays and states if TimeID is classified as Actual or Budget
	EXEC [param].[sptTimeDays] 'SQL','20180901','20181130'
	SELECT * FROM param.tTimeDays
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[param].[sptTimeDays]') AND type in (N'P', N'PC'))
DROP PROCEDURE [param].[sptTimeDays]
GO

CREATE PROCEDURE [param].[sptTimeDays]		
						(		@Username			NVARCHAR(255),
								@StartDate			DATETIME = '',
								@EndDate			DATETIME = ''		)
AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
-- API log
	DECLARE @TransactUsername		NVARCHAR(255)	= N'';
	DECLARE @ProcedureName			NVARCHAR(255)	= OBJECT_SCHEMA_NAME(@@PROCID) + N'.' + OBJECT_NAME(@@PROCID);
	DECLARE @EffectedRows			INT 			= 0;						
	DECLARE @ResultCode				INT 			= 501;						
	DECLARE @TimestampCall			DATETIME 		= CURRENT_TIMESTAMP;
	DECLARE @Comment				NVARCHAR(2000) 	= N'';
	DECLARE @ParameterString		NVARCHAR(MAX)	= N''''
													+ ISNULL(@Username		, N'NULL')	+ N''','''	
													+ ISNULL(CAST(YEAR(@StartDate)* 10000 + MONTH(@StartDate)*100 + Day(@StartDate) AS NVARCHAR(255))		, N'NULL')	+ N''','''
													+ ISNULL(CAST(YEAR(@EndDate)* 10000 + MONTH(@EndDate)*100 + Day(@EndDate) AS NVARCHAR(255))		, N'NULL')	+ N''','''
													+ N'''';
													
-------------------------------------------------------------------------------------------------------------------
-- ##### GENERAL CHECKS ###########
BEGIN TRY
	BEGIN TRANSACTION [sptTimeDays];
	
	-- Determine transaction user
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);
	
	IF @TransactUsername  = N'403' 
		BEGIN
			SET @ResultCode = 403;
			RAISERROR('Transaction user don`t exists', 16, 10);
		END;

-------------------------------------------------------------------------------------------------------------------
-- ##### TABLE create & drop ###########
BEGIN
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[param].[tTimeDays]') AND type in (N'U'))
	DROP TABLE [param].[tTimeDays]
	
	CREATE TABLE [param].[tTimeDays]
			(	Date_Datetime DATETIME
				,TimeID BIGINT
				,[dPlan>=tdy] NVARCHAR(255)
				,[dPlan>tdy] NVARCHAR(255)
				,[mPlan>=tdy] NVARCHAR(255)
				,[mPlan>tdy] NVARCHAR(255)		)	
END
-------------------------------------------------------------------------------------------------------------------
-- ##### SELECT ###########
WHILE @StartDate <= @EndDate
      BEGIN
             INSERT INTO [param].[tTimeDays]
				 SELECT		@StartDate
							,Year(@StartDate)* 10000 + MONTH(@StartDate)*100 + Day(@StartDate)
							,IIF((YEAR(@StartDate)* 10000 + MONTH(@StartDate)*100 + Day(@StartDate)) >= TRY_CAST((YEAR(GETDATE()) *10000 + MONTH(GETDATE()) *100 + DAY(GETDATE())) AS INTEGER),'PLAN','IST' )
							,IIF((YEAR(@StartDate)* 10000 + MONTH(@StartDate)*100 + Day(@StartDate)) > TRY_CAST((YEAR(GETDATE()) *10000 + MONTH(GETDATE()) *100 + DAY(GETDATE())) AS INTEGER),'PLAN','IST' )
							,IIF((YEAR(@StartDate)* 10000 + MONTH(@StartDate)*100) >= TRY_CAST((YEAR(GETDATE()) *10000 + MONTH(GETDATE()) *100) AS INTEGER),'PLAN','IST' )
							,IIF((YEAR(@StartDate)* 10000 + MONTH(@StartDate)*100) > TRY_CAST((YEAR(GETDATE()) *10000 + MONTH(GETDATE()) *100) AS INTEGER),'PLAN','IST' )

             SET @StartDate = DATEADD(dd, 1, @StartDate)
      END
			
-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode = 200

	COMMIT TRANSACTION [sptTimeDays];
END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION [sptTimeDays];		

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
GRANT EXECUTE ON OBJECT ::[param].[sptTimeDays]	  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[param].[sptTimeDays]	  TO pf_PlanningFactoryService;
GO
													