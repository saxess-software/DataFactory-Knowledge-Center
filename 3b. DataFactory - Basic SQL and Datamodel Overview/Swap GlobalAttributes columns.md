## Swap GlobalAttributes columns

- Use this script if you want to replace a GlobalAttribute column in the ProductLineTabel with another GlobalAttribute column
- column headers, lists and values will be exchanged

````SQL

  BEGIN TRANSACTION
  
  -- Set column header and list source
    UPDATE sx_pf_dProductLines
      SET [GlobalAttributeSource2] = [GlobalAttributeSource7], [GlobalAttributeSource7] = [GlobalAttributeSource2], [GlobalAttributeAlias2] = [GlobalAttributeAlias7], [GlobalAttributeAlias7] = [GlobalAttributeAlias2]
      OUTPUT DELETED. *, INSERTED.*  -- Output, what will be changed
      WHERE FactoryID = '1' AND ProductLineID = '1';

  -- Set values
     UPDATE sx_pf_dProducts
      SET [GlobalAttribute2] = [GlobalAttribute7], [GlobalAttribute7] = [GlobalAttribute2]	
      OUTPUT DELETED. *, INSERTED.*   -- Output, what will be changed
      WHERE FactoryID = '1' AND ProductLineID = '1';

   ROLLBACK TRANSACTION
