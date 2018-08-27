Every string column in a Table can have a different collation
You can check it wit this command.

For DataFactory must be

Default Collation of Database = Default Collation of Table = Collation of each Column

otherwise thing can end in big trouble after backup / restore on different servers / azure.

````SQL
SELECT c.name, 
c.collation_name
FROM SYS.COLUMNS c
JOIN SYS.TABLES t ON t.object_id = c.object_id
WHERE t.name = 'sx_pf_dProductlines'
````