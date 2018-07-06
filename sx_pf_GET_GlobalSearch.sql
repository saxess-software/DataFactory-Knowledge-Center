/*
GET Operation for receiving a context sensitiv List
API deliviers List Values fitting to the sended context Parameters
Procedure must be editend to fit user needs and recreated after each API Update
When updating this procedure, you must reset the rights for it

04/2018 for DataFactory 4.0
Gerd Tautenhahn for saxess-software gmbh
Return Value according to HTTP Standard

--Test call

DECLARE @RC AS NVARCHAR(255)
--should return Data and 200
EXEC @RC = dbo.sx_pf_GET_GlobalSearch 'SQL','A'
PRINT @RC
*/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sx_pf_GET_GlobalSearch') AND type in (N'P', N'PC'))
	DROP PROCEDURE dbo.sx_pf_GET_GlobalSearch;
GO

CREATE PROCEDURE dbo.sx_pf_GET_GlobalSearch
	 @Username				NVARCHAR(255)
	,@SearchString			NVARCHAR(255)  -- any Substring from searched list values
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @GlobalattributeAlias	NVARCHAR(255)	= N'';
	DECLARE @SearchDoneFlag			INT				= 0;
	DECLARE @ProductKey				BIGINT			= 0;
	DECLARE @DummyTable TABLE (Dummy NVARCHAR(255) NOT NULL)  -- only for the samples to compile
	DECLARE @DummyInt				INT
	-- Logging Block
	DECLARE @TransactUsername		NVARCHAR(255)	= N'';
	DECLARE @ProcedureName			NVARCHAR(255)	= OBJECT_SCHEMA_NAME(@@PROCID) + N'.' + OBJECT_NAME(@@PROCID);
	DECLARE @EffectedRows			INT				= 0;				-- SET during Execution
	DECLARE @ResultCode				INT				= 501;				-- SET during Execution
	DECLARE @TimestampCall			DATETIME		= CURRENT_TIMESTAMP;
	DECLARE @Comment				NVARCHAR(2000)  = N'';				-- SET during Execution

	DECLARE @ParameterString		NVARCHAR(MAX)	= N''''    
			+ ISNULL(@Username,					N'NULL') + N''',''' 
			+ ISNULL(@SearchString,				N'NULL') + N'''';  

	-- STEP 0.1 - NULL Protection
	IF @Username				IS NULL SET @Username				= N'';
	
	
	-- add wildcards to SeachString
	SET @SearchString = '%' + ISNULL(@SearchString, '') + '%';

	BEGIN TRY
		BEGIN TRANSACTION sx_pf_GET_GlobalSearch;

		-- Protect input parameters
		SET @Username		= dbo.sx_pf_pProtectString	(@Username);
		
				
		-- Determine transaction user
		SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);

		IF @TransactUsername  = N'403' 
		BEGIN
			SET @ResultCode = 403;
			RAISERROR('Transaction user don`t exists', 16, 10);
		END;

		-- Getting Content
		-- ****************************************************************************************************************************************************
		IF OBJECT_ID('tempdb..#SearchResult') IS NOT NULL
				DROP TABLE #SearchResult;

			CREATE TABLE #SearchResult
			(
				 RowKey					BIGINT IDENTITY (1,1)	NOT NULL
				,FactoryID				NVARCHAR (255)			NOT NULL
				,ProductLineID			NVARCHAR (255)			NOT NULL
				,ProductID				NVARCHAR (255)			NOT NULL
				,ValueSeriesID			NVARCHAR (255)			NOT NULL
				,Resultgroup			NVARCHAR (255)			NOT NULL
				,Resulttype					NVARCHAR (255)			NOT NULL
				,Result					NVARCHAR (255)			NOT NULL
			)
		
		-- Factories BEGIN #####

		INSERT INTO #SearchResult
			SELECT dF.FactoryID
			      ,''
				  ,''
				  ,''
				  ,'Factory'
				  ,'FactoryID'
				  ,dF.FactoryID
			FROM dbo.sx_pf_dFactories dF
			WHERE dF.FactoryID LIKE @SearchString
		
		SET @EffectedRows += @@ROWCOUNT;

		INSERT INTO #SearchResult
			SELECT dF.FactoryID
			      ,''
				  ,''
				  ,''
				  ,'Factory'
				  ,'NameShort'
				  ,dF.NameShort
			FROM dbo.sx_pf_dFactories dF
			WHERE dF.NameShort LIKE @SearchString
		
		SET @EffectedRows += @@ROWCOUNT;

		INSERT INTO #SearchResult
			SELECT dF.FactoryID
			      ,''
				  ,''
				  ,''
				  ,'Factory'
				  ,'ResponsiblePerson'
				  ,dF.ResponsiblePerson
			FROM dbo.sx_pf_dFactories dF
			WHERE dF.ResponsiblePerson LIKE @SearchString
		
		SET @EffectedRows += @@ROWCOUNT;

		-- Factories END #####

		-- Productline BEGIN
		
		INSERT INTO #SearchResult
			SELECT dPL.FactoryID
			      ,dPL.ProductLineID
				  ,''
				  ,''
				  ,'Productline'
				  ,'ProductlineID'
				  ,dPL.ProductLineID
			FROM dbo.sx_pf_dProductLines dPL
			WHERE dPL.ProductLineID LIKE @SearchString

		INSERT INTO #SearchResult
			SELECT dPL.FactoryID
			      ,dPL.ProductLineID
				  ,''
				  ,''
				  ,'Productline'
				  ,'NameShort'
				  ,dPL.NameShort
			FROM dbo.sx_pf_dProductLines dPL
			WHERE dPL.NameShort LIKE @SearchString

		INSERT INTO #SearchResult
			SELECT dPL.FactoryID
			      ,dPL.ProductLineID
				  ,''
				  ,''
				  ,'Productline'
				  ,'ResponsiblePerson'
				  ,dPL.ResponsiblePerson
			FROM dbo.sx_pf_dProductLines dPL
			WHERE dPL.ResponsiblePerson LIKE @SearchString
		
		SET @EffectedRows += @@ROWCOUNT;
			
		-- Output

		SELECT sr.FactoryID
		      ,sr.ProductLineID
			  ,sr.ProductID
			  ,sr.ValueSeriesID
			  ,sr.Resultgroup
			  ,sr.Resulttype
			  ,sr.Result
		FROM #SearchResult sr

		SET @SearchDoneFlag = 1

		-- Productive Fallback - if no flex search matched the query
		-- **************************************************************************************
		IF @SearchDoneFlag = 0 
		BEGIN
			SELECT 
				'For this Seach Context, we sadly must tell to have no fitting content to offer. ' AS Hint
				,'Nothing' AS Content_LS50
				,'is all I have to offer for you.' AS Sorry_LS200
		END

		SET @EffectedRows += @@ROWCOUNT;

		SET @ResultCode = 200;

		COMMIT TRANSACTION sx_pf_GET_GlobalSearch;
	END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION sx_pf_GET_GlobalSearch;		

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
END
GO

GRANT EXECUTE ON OBJECT ::dbo.sx_pf_GET_GlobalSearch TO pf_PlanningFactoryUser
GRANT EXECUTE ON OBJECT ::dbo.sx_pf_GET_GlobalSearch TO pf_PlanningFactoryService
GO
