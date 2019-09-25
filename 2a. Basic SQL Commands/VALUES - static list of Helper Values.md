
You can create a static table inside a script with the VALUES clause


````SQL
-- static table
SELECT * FROM 
      (	VALUES 
         ('sxIsNumeric','','')
        ,('sxIsNumeric','','')
      ) A (ListID,NameShort,NameLong)
      
-- static list of month
SELECT 
*
FROM (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)) Monate (Monat)
````
