/*
Mandy Hauck 2018/02	
Write errors occuring during import into API Log
	EXEC dbo.spError '','','','',0,'',0,'','','',''
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[sp_tdImportErrors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [control].[sp_tdImportErrors]
GO

CREATE PROCEDURE [control].[sp_tdImportErrors]
						(	@ProductID			NVARCHAR(255),	
							@ProductLineID		NVARCHAR(255),
							@FactoryID			NVARCHAR(255),
							@ValueSeriesID		NVARCHAR(255),
							@TimeID				INT,
							@ValueFormula		NVARCHAR(255),
							@ValueInt			BIGINT,
							@ValueText			NVARCHAR(MAX),
							@ValueComment		NVARCHAR(MAX),
							@Source				NVARCHAR(255),
							@SouceTimeStamp		DATETIME,
							@ErrorMessage		NVARCHAR(255)						)

AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ###### VARIABLES #####################
DECLARE @Username						NVARCHAR(255)= N'SQL'
DECLARE @TransactUsername				NVARCHAR(255)= N'';	
DECLARE @ProcedureName					AS NVARCHAR (255) = OBJECT_NAME(@@PROCID);

DECLARE @ParameterString	AS NVARCHAR (MAX) = N'''' 
							+ ISNULL(@Username, N'NULL')							+ N''',''' 
							+ ISNULL(@FactoryID, N'NULL')							+ N''',''' 
							+ ISNULL(@ProductLineID, N'NULL')						+ N''',''' 
							+ ISNULL(@ProductID, N'NULL')							+ N''',''' 
							+ ISNULL(@ValueSeriesID, N'NULL')						+ N''',' 
							+ ISNULL(CAST(@TimeID AS NVARCHAR(255))					+ N',''' 
							+ ISNULL(@ValueFormula, N'NULL')						+ N''','
							+ ISNULL(CAST(@ValueInt AS NVARCHAR(255)),N'NULL')		+ N',''' 
							+ ISNULL(@ValueText, N'NULL')							+ N''',''' 							 
							+ ISNULL(@ValueComment, N'NULL')						+ '', N'NULL');

DECLARE @EffectedRows	AS INTEGER			= 0;						
DECLARE @ResultCode		AS INTEGER			= 501;					
DECLARE @TimestampCall	AS DATETIME			= CURRENT_TIMESTAMP;
DECLARE @Comment		AS NVARCHAR (2000)	= N'';	
	
-------------------------------------------------------------------------------------------------------------------
	
SET @EffectedRows =  @@ROWCOUNT;
SET @ResultCode = 404;
SET @Comment = @ErrorMessage;

SELECT @TransactUsername = [dbo].[sx_pf_Determine_TransactionUsername] (@Username);

EXEC [dbo].[sx_pf_pPOST_API_LogEntry] @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;
RETURN @ResultCode;
		
-------------------------------------------------------------------------------------------------------------------
GO
GRANT EXECUTE ON OBJECT ::[control].[sp_tdImportErrors] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[control].[sp_tdImportErrors] TO pf_PlanningFactoryService;
GO
