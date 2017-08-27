/*
Execute Script in all fitting Databases
*******************************************

An SQL Script has to be executed in all databases of an SQL Server instance, which match certain criterias.


Loop over all databases, and

	1. Check if the database has a table "sx_pf_gCluster", if not skip this database
	2. Check for blocked bulk actions "SELECT ValueInt FROM sx_pf_gCluster WHERE PropertyID = 'DB05'" if the Query return 1 go on, else skip
	3. Execute the SQL Command
*/

DECLARE @StopOnError BIT = 1; -- stop execution on error or [xp_cmdshell] result <> 0

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


DECLARE db_cursor CURSOR FOR  
	SELECT [name]
	FROM [master].[sys].[sysdatabases] WHERE name not IN ('master','tempdb','model','msdb') ;
 
OPEN db_cursor;  
FETCH NEXT FROM db_cursor INTO @dbName; 

BEGIN TRY 
 
	WHILE @@FETCH_STATUS = 0   
	BEGIN   
		SET @tableExists = NULL;

		-- check if database is a PlanningFactory Database
		SET @SQLString = N'SELECT @paramOUT = 1 FROM [' + @dbName + N'].[sys].[tables] WHERE [name] LIKE ''sx_pf_gCluster''';
	
		EXECUTE [master].[dbo].[sp_executesql] @SQLString, @parmDefinition, @paramOUT = @tableExists OUTPUT;

		IF @tableExists = 1
		BEGIN
			-- check if database is blocked for bulk script actions
			SET @SQLString = N'SELECT @paramOUT = 0 FROM [' + @dbName + N']..[sx_pf_gCluster] WHERE [PropertyID] = ''DB05'' AND [ValueInt] = 1';
			EXECUTE [master].[dbo].[sp_executesql] @SQLString, @parmDefinition, @paramOUT = @tableExists OUTPUT;

			IF @tableExists = 0
			BEGIN	
				Print 'Starting '+ @dbname;

				SET @sqlString = 'DELETE FROM '+ @dbname+ '.dbo.sx_pf_rRights WHERE Username = ''ayakovleva10@mail.ru''' 
				EXEC (@sqlstring)

				SET @sqlString = 'DELETE FROM '+ @dbname+ '.dbo.sx_pf_rUser WHERE Username = ''ayakovleva10@mail.ru''' 
				EXEC (@sqlstring)

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


IF @StopOnError = 1 AND NOT @Error IS NULL
	RAISERROR (@Error, @ErrorSeverity, @ErrorState);