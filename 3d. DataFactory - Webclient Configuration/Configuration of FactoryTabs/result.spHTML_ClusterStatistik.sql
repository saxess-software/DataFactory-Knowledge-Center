
/*
Author: 	Gerd Tautenhahn
Created: 	2018/10
Summary:	Create HTML page giving information on cluster statistics based on SQL Query results
	EXEC [result].[spHTML_ClusterStatistik] 'SQL','',''
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[result].[spHTML_ClusterStatistik]') AND type in (N'P', N'PC'))
DROP PROCEDURE [result].[spHTML_ClusterStatistik]
GO

CREATE PROCEDURE [result].[spHTML_ClusterStatistik]		
					(		@Username			NVARCHAR(255),
							@FactoryID			NVARCHAR(255),
							@ProductLineID		NVARCHAR(255)		)
AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
	-- Procedure specific
	DECLARE @FactoryCount			INT				= 0
	DECLARE @ProductlineCount		INT				= 0
	DECLARE @ProductCount			INT				= 0
	
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
	BEGIN TRANSACTION [spHTML_ClusterStatistik];

	-- NULL Protection
	IF @Username		IS NULL SET @Username	= N'';
	IF @FactoryID		IS NULL SET @FactoryID	= N'';
	IF @ProductlineID	IS NULL SET @FactoryID	= N'';
	
	-- Determine transaction user
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);
	
	IF @TransactUsername  = N'403' 
		BEGIN
			SET @ResultCode = 403;
			RAISERROR('Transaction user don`t exists', 16, 10);
		END;

-------------------------------------------------------------------------------------------------------------------
-- ##### SELECT ###########

	SELECT @FactoryCount		= COUNT(FactoryID)		FROM dbo.sx_pf_dFactories		WHERE FactoryID <> 'ZT'
	SELECT @ProductlineCount	= COUNT(ProductlineID)	FROM dbo.sx_pf_dProductLines	WHERE FactoryID <> 'ZT'
	SELECT @ProductCount		= COUNT(ProductID)		FROM dbo.sx_pf_dProducts		WHERE FactoryID <> 'ZT'

				SELECT '<html>' AS Content
	UNION ALL	SELECT '<body>'
	UNION ALL	SELECT 'Dieses Cluster enth‰lt:</br>'
	UNION ALL	SELECT CAST(@FactoryCount		AS NVARCHAR(255)) + ' Fabriken </br>'
	UNION ALL	SELECT CAST(@ProductlineCount	AS NVARCHAR(255)) + ' Produktlinien </br>'
	UNION ALL	SELECT CAST(@ProductCount		AS NVARCHAR(255)) + ' Produkte </br>'
	UNION ALL	SELECT 'auﬂerhalb der Systemfabrik ''ZT'' </br>'
	UNION ALL	SELECT '</body>'
	UNION ALL	SELECT '</html>'

		SET @EffectedRows = +@@ROWCOUNT

-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode = 200

	COMMIT TRANSACTION [spHTML_ClusterStatistik];
END TRY
BEGIN CATCH
	DECLARE @Error_state INT = ERROR_STATE();
	SET @Comment = ERROR_MESSAGE();

	ROLLBACK TRANSACTION [spHTML_ClusterStatistik];		

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
GRANT EXECUTE ON OBJECT ::[result].[spHTML_ClusterStatistik]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[result].[spHTML_ClusterStatistik]  TO pf_PlanningFactoryService;
GO


