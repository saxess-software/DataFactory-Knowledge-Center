/*
DYNAMIC PIVOT | Ausgabe der Werte aus Tabelle sx_pf_fValues als Pivot-Tabelle und schreiben in eine Zieltabelle/ Transponieren der Zeilen in Spalten
	EXEC [param].[spFillParamTable]  'SQL','PARAM1'
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
DECLARE @TablePreName						NVARCHAR(MAX)	= 'param.t'
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
DECLARE @EffectedRows			INT = 0;						
DECLARE @ResultCode				INT = 501;						
DECLARE @TimestampCall			DATETIME = CURRENT_TIMESTAMP;
DECLARE @Comment				NVARCHAR (2000) = N'';
DECLARE @ParameterString		NVARCHAR (MAX)	= N''''
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

-- Check rights
EXEC @ResultCode = dbo.sx_pf_pGET_ClusterWriteRight @TransactUsername;

	IF @ResultCode <> 200
		RAISERROR('Invalid rights', 16, 10);

			
-------------------------------------------------------------------------------------------------------------------
-- ##### IF EXISTS tmp ###########
IF OBJECT_ID('dbo.tmpText', 'U') IS NOT NULL	DROP TABLE dbo.tmpText
IF OBJECT_ID('dbo.tmpInt', 'U') IS NOT NULL		DROP TABLE dbo.tmpInt

-------------------------------------------------------------------------------------------------------------------
-- ##### SET @Table ###########
SET @Table =  @TablePreName + @TemplateProductID

-------------------------------------------------------------------------------------------------------------------
-- ##### SET ###########
-- STRING
	SELECT @STRINGText1 = COALESCE(@STRINGText1 + ',', '') +  '[' + CONVERT(NVARCHAR(MAX),ValueSeriesID) + ']'
	FROM sx_pf_dValueSeries dVS
	WHERE	dVS.FactoryID = 'ZT' AND dVS.IsNumeric = 0 AND dVS.ProductLineID = 'PARAM' AND dVS.ProductID = @TemplateProductID

	-- PRINT @STRINGText1

	SELECT @STRINGText2 = COALESCE(@STRINGText2 + ',', '') +  'COALESCE([' + CONVERT(NVARCHAR(MAX),ValueSeriesID) + '],'''') AS [' + convert(NVARCHAR(MAX),NameShort) + ']'
	FROM sx_pf_dValueSeries dVS
	WHERE	dVS.FactoryID = 'ZT' AND dVS.IsNumeric = 0  AND dVS.ProductLineID = 'PARAM' AND dVS.ProductID = @TemplateProductID

	-- PRINT @STRINGText2

	SELECT @STRINGText3 = COALESCE(@STRINGText3 + ',', '') +  'tT.[' + CONVERT(NVARCHAR(MAX),NameShort) + ']'
	FROM sx_pf_dValueSeries dVS
	WHERE	dVS.FactoryID = 'ZT' AND dVS.IsNumeric = 0  AND dVS.ProductLineID = 'PARAM' AND dVS.ProductID = @TemplateProductID

	-- PRINT @STRINGText3

-- INT
	SELECT @STRINGInt1 = COALESCE(@STRINGInt1 + ',', '') +  '[' + CONVERT(NVARCHAR(MAX),ValueSeriesID) + ']'
	FROM sx_pf_dValueSeries dVS
	WHERE	dVS.FactoryID = 'ZT' AND dVS.IsNumeric = 1 AND dVS.ProductLineID = 'PARAM' AND dVS.ProductID = @TemplateProductID

	-- PRINT @STRINGInt1

	SELECT @STRINGInt2 = COALESCE(@STRINGInt2 + ',', '') +  'COALESCE([' + CONVERT(NVARCHAR(MAX),ValueSeriesID) + '],'''') AS [' + convert(NVARCHAR(MAX),NameShort) + ']'
	FROM sx_pf_dValueSeries dVS
	WHERE	dVS.FactoryID = 'ZT' AND dVS.IsNumeric = 1  AND dVS.ProductLineID = 'PARAM' AND dVS.ProductID = @TemplateProductID

	-- PRINT @STRINGInt2

	SELECT @STRINGInt3 = COALESCE(@STRINGInt3 + ',', '') +  'COALESCE(CAST(tI.[' + CONVERT(NVARCHAR(MAX),NameShort) + '] AS MONEY) / dVS.Scale,'''') '
	FROM sx_pf_dValueSeries dVS
	WHERE	dVS.FactoryID = 'ZT' AND dVS.IsNumeric = 1  AND dVS.ProductLineID = 'PARAM' AND dVS.ProductID = @TemplateProductID

	-- PRINT @STRINGInt3

-------------------------------------------------------------------------------------------------------------------
-- ##### SELECT ###########
-- STRING
	DECLARE @SQLText	NVARCHAR(MAX) = '
		SELECT	 PivotT.FactoryID,PivotT.ProductLineID,PivotT.ProductID,PivotT.TimeID
				,' + @STRINGText2 + '
		INTO dbo.tmpText
		FROM 
			(	SELECT fV.FactoryID,fV.ProductLineID,fV.ProductID,fV.ValueSeriesID,fV.TimeID,fV.ValueText
				FROM sx_pf_fValues fV
					LEFT JOIN sx_pf_dValueSeries dVS
						ON fV.ValueSeriesKey = dVS.ValueSeriesKey
					LEFT JOIN sx_pf_dProducts	dP ON fV.ProductKey = dP.ProductKey
				WHERE fV.FactoryID = ''ZT'' AND fV.ProductLineID = ''PARAM'' AND dP.ProductID =''' + @TemplateProductID + ''' AND fV.ValueText != ''''	) AS Source
		PIVOT
			(	MAX(ValueText) FOR ValueSeriesID IN (' + @STRINGText1 + ')	) AS PivotT'

	EXECUTE sp_executesql @SQLText

		--SELECT * FROM dbo.tmpText

-- INT
	DECLARE @SQLInt	NVARCHAR(MAX) = '
		SELECT	 PivotT.FactoryID,PivotT.ProductLineID,PivotT.ProductID,PivotT.TimeID
				,' + @STRINGInt2 + '
		INTO dbo.tmpInt
		FROM 
			(	SELECT fV.FactoryID,fV.ProductLineID,fV.ProductID,fV.ValueSeriesID,fV.TimeID,fV.ValueInt
				FROM sx_pf_fValues fV
					LEFT JOIN sx_pf_dValueSeries dVS
						ON fV.ValueSeriesKey = dVS.ValueSeriesKey
						LEFT JOIN sx_pf_dProducts	dP ON fV.ProductKey = dP.ProductKey
				WHERE fV.FactoryID = ''ZT'' AND fV.ProductLineID = ''PARAM'' AND dP.ProductID =''' + @TemplateProductID + ''' AND fV.ValueInt != ''''	) AS Source
		PIVOT
			(	MAX(ValueInt) FOR ValueSeriesID IN (' + @STRINGInt1 + ')	) AS PivotT'

	EXECUTE sp_executesql @SQLInt

		--SELECT * FROM dbo.tmpInt WHERE ProductLIneID = '1125'
		
-------------------------------------------------------------------------------------------------------------------
-- ##### FLAG ###########
IF OBJECT_ID('dbo.tmpText', 'U') IS NOT NULL	SET @FLAGText = '1'	
IF OBJECT_ID('dbo.tmpInt', 'U') IS NOT NULL		SET @FLAGInt = '1'	

-------------------------------------------------------------------------------------------------------------------
-- ##### INSERT ###########
IF @FLAGText = '1' AND @FLAGInt = '1'		-- Sowohl Text- als auch Int-Werte sind vorhanden
	BEGIN
		SET @SQLInsert  = 'INSERT INTO ' + @Table + '
			SELECT DISTINCT	dVS.FactoryID,dVS.ProductLineID,dVS.ProductID,COALESCE(tT.TimeID,tI.TimeID)
					,' + @STRINGText3 + '
					,' + @STRINGInt3 + '
			FROM sx_pf_dValueSeries dVS
				LEFT JOIN sx_pf_dProducts	dP ON dVS.ProductKey = dP.ProductKey
				LEFT JOIN dbo.tmpText tT	ON dVS.FactoryID = tT.FactoryID AND dVS.ProductLineID = tT.ProductLineID AND dVS.ProductID = tT.ProductID
				LEFT JOIN dbo.tmpInt tI		ON dVS.FactoryID = tI.FactoryID AND dVS.ProductLineID = tI.ProductLineID AND dVS.ProductID = tI.ProductID AND tT.TimeID = tI.TimeID
			WHERE dVS.FactoryID = ''ZT'' AND dVS.ProductLineID = ''PARAM'' AND (tT.TimeID IS NOT NULL OR tI.TimeID IS NOT NULL) AND dP.ProductID =''' + @TemplateProductID + '''	'

		EXECUTE sp_executesql @SQLInsert
	END

IF @FLAGText = '1' AND @FLAGInt = '0'		-- Es sind nur Textwerte vorhanden
	BEGIN
		SET @SQLInsert = 'INSERT INTO ' + @Table + '
			SELECT DISTINCT	dVS.FactoryID,dVS.ProductLineID,dVS.ProductID,tT.TimeID
					,' + @STRINGText3 + '
			FROM sx_pf_dValueSeries dVS
				LEFT JOIN sx_pf_dProducts	dP ON dVS.ProductKey = dP.ProductKey
				LEFT JOIN dbo.tmpText tT	ON dVS.FactoryID = tT.FactoryID AND dVS.ProductLineID = tT.ProductLineID AND dVS.ProductID = tT.ProductID
			WHERE dVS.FactoryID = ''ZT'' AND dVS.ProductLineID = ''PARAM'' AND tT.TimeID IS NOT NULL AND dP.ProductID =''' + @TemplateProductID + '''	'

		EXECUTE sp_executesql @SQLInsert
	END

IF @FLAGText = '0' AND @FLAGInt = '1'		-- Es sind nur Intwerte vorhanden
	BEGIN
		SET @SQLInsert = 'INSERT INTO ' + @Table + '
			SELECT DISTINCT	dVS.FactoryID,dVS.ProductLineID,dVS.ProductID,tI.TimeID
					,' + @STRINGInt3 + '
			FROM sx_pf_dValueSeries dVS
				LEFT JOIN sx_pf_dProducts	dP ON dVS.ProductKey = dP.ProductKey
				LEFT JOIN dbo.tmpInt tI		ON dVS.FactoryID = tI.FactoryID AND dVS.ProductLineID = tI.ProductLineID AND dVS.ProductID = tI.ProductID
			WHERE dVS.FactoryID = ''ZT'' AND dVS.ProductLineID = ''PARAM'' AND tI.TimeID IS NOT NULL AND dP.ProductID =''' + @TemplateProductID + '''	'

		EXECUTE sp_executesql @SQLInsert
	END

-------------------------------------------------------------------------------------------------------------------
-- ##### DROP ###########
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