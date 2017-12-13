
The UPDATE Command is used to update existing rows in the database

````SQL
-- Simple Update
UPDATE sx_pf_dProducts SET Globalattribute1 = 'T1000' WHERE Globalattribute1 = 'T2000'


-- with Output of changed Rows as Preview (update means inside database Rows are deleted an new inserted)
-- execution with the TRAN lead to Preview, execution without TRAN leads to real change
BEGIN TRAN
  UPDATE sx_pf_dProducts 
    SET Globalattribute1 = 'T1000'
    OUTPUT 
      DELETED.NameShort,DELETED.Globalattribute1,  -- or Deleted.* for all columns, optional AS ... for nicer header
      INSERTED.NameShort,INSERTED.Globalattribute1	-- or Inserted.* for all columns
    WHERE Globalattribute1 = 'T2000'
ROLLBACK TRAN
  
  
-- Update with Join - e.g. Update Values, where a Globalattribute is changed to somethings
UPDATE fV
  SET fV.ValueInt = 0 
  FROM sx_pf_fValues fV INNER JOIN sx_pf_dProducts dP
  ON 
    fV.ProductKey = dP.ProductKey AND
    dP.[Status] = 'inaktiv' AND
    fV.TimeID > 20170000
````
