/* Gerd Tautenhahn for saxess-software
   03/2016
   the instance of the database is determined, where you connect this script to

   Call this script from a bat file with this command

	@echo %time%
	sqlcmd -E -S localhost\Express01 -i D:\SQL2014_Express01\Backup_all_Databases_of_instance_into_separate_Folders.sql -o D:\SQL2014_Express01\log.log
	@echo %time%

*/


DECLARE @name NVARCHAR(255) -- database name  
DECLARE @path NVARCHAR(255) -- path for backup files 
DECLARE @path_per_db NVARCHAR(255) -- path for backup file per database 
DECLARE @fileName NVARCHAR(255) -- filename for backup  
DECLARE @fileDate NVARCHAR(255) -- used for file name
DECLARE @DirectoryTree TABLE (subdirectory nvarchar(255), depth INT) -- To Check Existenz of Backup folder


SET @path = 'D:\SQL2014_Express01\Backup\'   -- CONFIG: specify database backup directory
SET @path_per_db = ''

-- Read existing Directory
INSERT INTO @DirectoryTree(subdirectory, depth)
EXEC master.sys.xp_dirtree @path

-- specify filename format
SELECT @fileDate = CONVERT(NVARCHAR(255),GETDATE(),112) + '_'+ Right(10000 + Datepart(hour,GETDATE()) *100 + Datepart(MINUTE,Getdate()),4)

 
DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb')  -- CONFIG OPTIONAL: exclude these databases and maybe add some more

 
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   

 
WHILE @@FETCH_STATUS = 0   
BEGIN   
	
	   SET @path_per_db = @path + @name
	   IF NOT EXISTS (SELECT 1 FROM @DirectoryTree WHERE subdirectory = @name)
		EXEC master.dbo.xp_create_subdir @path_per_db
       SET @fileName = @path_per_db +'\' + @name + '_' + @fileDate + '.BAK'  
       BACKUP DATABASE @name TO DISK = @fileName  

 
       FETCH NEXT FROM db_cursor INTO @name   
END   
 
CLOSE db_cursor   
DEALLOCATE db_cursor



