
/*
Author: 	Heathcliff Power
Created: 	2018/11
Summary:	Laden der Daten in Tabelle load.tdProducts

	EXEC [load].[spdProducts] 'SQL','','',''
	SELECT * FROM load.tdProducts
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[load].[spdProducts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [load].[spdProducts]
GO

CREATE PROCEDURE [load].[spdProducts]		
					(		@Username			NVARCHAR(255) = '',
							@FactoryID			NVARCHAR(255) = '',
							@ProductLineID		NVARCHAR(255) = '',
							@ProductID			NVARCHAR(255) = ''		)
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
													+ ISNULL(@ProductLineID	, N'NULL')	+ N''','''
													+ ISNULL(@ProductID		, N'NULL')	+ N''','''
													+ N'''';
													
BEGIN TRY
	BEGIN TRANSACTION [spdProducts];
	
-------------------------------------------------------------------------------------------------------------------
-- ##### DELETE ###########
	DELETE FROM [load].[tdProducts] WHERE SOURCE = @Source
													
-------------------------------------------------------------------------------------------------------------------
-- ##### INSERT ###########
	INSERT INTO [load].[tdProducts]	
		SELECT	 '<#NV>'									AS ProductID
				,'<#NV>'									AS ProductLineID
				,'<#NV>'									AS FactoryID
				,'<#NV>'									AS TimeType
				,'<#NV>'									AS NameShort
				,'<#NV>'									AS NameLong
				,'<#NV>'									AS CommentUser
				,'<#NV>'									AS CommentDev
				,'<#NV>'									AS ResponsiblePerson
				,'<#NV>'									AS ImageName
				,'<#NV>'									AS [Status]
				,'<#NV>'									AS Template
				,'<#NV>'									AS TemplateVersion
				,'<#NV>'									AS GlobalAttribute1
				,'<#NV>'									AS GlobalAttribute2
				,'<#NV>'									AS GlobalAttribute3
				,'<#NV>'									AS GlobalAttribute2
				,'<#NV>'									AS GlobalAttribute5
				,'<#NV>'									AS GlobalAttribute6
				,'<#NV>'									AS GlobalAttribute7
				,'<#NV>'									AS GlobalAttribute8
				,'<#NV>'									AS GlobalAttribute9
				,'<#NV>'									AS GlobalAttribute10
				,'<#NV>'									AS GlobalAttribute11
				,'<#NV>'									AS GlobalAttribute12
				,'<#NV>'									AS GlobalAttribute13
				,'<#NV>'									AS GlobalAttribute14
				,'<#NV>'									AS GlobalAttribute15
				,'<#NV>'									AS GlobalAttribute16
				,'<#NV>'									AS GlobalAttribute17
				,'<#NV>'									AS GlobalAttribute18
				,'<#NV>'									AS GlobalAttribute19
				,'<#NV>'									AS GlobalAttribute20
				,'<#NV>'									AS GlobalAttribute21
				,'<#NV>'									AS GlobalAttribute22
				,'<#NV>'									AS GlobalAttribute23
				,'<#NV>'									AS GlobalAttribute24
				,'<#NV>'									AS GlobalAttribute25
				,@Source									AS Source
				,@TimestampCall								AS SourceTimeStamp
		FROM [dbo].[sx_pf_fValues]			-- Beispieltabelle mit Beispielfiltern
		WHERE	(@FactoryID = '' OR FactoryID = @FactoryID)
			AND	(@ProductLineID = '' OR ProductLineID = @ProductLineID)
			AND	(@ProductID = '' OR ProductID = @ProductID)

		SET @EffectedRows	= +@@ROWCOUNT
			
-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode		= 200	

	COMMIT TRANSACTION [spdProducts];
END TRY
BEGIN CATCH
	DECLARE @Error_state INT = ERROR_STATE();
	SET @Comment = ERROR_MESSAGE();

	ROLLBACK TRANSACTION [spdProducts];		

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
GRANT EXECUTE ON OBJECT ::[load].[spdProducts]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[load].[spdProducts]  TO pf_PlanningFactoryService;
GO















