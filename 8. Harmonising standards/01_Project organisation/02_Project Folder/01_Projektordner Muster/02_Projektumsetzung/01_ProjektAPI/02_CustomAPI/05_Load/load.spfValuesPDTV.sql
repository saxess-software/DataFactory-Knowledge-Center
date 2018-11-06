
/*
Author: 	Heathcliff Power
Created: 	2018/11
Summary:	Laden der Daten in Tabelle load.tfValues

	EXEC [load].[spfValuesPDTV] 'SQL','','','','',0
	SELECT * FROM load.tfValues
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[load].[spfValuesPDTV]') AND type in (N'P', N'PC'))
DROP PROCEDURE [load].[spfValuesPDTV]
GO

CREATE PROCEDURE [load].[spfValuesPDTV]		
					(		@Username			NVARCHAR(255) = '',
							@FactoryID			NVARCHAR(255) = '',
							@ProductLineID		NVARCHAR(255) = '',
							@ProductID			NVARCHAR(255) = '',
							@ValueSeriesID		NVARCHAR(255) = '',
							@TimeID				BIGINT = 0	)
AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
	-- Procedure specific
	DECLARE @Source					NVARCHAR(255)	= OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)

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
													
BEGIN TRY
	BEGIN TRANSACTION [spfValuesPDTV];
	
-------------------------------------------------------------------------------------------------------------------
-- ##### DELETE ###########
	DELETE FROM [load].[tfValues] WHERE SOURCE = @Source

-------------------------------------------------------------------------------------------------------------------
-- ##### INSERT ###########
	-- ValueSeries #1
	INSERT INTO [load].[tfValues]	
		SELECT 	 '<#NV>'						AS ProductID
				,'<#NV>'						AS ProductLineID
				,'<#NV>'						AS FactoryID
				,'<#NV>'						AS ValueSeriesID
				,'<#NV>'						AS TimeID
				,'<#NV>'						AS ValueFormular
				,0								AS ValueInt
				,'<#NV>'						AS ValueText
				,'<#NV>'						AS ValueComment
				,@Source						AS Source
				,GETDATE()						AS SourceTimeStamp
		FROM [dbo].[sx_pf_fValues]			-- Beispieltabelle mit Beispielfiltern
		WHERE	(@FactoryID = '' OR FactoryID = @FactoryID)
			AND	(@ProductLineID = '' OR ProductLineID = @ProductLineID)
			AND	(@ProductID = '' OR ProductID = @ProductID)
			AND	(@ValueSeriesID = '' OR ValueSeriesID = @ValueSeriesID)
			AND	(@TimeID = 0 OR TimeID = @TimeID)


			SET @EffectedRows	= @@ROWCOUNT

	-- ValueSeries #2
	INSERT INTO [load].[tfValues]	
		SELECT 	 '<#NV>'						AS ProductID
				,'<#NV>'						AS ProductLineID
				,'<#NV>'						AS FactoryID
				,'<#NV>'						AS ValueSeriesID
				,'<#NV>'						AS TimeID
				,'<#NV>'						AS ValueFormular
				,0								AS ValueInt
				,'<#NV>'						AS ValueText
				,'<#NV>'						AS ValueComment
				,@Source						AS Source
				,GETDATE()						AS SourceTimeStamp
		FROM [dbo].[sx_pf_fValues]			-- Beispieltabelle mit Beispielfiltern
		WHERE	(@FactoryID = '' OR FactoryID = @FactoryID)
			AND	(@ProductLineID = '' OR ProductLineID = @ProductLineID)
			AND	(@ProductID = '' OR ProductID = @ProductID)
			AND	(@ValueSeriesID = '' OR ValueSeriesID = @ValueSeriesID)
			AND	(@TimeID = 0 OR TimeID = @TimeID)

		SET @EffectedRows	= @EffectedRows + @@ROWCOUNT

-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode		= 200	

	COMMIT TRANSACTION [spfValuesPDTV];
END TRY
BEGIN CATCH
	DECLARE @Error_state INT = ERROR_STATE();
	SET @Comment = ERROR_MESSAGE();

	ROLLBACK TRANSACTION [spfValuesPDTV];		

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
GRANT EXECUTE ON OBJECT ::[load].[spfValuesPDTV]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[load].[spfValuesPDTV]  TO pf_PlanningFactoryService;
GO















