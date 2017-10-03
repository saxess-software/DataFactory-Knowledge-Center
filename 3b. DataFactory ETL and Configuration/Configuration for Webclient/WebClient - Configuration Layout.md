
## Anpassung des Layouts des Web-Clients

### Header-Farbe

Ordner wwwroot/Views/Shared/_Layout.cshtml
Zeile 83 : FarbCode ändern 
pane.PaneStyle.BackColor = System.Drawing.ColorTranslator.FromHtml("#FF0000");

### Breadcrumbs/ Navigations-Pfeile

Ordner wwwroot/Content/site.css
Farben an verschiedenen Stellen/Objekten ändern

### Logo

Ordner wwwroot/Content/images

Bild mit Bezeichnung "logo.png"
Größe 456px x 96px

### Icons

Zentrale Ablage auf "Icon-Server": https://icons.planning-factory.com
in einem Ordner: Ordnerpfad wird in dFactories hinterlegt. Spalte "ImageName"

### Konfiguration statischer Html-Seiten als Web-Pivots

````SQL
/*
GET Operation for determining the Websites, useable with this Factory

Dependencies:
	 - Functions: 
		- sx_pf_pProtectString
		- sx_pf_pProtectID
		- sx_pf_Determine_TransactionUsername
	 - Stored Procedures:
		- sx_pf_pGET_FactoryReadRight
		- sx_pf_pGET_FactoryWriteRight
		- sx_pf_pPOST_API_LogEntry
04/2017 for PlanningFactory 4.0
Gerd Tautenhahn for saxess-software gmbh
Return Value according to HTTP Standard

THIS PROCEDURE IS DEPRECIATED, WILL BE REPLACED BY GET_FACTORY_URL, GET_FACTORY_HTML

Test call

DECLARE @RESULT AS NVARCHAR(255)
EXEC @RESULT = sx_pf_GET_FactoryWebsites 'SQL','ZT'
PRINT @RESULT
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sx_pf_GET_FactoryWebsites]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sx_pf_GET_FactoryWebsites];
GO

CREATE  PROCEDURE [dbo].[sx_pf_GET_FactoryWebsites]
		@Username AS NVARCHAR(255),
		@FactoryID AS NVARCHAR(255)
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @FactoryKey AS INT = 0;
	DECLARE @Right AS NVARCHAR(10);
	DECLARE @TransactUsername AS NVARCHAR(255);
	DECLARE @ProcedureName AS NVARCHAR (255) = OBJECT_NAME(@@PROCID);
	DECLARE @ParameterString AS NVARCHAR (MAX) = N'''' + ISNULL(@Username, N'NULL') + N''',''' + ISNULL(@FactoryID, N'NULL') + N'''';
	DECLARE @EffectedRows AS INTEGER = 0;						-- SET during Execution
	DECLARE @ResultCode AS INTEGER = 501;						-- SET during Execution
	DECLARE @TimestampCall AS DATETIME = CURRENT_TIMESTAMP;
	DECLARE @Comment AS NVARCHAR (2000) = N'';					-- SET during Execution

	-- STEP 0.1 - NULL Protection
	IF @Username IS NULL SET @Username = N'';
	IF @FactoryID IS NULL SET @FactoryID = N'';

	BEGIN TRY
		BEGIN TRANSACTION ONE

		-- STEP 0.2 - Protect input parameters
		SET @Username = [dbo].[sx_pf_pProtectString] (@Username);
		SET @FactoryID = [dbo].[sx_pf_pProtectID] (@FactoryID);

		IF @FactoryID = N''		
		BEGIN
			SET @ResultCode = 404;
			RAISERROR('Empty input parameters', 16 ,10);
		END;
		
		-- STEP 1.1 - Determine transaction user
		SELECT @TransactUsername = [dbo].[sx_pf_Determine_TransactionUsername] (@Username);

		IF @TransactUsername  = N'403' 
		BEGIN
			SET @ResultCode = 403;
			RAISERROR('Transaction user don`t exists', 16, 10);
		END;

		-- STEP 1.3 - Determine keys
		SELECT @FactoryKey = FactoryKey FROM [dbo].[sx_pf_dFactories] WHERE FactoryID = @FactoryID;

		IF @FactoryKey = 0	
		BEGIN
			SET @ResultCode = 404;
			RAISERROR('Keys don`t exists', 16, 10);
		END;

		-- STEP 2 - Check rights
		EXEC @ResultCode = [dbo].[sx_pf_pGET_FactoryWriteRight] @TransactUsername, @FactoryID;

		IF @ResultCode = 200
		BEGIN
			SET @Right = N'Write';
		END ELSE BEGIN
			EXEC @ResultCode = [dbo].[sx_pf_pGET_FactoryReadRight] @TransactUsername, @FactoryID;

			IF @ResultCode = 200
			BEGIN
				SET @Right = N'Read';
			END ELSE BEGIN 
				RAISERROR('Invalid rights', 16, 10);
			END;
		END;
		

		-- STEP 3. Show values of type Websites_*
		-- Mock
		IF  @FactoryID = '00'
			SELECT TOP 1
				 FactoryID
				,'Website_1'   AS WebsiteID
				,'https://saxess-software.github.io/TeamBoard/index/Webseite_missio_00.html' AS WebsiteURL
				,'Missio'  AS WebsiteName
				--,CommentDev   --
				--,Unit		--
				,''  AS Layout
				,0	AS ChartType -- due to the fact, that POST can bring <#NV> and they should harmonize
				-- ,Scale
				-- ,IsROSystemProperty 
				-- ,FormatID
				,'Write' AS [Right]
			FROM dbo.sx_pf_dFactories WHERE FactoryKey = @FactoryKey

		ELSE 

			SELECT
				 FactoryID
				,'Website_1'   AS WebsiteID
				,'https://saxess-software.github.io/TeamBoard/index/Webseite_missio_GER.html' AS WebsiteURL
				,'Missio'  AS WebsiteName
				--,CommentDev   --
				--,Unit		--
				,''  AS Layout
				,0	AS ChartType -- due to the fact, that POST can bring <#NV> and they should harmonize
				-- ,Scale
				-- ,IsROSystemProperty 
				-- ,FormatID
				,'Write' AS [Right]
			FROM dbo.sx_pf_dFactories WHERE FactoryKey = @FactoryKey

			


		/*
		SELECT  
			 FactoryID
			,PropertyID   AS PivotID
			,PropertyName AS PivotProcedureName
			,CommentUser  AS PivotName
			--,CommentDev   --
			--,Unit		--
			,ValueText  AS Layout
			,CAST(ValueInt AS NVARCHAR)	AS ChartType -- due to the fact, that POST can bring <#NV> and they should harmonize
			-- ,Scale
			-- ,IsROSystemProperty 
			-- ,FormatID
			,@Right AS [Right]
		FROM [dbo].[sx_pf_gFactories]
		WHERE FactoryKey = @FactoryKey AND PropertyID like 'Website_%'
		ORDER BY ISNULL(TRY_CAST(PropertyID AS INT), 999999999), PropertyID;
		*/
		SET @EffectedRows = @@ROWCOUNT;

		COMMIT TRANSACTION ONE;
	END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION ONE;		

		IF @Error_state <> 10 BEGIN
			SET @ResultCode = 500;		
			PRINT 'Rollback due to not executable command.';
		END
		ELSE IF @ResultCode IS NULL OR @ResultCode/100 = 2
		BEGIN
			SET @ResultCode = 500;	
		END;
	END CATCH

	EXEC [dbo].[sx_pf_pPOST_API_LogEntry] @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;
	RETURN @ResultCode;
END
GO

GRANT EXECUTE ON OBJECT ::[dbo].[sx_pf_GET_FactoryWebsites] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[dbo].[sx_pf_GET_FactoryWebsites] TO pf_PlanningFactoryService;

````SQL
