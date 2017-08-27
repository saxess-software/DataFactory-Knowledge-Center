/*
Execute Script in all fitting Databases
*******************************************

An SQL Script has to be executed in all databases of an SQL Server instance, which match certain criterias.

Variable: Path to Script

Loop over all databases, and

	1. Check if the database has a table "sx_pf_gCluster", if not skip this database
	2. Execute the Query "SELECT ValueInt FROM sx_pf_gCluster WHERE PropertyID = 'DB05'" if the Query return 1 go on, else skip
	3. Execute the Script in this Database
*/

DECLARE @PathToScript VARCHAR(256) = 'C:\tmp\DataFactory T_REST_API 4.0.64.sql' -- script to execute on database
	, @OutputPath VARCHAR(256) = 'STDOUT' -- path to save script output, leave NULL if you don`t need to save output, type 'STDOUT' if you want output to console
	, @StopOnError BIT = 1; -- stop execution on error or [xp_cmdshell] result <> 0

DECLARE 
	@dbName VARCHAR(128)
	, @sqlString NVARCHAR(MAX)
	, @parmDefinition NVARCHAR(30) = '@paramOUT BIT OUTPUT'
	, @query VARCHAR(1000)
	, @tableExists BIT
	, @execResult INT;

DECLARE @Error NVARCHAR(MAX)
	, @ErrorSeverity INT
	, @ErrorState INT;

SET NOCOUNT ON;
EXEC [master].[dbo].[sp_configure] 'show advanced options', 1; 
RECONFIGURE;
EXEC [master].[dbo].[sp_configure] 'xp_cmdshell', 1;
RECONFIGURE;

DECLARE db_cursor CURSOR FOR  
	SELECT [name]
	FROM [master].[sys].[sysdatabases];
 
OPEN db_cursor;  
FETCH NEXT FROM db_cursor INTO @dbName; 

BEGIN TRY 
 
	WHILE @@FETCH_STATUS = 0   
	BEGIN   
		SET @tableExists = NULL;

		SET @SQLString = N'SELECT @paramOUT = 1 FROM [' + @dbName + N'].[sys].[tables] WHERE [name] LIKE ''sx_pf_gCluster''';
	
		EXECUTE [master].[dbo].[sp_executesql] @SQLString, @parmDefinition, @paramOUT = @tableExists OUTPUT;

		IF @tableExists = 1
		BEGIN
			SET @SQLString = N'SELECT @paramOUT = 0 FROM [' + @dbName + N']..[sx_pf_gCluster] WHERE [PropertyID] = ''DB05'' AND [ValueInt] = 1';
			EXECUTE [master].[dbo].[sp_executesql] @SQLString, @parmDefinition, @paramOUT = @tableExists OUTPUT;

			IF @tableExists = 0
			BEGIN
				-- for help about sqlcmd see https://msdn.microsoft.com/en-us/library/ms162773.aspx
				SELECT @query = 'sqlcmd -S "' + CONVERT(NVARCHAR(MAX), SERVERPROPERTY ('servername')) + '" -b -d "' + @dbName + '" -i "' + @PathToScript + '" -f 65001';
		
				IF NOT @OutputPath IS NULL AND @OutputPath <> 'STDOUT'
					SET @query += ' -u -o "' + @OutputPath + '"';
				
				-- for help about xp_cmdshell see https://msdn.microsoft.com/en-us/library/aa260689(SQL.80).aspx
				IF @OutputPath = 'STDOUT'
					EXEC @execResult = [master].[dbo].[xp_cmdshell] @query;
				ELSE
					EXEC @execResult = [master].[dbo].[xp_cmdshell] @query, NO_OUTPUT;

				IF @execResult = 0 AND @OutputPath = 'STDOUT'
					PRINT 'SUCCESSFUL execute script "' + @PathToScript + '" on [' + CONVERT(NVARCHAR(MAX), SERVERPROPERTY ('servername')) + '].['+ @dbName +']';
				ELSE IF @StopOnError = 1 AND @execResult <> 0
				BEGIN
					SET @Error = 'ERROR execute script "' + @PathToScript + '" on [' + CONVERT(NVARCHAR(MAX), SERVERPROPERTY ('servername')) + '].['+ @dbName +']';
					RAISERROR (@Error, 16, 1);					
				END;

			END;
		END;

		FETCH NEXT FROM db_cursor INTO @dbName;
	END;

END TRY
BEGIN CATCH

	SELECT @Error = ERROR_MESSAGE()
		, @ErrorSeverity = ERROR_SEVERITY()
		, @ErrorState = ERROR_STATE();

END CATCH;

CLOSE db_cursor;  
DEALLOCATE db_cursor;

EXEC [master].[dbo].[sp_configure] 'xp_cmdshell', 0; 
RECONFIGURE;
EXEC [master].[dbo].[sp_configure] 'show advanced options', 0; 
RECONFIGURE;  
SET NOCOUNT OFF;

IF @StopOnError = 1 AND NOT @Error IS NULL
	RAISERROR (@Error, @ErrorSeverity, @ErrorState);