/*
Operation to stage Data from a Source System into DataFactory als Table  - the procedure will prevent data loss, if Source temporary empty or not reachable

Requires API 4.0.74 or higher with Table sx_pf_Progress_Log

Operation will:
- Count the source rows
- Count the rows already existing in Target Table
- Transfer the data in a transaction
- Count the rows in the Target Table after Transfer
- Rollback Transaction if the Number of rows in Target is to small, compared to the number of rows in Source and Target before Transfer

04/2018 for DataFactory 4.0
Gerd Tautenhahn for saxess-software gmbh
Return Value according to HTTP Standard

Testcall
EXEC staging.spSampleSource ''
SELECT * FROM staging.tSampleTarget

*/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'staging.spSampleTarget') AND type in (N'P', N'PC'))		-- SET Name
	DROP PROCEDURE staging.spSampleTarget																					-- SET Name
GO

CREATE PROCEDURE staging.spSampleTarget																						-- SET Name
	@Parameter1 NVARCHAR(255)																								-- SET Parameter if needed

AS 
BEGIN
	SET NOCOUNT ON;

	-- initialize
	DECLARE @ProcedureName		NVARCHAR (255)	= OBJECT_SCHEMA_NAME(@@PROCID) + N'.' + OBJECT_NAME(@@PROCID);
	DECLARE @ParameterString	NVARCHAR (MAX)	= N'''' 
				+ ISNULL(@Parameter1, N'NULL')	+ N'''';
	DECLARE @ValueText			NVARCHAR(255)	= @ProcedureName + N' ' + @ParameterString;
	DECLARE @ValueInt			BIGINT			= 0;
	DECLARE @Resultcode			INT				= 0;
	DECLARE @MainProcess		NVARCHAR(255)	= 'Staging';																-- SET Name
	DECLARE @SubProcess			NVARCHAR(255)	= 'Personal';																-- SET Name
	DECLARE @Step				NVARCHAR(255)	= 'staging.tSampleSource1';													-- SET Name
	DECLARE @ErrorMessage		NVARCHAR(255)	= '';
	DECLARE @Error_state		INT				= 0;

	-- RowCounting before / after Staging
	DECLARE @SourceRowCount		BIGINT = 0;
	DECLARE @TargetRowCount		BIGINT = 0;
	DECLARE @LastTargetRowCount	BIGINT = 0;
	DECLARE @ProgressLevel		INT	   = 0;
	
	-- Write Start of Staging to Process Log
	SET @ValueText	= 'Prozess gestartet.';
	SET @Resultcode = 200;
	SET @ValueInt	= 0;
	EXEC dbo.sx_pf_pPOST_Process_LogEntry @MainProcess,@SubProcess,@Step,'Start',@ResultCode,@ValueText,@ValueInt;

	-- Try to count the records in the source and in target
	BEGIN TRY
		SELECT 
			@SourceRowCount = COUNT(*)																					-- SET CountQuery for Source
		FROM dbo.tSampleSource;

		SET @ValueText	= 'Anzahl der Zeilen in Quelle erfolgreich ermittelt.';
		SET @Resultcode = 200;
		SET @ValueInt	= @SourceRowCount;
		EXEC dbo.sx_pf_pPOST_Process_LogEntry @MainProcess,@SubProcess,@Step,'Info',@ResultCode,@ValueText,@ValueInt;

		SELECT 
			@LastTargetRowCount = COUNT(*)																				-- SET CountQuery for existing Target
		FROM staging.tSampleTarget;

		SET @ValueText	= 'Anzahl der aktuellen Zeilen im Ziel erfolgreich ermittelt.';
		SET @Resultcode = 200;
		SET @ValueInt	= @LastTargetRowCount;
		EXEC dbo.sx_pf_pPOST_Process_LogEntry @MainProcess,@SubProcess,@Step,'Info',@ResultCode,@ValueText,@ValueInt;

		SET @ProgressLevel = 1;
	END TRY
	BEGIN CATCH
		SET @ValueText	= 'Anzahl der Zeilen in Quelle konnte NICHT ermittelt werden.';
		SET @Resultcode = 500;
		SET @ValueInt	= 0;
		EXEC dbo.sx_pf_pPOST_Process_LogEntry @MainProcess,@SubProcess,@Step,'Info',@ResultCode,@ValueText,@ValueInt;
	END CATCH

	-- TRY to stage the Data
	IF @ProgressLevel = 1
		BEGIN TRY
			BEGIN TRANSACTION staging;

				-- Execute Staging 
				TRUNCATE TABLE staging.tSampleTarget;																	-- SET Staging Query
					INSERT INTO staging.tSampleTarget
							SELECT * FROM dbo.tSampleSource;

				-- Count Rows in Staging Table
				SELECT @TargetRowCount = COUNT(*) FROM staging.tSampleTarget;											-- SET Target Count Query

				IF     @TargetRowCount = 0 
					OR @TargetRowCount < 0.9 * @SourceRowCount															-- SET Maybe adjust minimum transfer factor
					OR @TargetRowCount < 0.9 * @LastTargetRowCount
					BEGIN
						SET @ProgressLevel = 2;
						RAISERROR('Zeilenzahl nicht ausreichend', 16 ,10);
					END
				SET @ValueText	= 'Daten erfolgreich übertragen.';
				SET @Resultcode = 200;
				SET @ValueInt	= @TargetRowCount;
				
				EXEC dbo.sx_pf_pPOST_Process_LogEntry @MainProcess,@SubProcess,@Step,'Info',@ResultCode,@ValueText,@ValueInt;

				SET @ProgressLevel = 3;
				COMMIT TRANSACTION staging;
		END TRY
		BEGIN CATCH
			SET @Error_state	= ERROR_STATE();
			SET @ErrorMessage	= ERROR_MESSAGE();

			IF @ProgressLevel	= 2
				BEGIN
					SET @ValueText	= 'Zeilenzahl nicht ausreichend, Staging abgebrochen';
					SET @ValueInt	= @TargetRowCount;
					PRINT 'Rollback due target number of rows not reached.';
				END
			ELSE
				BEGIN
					SET @ValueText	= N'Error with Rollback '+ CAST(@Error_state AS NVARCHAR(255)) + N' ' + @ErrorMessage;
					SET @ValueInt	= 0;
					PRINT 'Rollback due to technical problem.';
				END

			ROLLBACK TRANSACTION staging;		

			SET @ResultCode = 500;
			EXEC dbo.sx_pf_pPOST_Process_LogEntry @MainProcess,@SubProcess,@Step,'Info',@ResultCode,@ValueText,@ValueInt;
		END CATCH
	
	IF @Resultcode		= 200
		SET @ValueText	= 'Prozess erfolgreich beendet.'
	ELSE 
		SET @ValueText	= 'Prozess nach Fehler gestoppt und rückgängig gemacht.'
		SET @ValueInt	= 0
	EXEC dbo.sx_pf_pPOST_Process_LogEntry @MainProcess,@SubProcess,@Step,'End',@ResultCode,@ValueText,@ValueInt;
	RETURN @ResultCode;
END
GO


/*
Sample Data 

CREATE TABLE dbo.tSampleSource
	(
		Value INT NOT NULL
	)
GO

CREATE TABLE staging.tSampleTarget
	(
		Value INT NOT NULL
	)
GO

INSERT INTO dbo.tSampleSource VALUES (5)
GO 5000


Testing:
- Source has much less rows than existing Target	--> Works fine
- Number of transfered Rows smaller than  Source	--> Works fine
- Source don't exist / can't be reached				--> Process crashes, but no DataLoss
- Target don't exist								--> Process crashes, ok, nothing there to protect

*/
