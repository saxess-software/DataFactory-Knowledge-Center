/*
Creates table from Parameter-Product in Factory 'ZT' and ProductLine 'PARAM'
		EXEC [param].[spCreateParamTable] 'SQL','KTO-HGB'
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[param].[spCreateParamTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [param].[spCreateParamTable] 
GO

CREATE PROCEDURE [param].[spCreateParamTable]  (	@Username NVARCHAR(255),@TemplateProductID	NVARCHAR(255)	)
AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
-- Procedure Variables
DECLARE	@TableSchema			NVARCHAR(255)	= 'param.'
DECLARE	@TablePreName			NVARCHAR(255)	= 'tPivot'																						-- standard TablePreName
DECLARE @StringBasic			NVARCHAR(MAX)	= 'FactoryID NVARCHAR(255),ProductLineID NVARCHAR(255),ProductID NVARCHAR(255),TimeID INT'		-- standard columns included in each table
DECLARE @StringText				NVARCHAR(MAX)	
DECLARE @StringInt				NVARCHAR(MAX)	
DECLARE @SQLCreate				NVARCHAR(MAX)
DECLARE	@TableName				NVARCHAR(MAX)
DECLARE @SQLGrant				NVARCHAR(MAX)	

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
	BEGIN TRANSACTION [spCreateParamTable];

---- Protect input parameters
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
-- ##### SET ###########
-- Gets all ValueSeriesIDs from a Product in ProductlLine 'PARAM' in Factory 'ZT', ValueSeriesIDs will become column headers
-- Puts them in one String separated by comma and adds value format NVACRCHAR(MAX) for ValueText ValueSeries and MONEY for ValueInt ValueSeries
BEGIN
	SELECT @STRINGText = COALESCE(@STRINGText + ',', '') +  '[' + CONVERT(NVARCHAR(4000),dVS.ValueSeriesID) + '] NVARCHAR(4000)'
	FROM [dbo].[sx_pf_dProducts] dP
		LEFT JOIN sx_pf_dValueseries dVS ON dP.ProductKey = dVS.ProductKey
	WHERE dP.FactoryID = 'ZT' AND dVS.FactoryID = 'ZT' AND dVS.ProductLIneID LIKE '%PARAM%' AND dVS.[IsNumeric] = 0
			AND dP.ProductID = @TemplateProductID  AND dP.ProductLIneID LIKE '%PARAM%'

	SELECT @StringInt = COALESCE(@StringInt + ',', '') +  '[' + CONVERT(NVARCHAR(MAX),dVS.ValueSeriesID) + '] MONEY'
	FROM [dbo].[sx_pf_dProducts] dP
		LEFT JOIN sx_pf_dValueseries dVS ON dP.ProductKey = dVS.ProductKey
	WHERE dP.FactoryID = 'ZT' AND dVS.FactoryID = 'ZT' AND dVS.ProductLIneID LIKE '%PARAM%' AND dVS.[IsNumeric] = 1
			AND dP.ProductID = @TemplateProductID  AND dP.ProductLIneID LIKE '%PARAM%'

	SELECT @TableName = @TableSchema + '[' + @TablePreName + @TemplateProductID + ']'
END

-------------------------------------------------------------------------------------------------------------------
-- ##### FLAG ###########
-- Check if table will have text and/or int columns
BEGIN
	IF 	@StringText IS NULL		SET @StringText	= '0'
	IF 	@StringInt IS NULL		SET @StringInt	= '0'
END

-------------------------------------------------------------------------------------------------------------------
-- ##### CREATE Table ###########
-- Table is created, depending on flags text and int columns are added in dynamic sql string
BEGIN
	IF @StringText != '0' AND @StringInt != '0'
	BEGIN
		SET @SQLCreate = 'CREATE TABLE ' + @TableName + '(' + @StringBasic + ','
					+ @StringText	+ ','
					+ @StringInt
					+ ')'

		EXECUTE sp_executesql @SQLCreate

		SET @Comment = 'Table has been created containing Int & Text columns'
		SET @ResultCode = 200
	END

	IF @StringText != '0' AND @StringInt = '0'
	BEGIN
		SET @SQLCreate = 'CREATE TABLE ' + @TableName + '(' + @StringBasic + ','
					+ @StringText	
					+ ')'
					
		EXECUTE sp_executesql @SQLCreate

		SET @Comment = 'Table has been created containing only Text columns'
		SET @ResultCode = 200
	END

	IF @StringText = '0' AND @StringInt != '0'
	BEGIN
		SET @SQLCreate = 'CREATE TABLE ' + @TableName + '(' + @StringBasic + ','
					+ @StringInt	
					+ ')'

		EXECUTE sp_executesql @SQLCreate

		SET @Comment = 'Table has been created containing only Int columns'
		SET @ResultCode = 200
	END

	IF @StringText = '0' AND @StringInt = '0'

		SET @Comment = 'No table has been created'
		SET @ResultCode = 200

END

-------------------------------------------------------------------------------------------------------------------
-- ##### GRANT Select ###########
SET @SQLGrant = 'GRANT SELECT, CONTROL,ALTER, INSERT, DELETE, UPDATE ON ' + @TableName + ' TO pf_PlanningFactoryUser; GRANT SELECT, CONTROL, ALTER, INSERT, DELETE, UPDATE ON ' + @TableName + ' TO pf_PlanningFactoryService;'
EXECUTE sp_executesql @SQLGrant

-------------------------------------------------------------------------------------------------------------------	
-- ##### API log entry or rollback ###########
	COMMIT TRANSACTION [spCreateParamTable];
END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION [spCreateParamTable];		

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
GRANT EXECUTE ON OBJECT ::[param].[spCreateParamTable]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[param].[spCreateParamTable]  TO pf_PlanningFactoryService;
GO