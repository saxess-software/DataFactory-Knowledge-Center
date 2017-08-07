
You can create a static table inside a script with the VALUES clause


````SQL
SELECT * FROM 
      (	VALUES 
         ('sxIsNumeric','','')
        ,('sxIsNumeric','','')
      ) A (ListID,NameShort,NameLong)
````
