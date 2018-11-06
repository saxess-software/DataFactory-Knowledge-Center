
/*
Author: 	Heathcliff Power
Created: 	2018/11
Summary:	Laden der Daten in Tabelle load.tdFactories

	EXEC [load].[spdFactories] 'SQL',''
	SELECT * FROM [load].[tdFactories]
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[load].[spdFactories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [load].[spdFactories]
GO

CREATE PROCEDURE [load].[spdFactories]		
					(		@Username			NVARCHAR(255) = '',
							@FactoryID			NVARCHAR(255) = ''		)
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
													+ ISNULL(@Username		, N'NULL')	+ N''','''	
													+ ISNULL(@FactoryID		, N'NULL')	+ N''','''
													+ N'''';
													
BEGIN TRY
	BEGIN TRANSACTION [spdFactories];
	
-------------------------------------------------------------------------------------------------------------------
-- ##### DELETE ###########
	DELETE FROM [load].[tdFactories] WHERE SOURCE = @Source
													
-------------------------------------------------------------------------------------------------------------------
-- ##### INSERT ###########
	INSERT INTO [load].[tdFactories]  
		SELECT   '<#NV>'									AS FactoryID
				,'<#NV>'									AS NameShort
				,'<#NV>'									AS NameLong
				,'<#NV>'									AS CommentUser
				,'<#NV>'									AS CommentDev
				,'<#NV>'									AS ResponsiblePerson
				,'<#NV>'									AS ImageName
				,@Source									AS Source
				,@TimestampCall								AS SourceTimeStamp
		FROM [dbo].[sx_pf_fValues]		-- Beispieltabelle mit Beispielfiltern
		WHERE	(@FactoryID = '' OR FactoryID = @FactoryID)
		
		SET @EffectedRows	= +@@ROWCOUNT
		
-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode		= 200	

	COMMIT TRANSACTION [spdFactories];
END TRY
BEGIN CATCH
	DECLARE @Error_state INT = ERROR_STATE();
	SET @Comment = ERROR_MESSAGE();

	ROLLBACK TRANSACTION [spdFactories];		

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
GRANT EXECUTE ON OBJECT ::[load].[spdFactories]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[load].[spdFactories]  TO pf_PlanningFactoryService;
GO

