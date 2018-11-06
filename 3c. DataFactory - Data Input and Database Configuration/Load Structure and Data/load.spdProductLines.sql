
/*
Author: 	Heathcliff Power
Created: 	2018/11
Summary:	Laden der Daten in Tabelle load.tdProductLines

	EXEC [load].[spdProductLines] 'SQL',''
	SELECT * FROM [load].[tdProductLines]
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[load].[spdProductLines]') AND type in (N'P', N'PC'))
DROP PROCEDURE [load].[spdProductLines]
GO

CREATE PROCEDURE [load].[spdProductLines]		
					(		@Username			NVARCHAR(255) = '',
							@FactoryID			NVARCHAR(255) = '',
							@ProductLineID		NVARCHAR(255) = ''		)
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
													+ N'''';
													
BEGIN TRY
	BEGIN TRANSACTION [spdProductLines];
	
-------------------------------------------------------------------------------------------------------------------
-- ##### DELETE ###########
	DELETE FROM [load].[tdProductLines] WHERE SOURCE = @Source
													
-------------------------------------------------------------------------------------------------------------------
-- ##### INSERT ###########
	INSERT INTO [load].[tdProductLines]  
		SELECT   '<#NV>'									AS ProductLineID
				,'<#NV>'									AS FactoryID
				,'<#NV>'									AS NameShort
				,'<#NV>'									AS NameLong
				,'<#NV>'									AS CommentUser
				,'<#NV>'									AS CommentDev
				,'<#NV>'									AS ResponsiblePerson
				,'<#NV>'									AS ImageName
				,'<#NV>'									AS DefaultTemplate
				,'<#NV>'									AS GlobalAttributeSource1
				,'<#NV>'									AS GlobalAttribute1
				,'<#NV>'									AS GlobalAttributeSource2
				,'<#NV>'									AS GlobalAttribute2
				,'<#NV>'									AS GlobalAttributeSource3
				,'<#NV>'									AS GlobalAttribute3
				,'<#NV>'									AS GlobalAttributeSource4
				,'<#NV>'									AS GlobalAttribute4
				,'<#NV>'									AS GlobalAttributeSource5
				,'<#NV>'									AS GlobalAttribute5
				,'<#NV>'									AS GlobalAttributeSource6
				,'<#NV>'									AS GlobalAttribute6
				,'<#NV>'									AS GlobalAttributeSource7
				,'<#NV>'									AS GlobalAttribute7
				,'<#NV>'									AS GlobalAttributeSource8
				,'<#NV>'									AS GlobalAttribute8
				,'<#NV>'									AS GlobalAttributeSource9
				,'<#NV>'									AS GlobalAttribute9
				,'<#NV>'									AS GlobalAttributeSource10
				,'<#NV>'									AS GlobalAttribute10
				,'<#NV>'									AS GlobalAttributeSource11
				,'<#NV>'									AS GlobalAttribute11
				,'<#NV>'									AS GlobalAttributeSource12
				,'<#NV>'									AS GlobalAttribute12
				,'<#NV>'									AS GlobalAttributeSource13
				,'<#NV>'									AS GlobalAttribute13
				,'<#NV>'									AS GlobalAttributeSource14
				,'<#NV>'									AS GlobalAttribute14
				,'<#NV>'									AS GlobalAttributeSource15
				,'<#NV>'									AS GlobalAttribute15
				,'<#NV>'									AS GlobalAttributeSource16
				,'<#NV>'									AS GlobalAttribute16
				,'<#NV>'									AS GlobalAttributeSource17
				,'<#NV>'									AS GlobalAttribute17
				,'<#NV>'									AS GlobalAttributeSource18
				,'<#NV>'									AS GlobalAttribute18
				,'<#NV>'									AS GlobalAttributeSource19
				,'<#NV>'									AS GlobalAttribute19
				,'<#NV>'									AS GlobalAttributeSource20
				,'<#NV>'									AS GlobalAttribute20
				,'<#NV>'									AS GlobalAttributeSource21
				,'<#NV>'									AS GlobalAttribute21
				,'<#NV>'									AS GlobalAttributeSource22
				,'<#NV>'									AS GlobalAttribute22
				,'<#NV>'									AS GlobalAttributeSource23
				,'<#NV>'									AS GlobalAttribute23
				,'<#NV>'									AS GlobalAttributeSource24
				,'<#NV>'									AS GlobalAttribute24
				,'<#NV>'									AS GlobalAttributeSource25
				,'<#NV>'									AS GlobalAttribute25
				,@Source									AS Source
				,GETDATE()									AS SourceTimeStamp
		FROM [dbo].[sx_pf_fValues]		-- Beispieltabelle mit Beispielfiltern
		WHERE	(@FactoryID = '' OR FactoryID = @FactoryID)
			AND	(@ProductLineID = '' OR ProductLineID = @ProductLineID)
		
		SET @EffectedRows	= @@ROWCOUNT
		
-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode		= 200	

	COMMIT TRANSACTION [spdProductLines];
END TRY
BEGIN CATCH
	DECLARE @Error_state INT = ERROR_STATE();
	SET @Comment = ERROR_MESSAGE();

	ROLLBACK TRANSACTION [spdProductLines];		

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
GRANT EXECUTE ON OBJECT ::[load].[spdProductLines]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[load].[spdProductLines]  TO pf_PlanningFactoryService;
GO

