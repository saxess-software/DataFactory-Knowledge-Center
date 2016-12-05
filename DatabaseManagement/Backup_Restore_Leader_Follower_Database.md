This script if useful to create regulary a copy of an Database by doing backup and restore of this database. We use it for:
  * Creation of a Demo Database to be demolished from a beautiful Solution Database

```SQL
/* Script to create a database (FollowerDB) periodically from an existing database (LeaderDB)

Preconditions
	1. The Leader Database must exist
	2. The FollowerDB must already exist
*/

DECLARE @FilePathBackup NVARCHAR (1000) = ''
DECLARE @DatabaseName_LeaderDB NVARCHAR (255) = ''
DECLARE @DatabaseName_FollowerDB NVARCHAR (255) = ''
DECLARE @SQL NVARCHAR (4000) = ''
DECLARE @LogicalFileNameLog_LeaderDB NVARCHAR (255) = ''
DECLARE @LogicalFileNameRows_LeaderDB NVARCHAR (255) = ''
DECLARE @FilePathLog_FollowerDB NVARCHAR (1000) = ''
DECLARE @FilePathRows_FollowerDB NVARCHAR (1000) = ''

--#######  CONFIG  ##############################################################################
SET @DatabaseName_LeaderDB = 'Leader'				-- CONFIG: Set Name of LeaderDB here
SET @DatabaseName_FollowerDB = 'Follower'			-- CONFIG: Set Name of existing FollowerDB here
SET @FilePathBackup = 'D:\tmp'						-- CONFIG: Set Path to any Folder, where a temporary backup from LeaderDB can be stored (no "\" at the End of path)
--###############################################################################################
SET @FilePathBackup = @FilePathBackup + '\' + @DatabaseName_LeaderDB + '.bak'

USE master
--Backup LeaderDB
BACKUP DATABASE @DatabaseName_LeaderDB TO DISK = @FilePathBackup WITH INIT

--Get logical Filenames from LeaderDB
SELECT @LogicalFileNameLog_LeaderDB = name
	FROM sys.master_files AS mf WHERE DB_NAME(database_id) = @DatabaseName_LeaderDB AND mf.type_desc = 'LOG'
SELECT @LogicalFileNameRows_LeaderDB = name
	FROM sys.master_files AS mf WHERE DB_NAME(database_id) = @DatabaseName_LeaderDB AND mf.type_desc = 'ROWS'

--Get Filepathes from FollowerDB
SELECT @FilePathLog_FollowerDB = mf.physical_name
	FROM sys.master_files AS mf WHERE DB_NAME(database_id) = @DatabaseName_FollowerDB AND mf.type_desc = 'LOG'
SELECT @FilePathRows_FollowerDB = mf.physical_name
	FROM sys.master_files AS mf WHERE DB_NAME(database_id) = @DatabaseName_FollowerDB AND mf.type_desc = 'ROWS'

--Kill all existing connections to FollowerDB
SET @SQL = 'ALTER DATABASE ' + @DatabaseName_FollowerDB + ' SET SINGLE_USER WITH ROLLBACK IMMEDIATE'
EXEC (@SQL)

--Restore LeaderDatabase as FollowerDB with puting files to the right location
SET @SQL = 'RESTORE DATABASE ' + @DatabaseName_FollowerDB + ' FROM  DISK = ''' + @FilePathBackup + ''' WITH  FILE = 1,
	MOVE '''+@LogicalFileNameRows_LeaderDB + ''' TO ''' +@FilePathRows_FollowerDB + ''', 
	MOVE '''+@LogicalFileNameLog_LeaderDB +''' TO ''' + @FilePathLog_FollowerDB + ''',
	NOUNLOAD,  REPLACE,  STATS = 5'
EXEC (@SQL)

--allow Connections 
SET @SQL = 'ALTER DATABASE ' + @DatabaseName_FollowerDB + ' SET MULTI_USER'
EXEC (@SQL)
```



