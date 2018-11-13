/*
Author: 	Heathcliff Power
Created: 	2018/11
Summary:	Write all accounting records in global accounting record table
	EXEC [control].[spfBuchungsjournal] 'SQL'
	SELECT * FROM result.tfBuchungsjournal
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[spfBuchungsjournal]') AND type in (N'P', N'PC'))
DROP PROCEDURE [control].[spfBuchungsjournal]
GO

CREATE PROCEDURE [control].[spfBuchungsjournal]		
					(		@Username			NVARCHAR(255)		)
AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
	-- Procedure specific
	DECLARE @SolutionID				NVARCHAR(255)	= 'suVER'
	
	-- API log
	DECLARE @TransactUsername		NVARCHAR(255)	= N'';
	DECLARE @ProcedureName			NVARCHAR(255)	= OBJECT_SCHEMA_NAME(@@PROCID) + N'.' + OBJECT_NAME(@@PROCID);
	DECLARE @EffectedRows			INT 			= 0;						
	DECLARE @ResultCode				INT 			= 501;						
	DECLARE @TimestampCall			DATETIME 		= CURRENT_TIMESTAMP;
	DECLARE @Comment				NVARCHAR(2000) 	= N'';
	DECLARE @ParameterString		NVARCHAR(MAX)	= N''''
													+ ISNULL(@Username		, N'NULL')	+ N''','''	
													+ N'''';
													
-------------------------------------------------------------------------------------------------------------------
-- ##### GENERAL CHECKS ###########
BEGIN TRY
	BEGIN TRANSACTION [spfBuchungsjournal];
	
	-- Determine transaction user
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);
	
	IF @TransactUsername  = N'403' 
		BEGIN
			SET @ResultCode = 403;
			RAISERROR('Transaction user don`t exists', 16, 10);
		END;

-------------------------------------------------------------------------------------------------------------------
-- ##### DELETE ###########
	DELETE FROM result.tfBuchungsjournal WHERE SolutionID = @SolutionID
													
-------------------------------------------------------------------------------------------------------------------
-- ##### INSERT INTO ###########
	INSERT INTO result.tfBuchungsjournal		
		SELECT	 @SolutionID															AS SolutionID
				,fV.FactoryID + '-' + fV.ProductLineID  + '-' + fV.ProductID			AS UrsprungsID
				,fV.FactoryID															AS MandantenID
				,dP.GlobalAttribute1													AS KostenstellenID
				,tpkm.KTO_OUT															AS KontenID
				,fV.TimeID / 10000														AS Jahr
				,fV.TimeID / 100 % 100													AS Monat
				,fV.TimeID % 100														AS Tag
				,spdpl.NameShort														AS Buchungsgruppe
				,dP.NameShort															AS Buchungstext
				,CAST(fV.ValueInt AS MONEY) /dVS.Scale * spgve.ProfitLossEffect			AS Wert
		FROM	 dbo.sx_pf_fValues fV		
			LEFT JOIN dbo.sx_pf_dFactories dF		-- Mandantendaten
				ON	fV.FactoryKey = dF.FactoryKey
			LEFT JOIN dbo.sx_pf_dProductLines spdpl	 -- Buchungsgruppe
				ON fV.ProductLineKey = spdpl.ProductLineKey
			LEFT JOIN dbo.sx_pf_dProducts dP		-- Kostenstelleninfo	
				ON fV.ProductKey = dP.ProductKey
			LEFT JOIN dbo.sx_pf_dValueSeries dVS	-- Wertreiheneffekt
				ON fV.ValueSeriesKey = dVS.ValueSeriesKey
			LEFT JOIN dbo.sx_pf_gValueEffects spgve	-- Wertreihenvorzeichen
				ON dVS.Effect = spgve.EffectID
			LEFT JOIN param.tPivotKTO_MAPOUT tpkm 		-- Kontendaten
				ON fV.ValueSeriesID = tpkm.VSID AND dP.Template = tpkm.TMPL
			LEFT JOIN param.tPivotKST tPKst			-- Kostenstellendaten
				ON dP.GlobalAttribute1 = tPKst.KSTID
		WHERE	fV.FactoryID <> 'ZT' 	
			AND dVS.Effect IN ('Ertrag','Ertrag=Einzahlg','Kosten','Kosten=Auszahlg')			-- GuV-relevante Wertreihen

			SET @EffectedRows = +@@ROWCOUNT
			
-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode = 200

	COMMIT TRANSACTION [spfBuchungsjournal];
END TRY
BEGIN CATCH
	DECLARE @Error_state INT = ERROR_STATE();
	SET @Comment = ERROR_MESSAGE();

	ROLLBACK TRANSACTION [spfBuchungsjournal];		

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
GRANT EXECUTE ON OBJECT ::[control].[spfBuchungsjournal]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[control].[spfBuchungsjournal]  TO pf_PlanningFactoryService;
GO



