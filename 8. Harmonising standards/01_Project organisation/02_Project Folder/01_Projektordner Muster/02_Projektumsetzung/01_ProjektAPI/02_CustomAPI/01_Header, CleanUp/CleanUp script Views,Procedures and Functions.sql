
/*
Author: 	Mandy Hauck
Created: 	2018/10
Summary:	This script deletes all views, procedures and functions but does NOT delete any tables
			Use this script to change your API
			Einzelne Batches, da am Ende immer noch ein Befehlsfragment hängt

*/


-------------------------------------------------------------------------------------------------------------------
-- ##### PROCEDURES ###########

DECLARE  @sql VARCHAR(MAX) = ''
        ,@crlf VARCHAR(2) = CHAR(13) + CHAR(10) ;

SELECT @sql = @sql + 'DROP PROCEDURE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(v.name) +';' + @crlf
FROM   sys.procedures v

PRINT @sql;
EXEC(@sql);

GO

-------------------------------------------------------------------------------------------------------------------
-- ##### FUNCTIONS ###########

DECLARE  @sql VARCHAR(MAX) = ''
        ,@crlf VARCHAR(2) = CHAR(13) + CHAR(10) ;
SELECT @sql = @sql + 'DROP FUNCTION ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(v.name) +';' + @crlf
FROM   sys.objects v WHERE type_desc LIKE '%FUNCTION%' 

PRINT @sql;
EXEC(@sql)

GO

-------------------------------------------------------------------------------------------------------------------
-- ##### VIEWS ###########

DECLARE  @sql VARCHAR(MAX) = ''
        ,@crlf VARCHAR(2) = CHAR(13) + CHAR(10) ;

SELECT @sql = @sql + 'DROP VIEW ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(v.name) +';' + @crlf
FROM   sys.views v

PRINT @sql;
EXEC(@sql);

GO

