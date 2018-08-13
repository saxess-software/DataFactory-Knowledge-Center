/*
DYNAMIC PIVOT | Ausgabe der Werte aus Tabelle sx_pf_fValues als Pivot-Tabelle und schreiben in eine Zieltabelle/ Transponieren der Zeilen in Spalten
	EXEC [param].[spFillParamTable]  'SQL','KST'
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[param].[spFillParamTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [param].[spFillParamTable]
GO

CREATE PROCEDURE [param].[spFillParamTable] (	@Username NVARCHAR(255), @TemplateProductID	NVARCHAR(255)	)
AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
-- Procedure Variables
DECLARE @Table								NVARCHAR(MAX)
DECLARE	@TableSchema						NVARCHAR(255)	= 'param.'
DECLARE	@TablePreName						NVARCHAR(255)	= 'tPivot'																						-- standard TablePreName
DECLARE @STRINGText1						NVARCHAR(MAX)	
DECLARE @STRINGText2						NVARCHAR(MAX)
DECLARE @STRINGText3						NVARCHAR(MAX)
DECLARE @STRINGInt1							NVARCHAR(MAX)	
DECLARE @STRINGInt2							NVARCHAR(MAX)
DECLARE @STRINGInt3							NVARCHAR(MAX)
DECLARE @FLAGText							NVARCHAR(255)	= '0'
DECLARE @FLAGInt							NVARCHAR(255)	= '0'
DECLARE @SQLDelete							NVARCHAR(MAX)
DECLARE @SQLInsert							NVARCHAR(MAX)

-- API Variables
DECLARE @TransactUsername		NVARCHAR(255)	= N'';
DECLARE @ProcedureName			NVARCHAR (255)	= OBJECT_SCHEMA_NAME(@@PROCID) + N'.' + OBJECT_NAME(@@PROCID);
DECLARE @EffectedRows			INT				= 0;						
DECLARE @ResultCode				INT				= 501;						
DECLARE @TimestampCall			DATETIME		= CURRENT_TIMESTAMP;
DECLARE @Comment				NVARCHAR(2000)	= N'';
DECLARE @ParameterString		NVARCHAR(MAX)	= N''''
													+ ISNULL(@Username				, N'NULL')		+ N''','''
													+ ISNULL(@TemplateProductID		, N'NULL')		+ N''','''
													+ N'''';	

-------------------------------------------------------------------------------------------------------------------
-- ##### GENERAL CHECKS ###########
-- Null Protection
IF @Username					IS NULL SET @Username			 = N'';
IF @TemplateProductID			IS NULL SET @TemplateProductID			 = N'';

BEGIN TRY
	BEGIN TRANSACTION [spFillParamTable];

-- Protect input parameters
SET @TemplateProductID			 = dbo.sx_pf_pProtectID		(@TemplateProductID);

-- Error message for null input parameters
IF @TemplateProductID = N''
	BEGIN
		SET @ResultCode = 404;
		RAISERROR('Empty input parameters', 16, 10);
	END;

-- Determine transaction user
SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);

IF @TransactUsername  = N'403' 
	BEGIN
		SET @ResultCode = 403;
		RAISERROR('Transaction user don`t exists', 16, 10);
	END;

-- Check if Transactionuser has write rights for Factory 'ZT'
EXEC @ResultCode = dbo.sx_pf_pGET_FactoryWriteRight @TransactUsername,'ZT'

	IF @ResultCode <> 200
		RAISERROR('Invalid rights', 16, 10);
		
-------------------------------------------------------------------------------------------------------------------
-- ##### IF EXISTS tmp ###########
-- Check, if tmp tables exists and drops them
IF OBJECT_ID('dbo.tmpText', 'U') IS NOT NULL	DROP TABLE dbo.tmpText
IF OBJECT_ID('dbo.tmpInt', 'U') IS NOT NULL		DROP TABLE dbo.tmpInt

-------------------------------------------------------------------------------------------------------------------
-- ##### SET @Table ###########
-- Construct table name
SET @Table =  @TableSchema + '[' + @TablePreName + @TemplateProductID + ']'

-------------------------------------------------------------------------------------------------------------------
-- ##### SET ###########
-- STRING
	-- Get string for dynamic SQL used in PIVOT command (...ValueSeriesID IN ([...]))
	SELECT @STRINGText1 = COALESCE(@STRINGText1 + ',', '') +  '[' + CONVERT(NVARCHAR(4000),ValueSeriesID) + ']'
	FROM sx_pf_dValueSeries dVS
	WHERE	dVS.FactoryID = 'ZT' AND dVS.IsNumeric = 0 AND dVS.ProductLineID LIKE '%PARAM%' AND dVS.ProductID = @TemplateProductID

-- INT
	-- Get string for dynamic SQL used in PIVOT command (...ValueSeriesID IN ([...]))
	SELECT @STRINGInt1 = COALESCE(@STRINGInt1 + ',', '') +   '[' + CONVERT(NVARCHAR(4000),ValueSeriesID) + ']'
	FROM sx_pf_dValueSeries dVS
	WHERE	dVS.FactoryID = 'ZT' AND dVS.IsNumeric = 1 AND dVS.ProductLineID LIKE '%PARAM%' AND dVS.ProductID = @TemplateProductID

	-- Get string for dynamic SQL used in INSERT command
	SELECT @STRINGInt3 = COALESCE(@STRINGInt3 + ',', '') +  'COALESCE(CAST(tI.[' + CONVERT(NVARCHAR(4000),dVS.ValueSeriesID) + '] AS MONEY) / ' + CONVERT(NVARCHAR(4000),dVS.Scale) + ','''') '
	FROM sx_pf_dValueSeries dVS
	WHERE	dVS.FactoryID = 'ZT' AND dVS.IsNumeric = 1  AND dVS.ProductLineID LIKE '%PARAM%' AND dVS.ProductID = @TemplateProductID

-------------------------------------------------------------------------------------------------------------------
-- ##### SELECT ###########
-- Create and Fill tmp tables, depending on availability of content in string-variables
-- STRING
	IF @STRINGText1 != ''
	BEGIN
		DECLARE @SQLText	NVARCHAR(MAX) = '
			SELECT	 PivotT.FactoryID,PivotT.ProductLineID,PivotT.ProductID,PivotT.TimeID
					,' + @STRINGText1 + '
			INTO dbo.tmpText
			FROM 
				(	SELECT fV.FactoryID,fV.ProductLineID,fV.ProductID,fV.ValueSeriesID,fV.TimeID,fV.ValueText
					FROM sx_pf_fValues fV
						LEFT JOIN sx_pf_dValueSeries dVS
							ON fV.ValueSeriesKey = dVS.ValueSeriesKey
						LEFT JOIN sx_pf_dProducts	dP ON fV.ProductKey = dP.ProductKey
					WHERE fV.FactoryID = ''ZT'' AND fV.ProductLineID LIKE ''PARAM%'' AND dP.ProductID =''' + @TemplateProductID + ''' AND fV.ValueText != ''''	) AS Source
			PIVOT
				(	MAX(ValueText) FOR ValueSeriesID IN (' + @STRINGText1 + ')	) AS PivotT'

		EXECUTE sp_executesql @SQLText
	END
	-- SELECT * FROM dbo.tmpText

-- INT
	IF @STRINGInt1 != ''
	BEGIN
		DECLARE @SQLInt	NVARCHAR(MAX) = '
			SELECT	 PivotT.FactoryID,PivotT.ProductLineID,PivotT.ProductID,PivotT.TimeID
					,' + @STRINGInt1 + '
			INTO dbo.tmpInt
			FROM 
				(	SELECT fV.FactoryID,fV.ProductLineID,fV.ProductID,fV.ValueSeriesID,fV.TimeID,fV.ValueInt
					FROM sx_pf_fValues fV
						LEFT JOIN sx_pf_dValueSeries dVS
							ON fV.ValueSeriesKey = dVS.ValueSeriesKey
							LEFT JOIN sx_pf_dProducts	dP ON fV.ProductKey = dP.ProductKey
					WHERE fV.FactoryID = ''ZT'' AND fV.ProductLineID LIKE ''PARAM%'' AND dP.ProductID =''' + @TemplateProductID + ''' AND fV.ValueInt != ''''	) AS Source
			PIVOT
				(	MAX(ValueInt) FOR ValueSeriesID IN (' + @STRINGInt1 + ')	) AS PivotT'

		EXECUTE sp_executesql @SQLInt
	END

	-- SELECT * FROM dbo.tmpInt 
		
-------------------------------------------------------------------------------------------------------------------
-- ##### FLAG ###########
-- Check if tmp tables have been created and sets flag
IF OBJECT_ID('dbo.tmpText', 'U') IS NOT NULL	SET @FLAGText = '1'	
IF OBJECT_ID('dbo.tmpInt', 'U') IS NOT NULL		SET @FLAGInt = '1'	

-------------------------------------------------------------------------------------------------------------------
-- ##### INSERT ###########
-- param.tPivot-table is filled with content from tmp table depending on flags
IF @FLAGText = '1' AND @FLAGInt = '1'		-- Sowohl Text- als auch Int-Werte sind vorhanden
	BEGIN
		SET @SQLInsert  = 'INSERT INTO ' + @Table + '
			SELECT DISTINCT	dVS.FactoryID,dVS.ProductLineID,dVS.ProductID,COALESCE(tT.TimeID,tI.TimeID)
					,' + @STRINGText1 + '
					,' + @STRINGInt3 + '
			FROM sx_pf_dValueSeries dVS
				LEFT JOIN dbo.sx_pf_dTime spdt ON dVS.ProductKey = spdt.ProductKey
				LEFT JOIN dbo.tmpText tT	ON dVS.FactoryID = tT.FactoryID AND dVS.ProductLineID = tT.ProductLineID AND dVS.ProductID = tT.ProductID AND tT.TimeID = spdt.TimeID
				LEFT JOIN dbo.tmpInt tI		ON dVS.FactoryID = tI.FactoryID AND dVS.ProductLineID = tI.ProductLineID AND dVS.ProductID = tI.ProductID AND tI.TimeID = spdt.TimeID
			WHERE dVS.FactoryID = ''ZT'' AND dVS.ProductLineID LIKE ''PARAM%'' AND (tT.TimeID IS NOT NULL OR tI.TimeID IS NOT NULL) AND dVS.ProductID =''' + @TemplateProductID + '''	'

		EXECUTE sp_executesql @SQLInsert

		SET @Comment = 'Table has been filled with Int & Text values'
		SET @ResultCode = 200
	END


IF @FLAGText = '1' AND @FLAGInt = '0'		-- Es sind nur Textwerte vorhanden
	BEGIN
		SET @SQLInsert = 'INSERT INTO ' + @Table + '
			SELECT DISTINCT	dVS.FactoryID,dVS.ProductLineID,dVS.ProductID,tT.TimeID
					,' + @STRINGText1 + '
			FROM sx_pf_dValueSeries dVS
				LEFT JOIN dbo.sx_pf_dTime spdt ON dVS.ProductKey = spdt.ProductKey
				LEFT JOIN dbo.tmpText tT	ON dVS.FactoryID = tT.FactoryID AND dVS.ProductLineID = tT.ProductLineID AND dVS.ProductID = tT.ProductID AND tT.TimeID = spdt.TimeID
			WHERE dVS.FactoryID = ''ZT'' AND dVS.ProductLineID LIKE ''PARAM%'' AND tT.TimeID IS NOT NULL AND dVS.ProductID =''' + @TemplateProductID + '''	'

		EXECUTE sp_executesql @SQLInsert

		SET @Comment = 'Table has been filled with Text values'
		SET @ResultCode = 200
	END

IF @FLAGText = '0' AND @FLAGInt = '1'		-- Es sind nur Intwerte vorhanden
	BEGIN
		SET @SQLInsert = 'INSERT INTO ' + @Table + '
			SELECT DISTINCT	dVS.FactoryID,dVS.ProductLineID,dVS.ProductID,tI.TimeID
					,' + @STRINGInt3 + '
			FROM sx_pf_dValueSeries dVS
				LEFT JOIN dbo.sx_pf_dTime spdt ON dVS.ProductKey = spdt.ProductKey
				LEFT JOIN dbo.tmpInt tI		ON dVS.FactoryID = tI.FactoryID AND dVS.ProductLineID = tI.ProductLineID AND dVS.ProductID = tI.ProductID AND tI.TimeID = spdt.TimeID
			WHERE dVS.FactoryID = ''ZT'' AND dVS.ProductLineID LIKE ''PARAM%'' AND tI.TimeID IS NOT NULL AND dVS.ProductID =''' + @TemplateProductID + '''	'

		EXECUTE sp_executesql @SQLInsert

		SET @Comment = 'Table has been filled with Int values'
		SET @ResultCode = 200
	END

-------------------------------------------------------------------------------------------------------------------
-- ##### DROP ###########
-- DROP tmp tables
IF OBJECT_ID('dbo.tmpText', 'U') IS NOT NULL	DROP TABLE dbo.tmpText
IF OBJECT_ID('dbo.tmpInt', 'U') IS NOT NULL		DROP TABLE dbo.tmpInt

-------------------------------------------------------------------------------------------------------------------	
-- ##### API log entry or rollback ###########
	COMMIT TRANSACTION [spFillParamTable];
END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION [spFillParamTable];		

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
GRANT EXECUTE ON OBJECT ::[param].[spFillParamTable]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[param].[spFillParamTable]  TO pf_PlanningFactoryService;
GO
