
/*
Author: 	Mandy Hauck
Created: 	2018/11
Summary:	Product has been changed at some point of time by some user - Date and time are stored in GA
	EXEC [control].[spLastUserUpdate] 'SQL','1','1','1'
	SELECT * FROM dbo.sx_pf_dProducts
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[spLastUserUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [control].[spLastUserUpdate]
GO

CREATE PROCEDURE [control].[spLastUserUpdate]		
					(		@Username			NVARCHAR(255),
							@FactoryID			NVARCHAR(255),
							@ProductLineID		NVARCHAR(255),
							@ProductID			NVARCHAR(255)		)
AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
	
	-- API log
	DECLARE @TransactUsername		NVARCHAR(255)	= @Username;
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

	-- Procedure specific
	DECLARE @RC							BIGINT		= 501

    DECLARE @TimeType 					NVARCHAR(255) = N'<#NV>'
    DECLARE @NameShort					NVARCHAR(255) = N'<#NV>'
    DECLARE @NameLong					NVARCHAR(255) = N'<#NV>'
    DECLARE @CommentUser 				NVARCHAR(255) = N'<#NV>'
    DECLARE @CommentDev					NVARCHAR(255) = N'<#NV>'
    DECLARE @ResponsiblePerson			NVARCHAR(255) = N'<#NV>'
    DECLARE @ImageName					NVARCHAR(255) = N'<#NV>'	
    DECLARE @Status						NVARCHAR(255) = N'<#NV>'
    DECLARE @Template					NVARCHAR(255) = N'<#NV>'
    DECLARE @TemplateVersion			NVARCHAR(255) = N'<#NV>'
    DECLARE @GA1						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA2						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA3						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA4						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA5						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA6						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA7						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA8						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA9						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA10						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA11						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA12						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA13						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA14						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA15						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA16						NVARCHAR(255) = N'<#NV>' 
    DECLARE @GA17						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA18						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA19						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA20						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA21						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA22						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA23						NVARCHAR(255) = N'<#NV>'
    DECLARE @GA24						NVARCHAR(255) = @Username
    DECLARE @GA25						NVARCHAR(255) = TRY_CAST(CONVERT(NVARCHAR(255),@TimestampCall,113) AS NVARCHAR(255))
													
-------------------------------------------------------------------------------------------------------------------
-- ##### EXEC ###########
BEGIN TRY
	BEGIN TRANSACTION [spLastUserUpdate];

		BEGIN
			EXEC dbo.sx_pf_POST_Product 'SQL' 
									   ,@ProductID 
									   ,@ProductLineID 
									   ,@FactoryID 
									   ,@TimeType 
									   ,@NameShort 
									   ,@NameLong 
									   ,@CommentUser 
									   ,@CommentDev 
									   ,@ResponsiblePerson 
									   ,@ImageName 
									   ,@Status 
									   ,@Template 
									   ,@TemplateVersion 
									   ,@GA1 
									   ,@GA2 
									   ,@GA3 
									   ,@GA4 
									   ,@GA5 
									   ,@GA6 
									   ,@GA7 
									   ,@GA8 
									   ,@GA9 
									   ,@GA10 
									   ,@GA11 
									   ,@GA12 
									   ,@GA13 
									   ,@GA14 
									   ,@GA15 
									   ,@GA16 
									   ,@GA17 
									   ,@GA18 
									   ,@GA19 
									   ,@GA20 
									   ,@GA21 
									   ,@GA22 
									   ,@GA23 
									   ,@GA24 
									   ,@GA25 
		END

					SET @EffectedRows = +@@ROWCOUNT

-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode = 200

	COMMIT TRANSACTION [spLastUserUpdate];
END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION [spLastUserUpdate];		

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
GRANT EXECUTE ON OBJECT ::[control].[spLastUserUpdate]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[control].[spLastUserUpdate]  TO pf_PlanningFactoryService;
GO
