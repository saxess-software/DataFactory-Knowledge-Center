
/*
Author: 	Heathcliff Power
Created: 	2018/01
Summary:	This template provides the layout used in procedures

	EXEC [dbo].[spProcedureName]
	SELECT * FROM dbo.TableName
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spProcedureName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spProcedureName]
GO

CREATE PROCEDURE [dbo].[spProcedureName]		
					(		@Username			NVARCHAR(255) = '',
							@FactoryID			NVARCHAR(255) = '',
							@ProductLineID		NVARCHAR(255) = ''		)
AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
	-- Procedure specific
	DECLARE @Variable1				NVARCHAR(255)	
	
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
													+ N'''';
													
-------------------------------------------------------------------------------------------------------------------
-- ##### GENERAL CHECKS ###########
BEGIN TRY
	BEGIN TRANSACTION [spProcedureName];
	
	-- Determine transaction user
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);
	
	IF @TransactUsername  = N'403' 
		BEGIN
			SET @ResultCode = 403;
			RAISERROR('Transaction user don`t exists', 16, 10);
		END;
													
-------------------------------------------------------------------------------------------------------------------
-- ##### TEMPORARY TABLES ###########
	-- tmp table to store something
	IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
	CREATE TABLE #tmp
			(	 ColumnInt					INT											NOT NULL
				,ColumnText1				NVARCHAR(255)	COLLATE DATABASE_DEFAULT	NOT NULL
				,ColumnText2				NVARCHAR(MAX)	COLLATE DATABASE_DEFAULT	NOT NULL
				,ColumnDate					DATETIME									NOT NULL
				,ColumnMoney				MONEY										NOT NULL)
		INSERT INTO #tmp
			SELECT 	*
			FROM 	dbo.sx_pf_dProducts
			WHERE 	FactoryID <> 'ZT' 
				AND ProductLineID = '1'

		-- SELECT * FROM #tmp

-------------------------------------------------------------------------------------------------------------------
-- ##### SELECT ###########
	SELECT	*
	FROM 	#tmp t
		LEFT JOIN dbo.sx_pf_fValues fV		-- this join is needed for something
			ON	t.ColumnText1 = fV.FactoryID
	WHERE	fV.FactoryID <> 'ZT' 	
		AND	(@FactoryID = '' OR tdPL.FactoryID = @FactoryID)
		AND   	(@ProductLineID = '' OR tdPL.ProductLineID = @ProductLineID)
			
-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode = 200

	COMMIT TRANSACTION [spProcedureName];
END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION [spProcedureName];		

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
GRANT EXECUTE ON OBJECT ::[dbo].[spProcedureName]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[dbo].[spProcedureName]  TO pf_PlanningFactoryService;
GO















