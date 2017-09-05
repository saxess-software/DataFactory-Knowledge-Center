/*
GET Operation for receiving a context sensitiv List
API deliviers List Values fitting to the sended context Parameters
Procedure must be editend to fit user needs and recreated after each API Update
When updating this procedure, you must reset the rights for it

Dependencies:
	 - Functions: 
		- sx_pf_pProtectString
		- sx_pf_pProtectID
		- sx_pf_Determine_TransactionUsername
	 - Stored Procedures:
		- sx_pf_pPOST_API_LogEntry

06/2017 for PlanningFactory 4.0
Gerd Tautenhahn for saxess-software gmbh
Return Value according to HTTP Standard

Test call

DECLARE @RESULT AS NVARCHAR(255)
--should return Data and 200
EXEC @RESULT = sx_pf_GET_FlexList 'SQL','ABQ_S','3','1','RS','','','r'
PRINT @RESULT
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sx_pf_GET_FlexList]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sx_pf_GET_FlexList];
GO

CREATE PROCEDURE [dbo].[sx_pf_GET_FlexList]
	@Username AS NVARCHAR(255)
	,@FactoryID AS NVARCHAR(255)
	,@ProductLineID AS NVARCHAR(255)
	,@ProductID AS NVARCHAR(255)
	,@ValueSeriesID AS NVARCHAR(255)
	,@GlobalattributeNumber AS NVARCHAR(255)
	,@PageType AS NVARCHAR(255)    -- PDT (ProductDataTable), PLP (ProductLinePage)
	,@SearchString AS NVARCHAR(255)  --any Substring from searched list values
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @TransactUsername NVARCHAR(255);
	DECLARE @ProcedureName AS NVARCHAR (255) = OBJECT_NAME(@@PROCID);
	DECLARE @EffectedRows AS INT = 0;						-- SET during Execution
	DECLARE @ResultCode AS INT = 501;						-- SET during Execution
	DECLARE @TimestampCall AS DATETIME = CURRENT_TIMESTAMP;
	DECLARE @Comment AS NVARCHAR (2000) = N'';				-- SET during Execution
	DECLARE @SearchDoneFlag AS INT = 0;

	DECLARE @ParameterString AS NVARCHAR (MAX) = N'''' + ISNULL(@Username, N'NULL') + N''',''' + ISNULL(@FactoryID, N'NULL') + N''',''' + ISNULL(@ProductLineID, N'NULL')
		 + N''',''' + ISNULL(@ProductID, N'NULL') + N''',''' + ISNULL(@ValueSeriesID, N'NULL') + N''',''' + ISNULL(@GlobalattributeNumber, N'NULL')  
		+ N''',''' + ISNULL(@PageType, N'NULL') + N''',''' +  ISNULL(@SearchString, N'NULL') + N'''';  

	-- STEP 0.1 - NULL Protection
	IF @Username IS NULL SET @Username = N'';
	IF @FactoryID IS NULL SET @FactoryID = N'';
	IF @ProductLineID IS NULL SET @ProductlineID = N'';
	IF @ProductID IS NULL SET @ProductID = N'';
	IF @ValueSeriesID IS NULL SET @ValueSeriesID = N'';
	IF @GlobalattributeNumber IS NULL SET @GlobalattributeNumber = '';
	IF @PageType IS NULL SET @PageType = N'';

	SET @SearchString = '%' + ISNULL(@SearchString, '') + '%';

	BEGIN TRY
		BEGIN TRANSACTION ONE;

		-- STEP 0.2 - Protect input parameters
		SET @Username = [dbo].[sx_pf_pProtectString] (@Username);
		SET @FactoryID = [dbo].[sx_pf_pProtectID] (@FactoryID);
		SET @ProductLineID = [dbo].[sx_pf_pProtectID] (@ProductLineID);
		SET @ProductID = [dbo].[sx_pf_pProtectID] (@ProductID);
		SET @ValueSeriesID = [dbo].[sx_pf_pProtectID] (@ValueSeriesID);
				
		-- STEP 1 - Determine transaction user
		SELECT @TransactUsername = [dbo].[sx_pf_Determine_TransactionUsername] (@Username);

		IF @TransactUsername  = N'403' 
		BEGIN
			SET @ResultCode = 403;
			RAISERROR('Transaction user don`t exists', 16, 10);
		END;


		/*
		DEFINITION DER FLEX LISTEN ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		First Column must be "Hint" an commits the display hint to the frontend
		Second Column must have identifier character, its send back to the selected cell
		Column Names must have an Alias (AS Displayname) with one "_", after which 
			Orientation (L=Left, R= Right, C = Center)
			DataType (M=Money, S=String, I=Int) 
			ColumnWidth 
			is coded as Frontend Parameter
		*/
	
		-- Raumauswahl bei Ressourcengruppen und allen Raum ValueSeries
		IF (@ValueSeriesID = N'RS' AND EXISTS(
												SELECT Template FROM [dbo].[sx_pf_dProducts] 
												WHERE FactoryID = @FactoryID AND ProductLineID = @ProductLineID AND ProductID = @ProductID AND Template = N'BFW_RessourcenG_VM'
											)
			)
			OR 
			@ValueSeriesID = 'Raum'

			BEGIN
				SELECT
					 'Bitte einen Raum auswählen, im Eingabefeld kann per Teilwort gefiltert werden' AS Hint
					,RaumSuchCode AS RaumSuchCode_LS200
					,Gebäudekomplex AS Ort_LS200
				FROM staging.tRäume
		 
				WHERE RaumSuchCode LIKE @SearchString OR Gebäudekomplex LIKE @SearchString
		 
				ORDER BY RaumSuchCode;
				SET @SearchDoneFlag = 1;
		END

		-- Sachkontoauswahl auf allen SKTO ValueSeries
		IF LEFT(@ValueSeriesID,4) = N'SKTO' 
			BEGIN
				SELECT
					 'Bitte ein Sachkonto auswählen, im Eingabefeld kann per Teilwort gefiltert werden' AS Hint
					,KontenID AS KontenID_LS80
					,KontenName AS Kontoname_LS200
				FROM staging.tKoReBuchungen
		 
				WHERE KontenID LIKE @SearchString OR KontenName LIKE @SearchString
		 
				GROUP BY KontenID, KontenName

				ORDER BY KontenID;
				SET @SearchDoneFlag = 1;
			END
		
		-- Kostenstellenauswahl auf allen KST ValueSeries
		IF LEFT(@ValueSeriesID,3) = N'KST' 
			BEGIN
				SELECT
					 'Bitte eine Kostenstelle auswählen, im Eingabefeld kann per Teilwort gefiltert werden' AS Hint
					,KostenstellenID AS KSTID_LS40
					,KostenstellenName AS KostenstellenName_LS200
					,FactoryNameShort AS Profitcenter_LS200

				FROM staging.tKostenstellenhierarchie
		 
				WHERE KostenstellenID LIKE @SearchString OR KostenstellenName LIKE @SearchString OR FactoryNameShort LIKE @SearchString
		
				ORDER BY KostenstellenID;

				SET @SearchDoneFlag = 1;
			END

		-- Dimensionsauswahl auf allen DIM ValueSeries
		IF LEFT(@ValueSeriesID,3) = N'DIM' 
			BEGIN
				SELECT
					 'Bitte eine Dimension auswählen, im Eingabefeld kann per Teilwort gefiltert werden' AS Hint
					,DimensionsID AS DIMID_LS40
					,DimensionsName AS DimensionsName_LS200

				FROM staging.tKoReBuchungen
		 
				WHERE DimensionsID  LIKE @SearchString OR DimensionsName LIKE @SearchString 

				GROUP BY DimensionsID, DimensionsName
		
				ORDER BY DimensionsID;

				SET @SearchDoneFlag = 1;
			END

		-- Vorlagenauswahl auf allen Vorl ValueSeries
		IF @ValueSeriesID = N'Vorl' 
			BEGIN
				SELECT
					 'Bitte eine Vorlage auswählen, im Eingabefeld kann per Teilwort gefiltert werden' AS Hint
					,Kuerzel AS Vorlage_LS40
					,Standort AS Standort_LS200

				FROM staging.tMassnahmenVorlagen
		 
				WHERE Kuerzel LIKE @SearchString OR Standort LIKE @SearchString 
		
				ORDER BY Kuerzel;

				SET @SearchDoneFlag = 1;
			END

		-- Ressourcengruppenauswahl auf allen RG ValueSeries
		IF LEFT(@ValueSeriesID,2) = N'RG' 
			BEGIN
				SELECT
					 'Bitte eine Ressourcengruppe auswählen, im Eingabefeld kann per Teilwort gefiltert werden' AS Hint
					,dP.ProductID AS RessourcenID_LS60
					,dP.NameShort AS RessourcenName_LS100

				FROM dbo.sx_pf_dProducts dP
		 
				WHERE 
					(
						dP.ProductID LIKE @SearchString OR
						dP.NameShort LIKE @SearchString
					) AND
					ProductlineID = 3 AND 
					dP.FactoryID = @FactoryID
		
				ORDER BY dP.NameShort;

				SET @SearchDoneFlag = 1;
			END



		IF @SearchDoneFlag = 0 
			SELECT 
				'Für diesen Kontext ist keine FlexSuche verfügbar' AS Hint
				,'Nothing' AS Content_LS50
				,'is all I have to offer for you.' AS Sorry_LS200




		--SELECT 
		---- First Column must be "Hint" an commits the display hint to the frontend
		---- Second Column must have identifier character, its send back to the selected cell
		---- Column Names must have an Alias (AS Displayname) with one "_", after which 
		--	-- Orientation (L=Left, R= Right, C = Center)
		--	-- DataType (M=Money, S=String, I=Int) 
		--	-- ColumnWidth 
		--	-- is coded as Frontend Parameter
		--	 Hint
		--	,RaumSuchCode AS RaumSuchCode_LS300
	
		-- FROM @FlexList
		 
		-- WHERE RaumSuchCode LIKE @SearchString
		 
		-- ORDER BY RaumSuchCode;


		SET @ResultCode = 200;

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

-- SET Rights
GRANT EXECUTE ON OBJECT ::[dbo].[sx_pf_GET_FlexList] TO pf_PlanningFactoryUser
GRANT EXECUTE ON OBJECT ::[dbo].[sx_pf_GET_FlexList] TO pf_PlanningFactoryService
GO
