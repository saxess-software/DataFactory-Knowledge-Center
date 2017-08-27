/*
Target:
Write as script for periodic execution, it should backup all *_PROD Databases and restore them as *_DEMO Databases for testing purpose.

Preconditions:
- one SQL Server 2012 Instanz
- many Databases on this Server
- some Databases are named *_PROD

Task:
Write a SQL Script, which will
- Backup all Databases with Name *_PROD into a Directory (Config Variable)
- Restore all this Backups as *_DEMO Database and replace the existing Database during this (Default SQL Server Filepath, but rename files to *_DEMO)
- The Script will be called two times per day by Windows taskplaner
- Execute in every restored DEMO Database the Command "UPDATE sx_pf_rRights SET [Right] = 'Write' WHERE UserName = 'public'"
*/

DECLARE @backupPath NVARCHAR(256) = N'C:\Backup\';

DECLARE @dbName NVARCHAR(128), 
	@backupDbName NVARCHAR(128),  
	@dbFilename NVARCHAR(128),
	@backupFilename NVARCHAR(260),
	@dbid SMALLINT,
	@backupSQL NVARCHAR(MAX), 
	@serverDataPath NVARCHAR(MAX),
	@serverLogPath NVARCHAR(MAX);

SELECT 
    @serverDataPath = CONVERT(NVARCHAR(MAX), serverproperty('InstanceDefaultDataPath')),
    @serverLogPath = CONVERT(NVARCHAR(MAX), serverproperty('InstanceDefaultLogPath'));

DECLARE db_cursor CURSOR FOR  
	SELECT [dbid], [name]
	FROM [master].[sys].[sysdatabases]
	WHERE [name] LIKE '%_PROD';
 
OPEN db_cursor;  
FETCH NEXT FROM db_cursor INTO @dbid, @dbName;   
 
WHILE @@FETCH_STATUS = 0   
BEGIN   
	SET @backupFilename = @backupPath + @dbName + N'.bak';  
		
	BACKUP DATABASE @dbName TO DISK = @backupFilename
		WITH FORMAT;
		
	SET @backupDbName = LEFT(@dbName, LEN(@dbName) - 4) + N'DEMO';

	SET @backupSQL = N'RESTORE DATABASE [' + @backupDbName + N'] FROM DISK = ''' + @backupFilename + N''' WITH REPLACE';
	
	SELECT @backupSQL += N', MOVE ''' + [name] + N''' TO ''' + 
		CASE WHEN [filename] LIKE '%.ldf' THEN  @serverLogPath + [name] + '_bak.ldf''' ELSE @serverLogPath + [name] + '_bak.mdf''' END 
	FROM [master].[sys].[sysaltfiles]
	WHERE [dbid] = @dbid;

	SET @backupSQL += N'UPDATE [' + @backupDbName + '].[dbo].[sx_pf_rRights] SET [Right] = ''Write'' WHERE UserName = ''public''';

	EXEC sp_executesql @backupSQL;

	FETCH NEXT FROM db_cursor INTO @dbid, @dbName;
END   
 
CLOSE db_cursor;  
DEALLOCATE db_cursor;
