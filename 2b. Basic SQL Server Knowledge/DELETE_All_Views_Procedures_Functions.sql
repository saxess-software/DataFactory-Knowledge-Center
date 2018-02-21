/*
Cleanup Script für API Wechsel

- ändert KEINE Tabellen 

- löscht alle Views
- löscht alle Prozeduren
- löscht alle Funktionen


Einzelne Batches, da am Ende immer noch ein Befehlsfragment hängt

*/



-- alle Prozeduren löschen
DECLARE  @sql VARCHAR(MAX) = ''
        ,@crlf VARCHAR(2) = CHAR(13) + CHAR(10) ;

SELECT @sql = @sql + 'DROP PROCEDURE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(v.name) +';' + @crlf
FROM   sys.procedures v

PRINT @sql;
EXEC(@sql);

GO


-- alle Funktionen löschen
DECLARE  @sql VARCHAR(MAX) = ''
        ,@crlf VARCHAR(2) = CHAR(13) + CHAR(10) ;
SELECT @sql = @sql + 'DROP FUNCTION ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(v.name) +';' + @crlf
FROM   sys.objects v WHERE type_desc LIKE '%FUNCTION%' 

PRINT @sql;
EXEC(@sql)

GO


-- alle Views löschen
DECLARE  @sql VARCHAR(MAX) = ''
        ,@crlf VARCHAR(2) = CHAR(13) + CHAR(10) ;

SELECT @sql = @sql + 'DROP VIEW ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(v.name) +';' + @crlf
FROM   sys.views v

PRINT @sql;
EXEC(@sql);

GO

