/*
Import a CSV file of a given structure 

Dependencies: no

02/2017 for PlanningFactory 4.0
Gerd Tautenhahn for saxess-software gmbh
Return Value according to HTTP Standard

Test call
1. @Filepath is empty => 404 Not Found
2. @Filepath is invalid => 404 Not Found
3. @Filepath don`t contain filename => 404 Not Found
4. All ok => 200 OK

DECLARE @RC INT;
EXECUTE @RC = [sx_st_Accounting] N'C:\winscp\Part_2016.csv' 	
PRINT @RC
*/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sx_st_Accounting]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[sx_st_Accounting];
GO

CREATE PROCEDURE [dbo].[sx_st_Accounting]
	@Filepath NVARCHAR(MAX)
AS 
BEGIN
	SET NOCOUNT ON;

	DECLARE @FileName NVARCHAR(MAX) = N'';
	DECLARE @ResultCode AS INT = 501;			-- SET during Execution
	DECLARE @Comment AS NVARCHAR(2000) = N'';	-- SET during Execution

	BEGIN TRY
		BEGIN TRANSACTION ONE

		-- STEP 0.1 - NULL Protection
		IF @Filepath IS NULL
		BEGIN
			SET @ResultCode = 404;
			RAISERROR('Empty input parameters', 16, 10);
		END;

		-- STEP 0.2 - Protect input parameters
		IF PATINDEX(N'%--%', @Filepath) > 0
			OR PATINDEX(N'%/*%', @Filepath) > 0
			OR PATINDEX(N'%*\%', @Filepath) > 0
			OR PATINDEX(N'%''%', @Filepath) > 0
		BEGIN
			SET @ResultCode = 404;
			RAISERROR('Invalid input parameters', 16, 10);
		END;
		
		-- STEP 1.2 - Determine filename
		SET @FileName = SUBSTRING(@Filepath, LEN(@Filepath) - PATINDEX(N'%\%', REVERSE(@Filepath)) + 2, 512);
		SET @FileName = LEFT(@FileName, LEN(@FileName) - 4);
				
		IF @FileName IS NULL
		BEGIN
			SET @ResultCode = 404;
			RAISERROR('File name not found', 16, 10);
		END;
		
		IF OBJECT_ID('tempdb..#temp_headersCSV') IS NOT NULL
		BEGIN
			DROP TABLE #temp_headersCSV;
		END;			
		
		CREATE TABLE #temp_headersCSV (Val NVARCHAR(MAX));

		DECLARE @sql NVARCHAR(MAX) = N'			
			BULK INSERT #temp_headersCSV
			FROM N''' + @Filepath + N'''
			WITH ( 
				FIRSTROW = 2
				, LASTROW = 2
			)';

		EXECUTE sp_executesql @sql;

		IF OBJECT_ID('tempdb..#temp_datesCSV') IS NOT NULL
		BEGIN
			DROP TABLE #temp_datesCSV;
		END;			
		
		CREATE TABLE #temp_datesCSV (Y INT, M INT, Name AS RIGHT(N'000' + CAST(Y AS NVARCHAR(MAX)), 4) + RIGHT(N'0' + CAST(M AS NVARCHAR(MAX)), 2));
				 
 		DECLARE @headers NVARCHAR(MAX);

		SELECT TOP 1 @headers = Val FROM #temp_headersCSV;

		SET @headers = RIGHT(@headers, LEN(@headers) - PATINDEX(N'%;H;%', @headers) - 2);
		SET @headers = LEFT(@headers, LEN(@headers) - PATINDEX(N'%;H;%', REVERSE(@headers)));
		SET @headers = REPLACE(@headers, N';S;H', '') + N';';

		DECLARE @colIndex INT = PATINDEX(N'%/%', @headers);
		
		WHILE (@colIndex > 0)
		BEGIN
			DECLARE @month NVARCHAR(MAX) = SUBSTRING(@headers, 0, @colIndex);
			
			SELECT @month = CASE @month 
						WHEN N'Jan' THEN '01'
						WHEN N'Feb' THEN '02'
						WHEN N'Mrz' THEN '03'
						WHEN N'Apr' THEN '04'
						WHEN N'Mai' THEN '05'
						WHEN N'Jun' THEN '06'
						WHEN N'Jul' THEN '07'
						WHEN N'Aug' THEN '08'
						WHEN N'Sep' THEN '09'
						WHEN N'Okt' THEN '10'
						WHEN N'Nov' THEN '11'
						WHEN N'Dez' THEN '12'
					END;

			INSERT INTO	#temp_datesCSV(Y, M)
			VALUES (SUBSTRING(@headers, @colIndex + 1, 4), @month);

			SET @headers = SUBSTRING(@headers, @colIndex + 6, LEN(@headers));
			SET @colIndex = PATINDEX(N'%/%', @headers);
		END;
	
		INSERT INTO	#temp_datesCSV(Y, M)
		SELECT MIN(Y), 00
		FROM #temp_datesCSV 
		UNION ALL
		SELECT MAX(Y), 13
		FROM #temp_datesCSV; 

		SET @sql = N'
			IF OBJECT_ID(''tempdb..#temp_AccountingCSV'') IS NOT NULL
			BEGIN
				DROP TABLE #temp_AccountingCSV;
			END;

			CREATE TABLE #temp_AccountingCSV (
				AccountNumber NVARCHAR(MAX)	NULL
				, AccountName NVARCHAR(MAX) NULL';
		
		SELECT @sql = @sql + N'
		, V' + Name + N' NVARCHAR(MAX) NULL, S'	+ Name + N' NVARCHAR(MAX) NULL, H' + Name + ' NVARCHAR(MAX) NULL'
		FROM #temp_datesCSV
		ORDER BY Y, M;
		
		SET @sql = @sql + N');';
	
		SET @sql = @sql + N'
			BULK INSERT #temp_AccountingCSV
			FROM N''' + @Filepath + N'''
			WITH ( 
				FIRSTROW = 3
				, FIELDTERMINATOR = '';'' 
			);';
 													

		SET @sql = @sql + N'
		;WITH csv AS (
			SELECT AccountNumber, AccountName';

		SELECT @sql = @sql + N'
		, CASE WHEN H' + Name + N' = ''H'' THEN -CAST(REPLACE(REPLACE(V' + Name + N',''.'',''''),'','',''.'') AS MONEY) ELSE CAST(REPLACE(REPLACE(V'
			+ Name + N',''.'',''''),'','',''.'') AS MONEY) END V' + Name 
		FROM #temp_datesCSV
		ORDER BY Y, M;

		SET @sql = @sql + N'
			FROM #temp_AccountingCSV
			)
			, accs AS (
				SELECT AccountNumber, AccountName, [Date], [Value]
				FROM csv
				UNPIVOT	([Value] FOR [Date] IN
					(';

		SELECT @sql = @sql + N'V' + Name + N', '
		FROM #temp_datesCSV
		ORDER BY Y, M;

		SET @sql = LEFT(@sql, LEN(@sql) - 1);

		SET @sql = @sql + N')
			) AS unpvt
		)
		SELECT N''' + @FileName + N''' AS CompanyCode
			, AccountNumber, AccountName
			, CAST(RIGHT([Date], 2) AS INT) AS [Month]
			, CAST(SUBSTRING([Date], 2, 4) AS INT) AS [YEAR]
			, Value
		FROM accs
		ORDER BY 2, 4, 3;';

		EXECUTE sp_executesql @sql; 

		SET @ResultCode = 200;

		COMMIT TRANSACTION ONE;
	END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION ONE;		

		IF @Error_state <> 10 BEGIN
			SET @ResultCode = 500;
			PRINT 'Rollback due to not executable command' + ISNULL(': '+ @Comment, '.');
		END
		ELSE IF @ResultCode IS NULL OR @ResultCode/100 = 2
		BEGIN
			SET @ResultCode = 500;	
		END;
	END CATCH

	RETURN @ResultCode;
END;
GO 