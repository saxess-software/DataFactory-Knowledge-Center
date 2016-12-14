-- Script to eliminate Spaces from IDs
-- from Version 4.0.2452 on, Spaces in IDs are no longer supported
-- create a database Backup before executing ! 

````SQL
UPDATE sx_pf_dFactories	
	SET FactoryID = REPLACE(FactoryID,' ','')

UPDATE sx_pf_dProductLines	
	SET	FactoryID = REPLACE(FactoryID,' ',''),
		ProductLineID = REPLACE(ProductLineID,' ',''),
		GlobalAttributeSource1 = REPLACE(GlobalAttributeSource1,' ',''), --due to ListIDs
		GlobalAttributeSource2 = REPLACE(GlobalAttributeSource2,' ',''), 
		GlobalAttributeSource3 = REPLACE(GlobalAttributeSource3,' ',''), 
		GlobalAttributeSource4 = REPLACE(GlobalAttributeSource4,' ',''), 
		GlobalAttributeSource5 = REPLACE(GlobalAttributeSource5,' ',''), 
		GlobalAttributeSource6 = REPLACE(GlobalAttributeSource6,' ',''), 
		GlobalAttributeSource7 = REPLACE(GlobalAttributeSource7,' ',''), 
		GlobalAttributeSource8 = REPLACE(GlobalAttributeSource8,' ',''), 
		GlobalAttributeSource9 = REPLACE(GlobalAttributeSource9,' ',''), 
		GlobalAttributeSource10 = REPLACE(GlobalAttributeSource10,' ',''), 
		GlobalAttributeSource11 = REPLACE(GlobalAttributeSource11,' ',''), 
		GlobalAttributeSource12 = REPLACE(GlobalAttributeSource12,' ',''), 
		GlobalAttributeSource13 = REPLACE(GlobalAttributeSource13,' ',''), 
		GlobalAttributeSource14 = REPLACE(GlobalAttributeSource14,' ',''), 
		GlobalAttributeSource15 = REPLACE(GlobalAttributeSource15,' ',''), 
		GlobalAttributeSource16 = REPLACE(GlobalAttributeSource16,' ',''), 
		GlobalAttributeSource17 = REPLACE(GlobalAttributeSource17,' ',''), 
		GlobalAttributeSource18 = REPLACE(GlobalAttributeSource18,' ',''), 
		GlobalAttributeSource19 = REPLACE(GlobalAttributeSource19,' ',''), 
		GlobalAttributeSource20 = REPLACE(GlobalAttributeSource20,' ',''), 
		GlobalAttributeSource21 = REPLACE(GlobalAttributeSource21,' ',''), 
		GlobalAttributeSource22 = REPLACE(GlobalAttributeSource22,' ',''), 
		GlobalAttributeSource23 = REPLACE(GlobalAttributeSource23,' ',''), 
		GlobalAttributeSource24 = REPLACE(GlobalAttributeSource24,' ',''), 
		GlobalAttributeSource25 = REPLACE(GlobalAttributeSource25,' ','')

UPDATE sx_pf_dProducts
	SET FactoryID = REPLACE(FactoryID,' ',''),
		ProductLineID = REPLACE(ProductLineID,' ',''),
		ProductID = REPLACE(ProductID,' ','')

UPDATE sx_pf_dValueSeries
	SET FactoryID = REPLACE(FactoryID,' ',''),
		ProductLineID = REPLACE(ProductLineID,' ',''),
		ProductID = REPLACE(ProductID,' ',''),
		ValueSeriesID = REPLACE(ValueSeriesID,' ',''),
		Effect = REPLACE(Effect,' ',''), --due to EffectID in gValueEffects
		ValueListID = REPLACE(ValueListID,' ',''),
		ValueFormatID = REPLACE(ValueFormatID,' ','')

UPDATE sx_pf_fValues	
	SET FactoryID = REPLACE(FactoryID,' ',''),
		ProductLineID = REPLACE(ProductLineID,' ',''),
		ProductID = REPLACE(ProductID,' ',''),
		ValueSeriesID = REPLACE(ValueSeriesID,' ','')

UPDATE sx_pf_fStatements
	SET	FactoryID = REPLACE(FactoryID,' ',''),
		ProductLineID = REPLACE(ProductLineID,' ',''),
		ProductID = REPLACE(ProductID,' ','')

UPDATE sx_pf_gCluster	
	SET PropertyID = REPLACE(PropertyID,' ',''),
		FormatID = REPLACE(FormatID,' ','')

UPDATE sx_pf_gFactories	
	SET PropertyID = REPLACE(PropertyID,' ',''),
		FactoryID = REPLACE(FactoryID,' ',''),
		FormatID = REPLACE(FormatID,' ','')

UPDATE sx_pf_gProductLines	
	SET	PropertyID = REPLACE(PropertyID,' ',''),
		FactoryID = REPLACE(FactoryID,' ',''),
		ProductLineID = REPLACE(ProductLineID,' ',''),
		FormatID = REPLACE(FormatID,' ','')

UPDATE sx_pf_gProducts
	SET PropertyID = REPLACE(PropertyID,' ',''),
		FactoryID = REPLACE(FactoryID,' ',''),
		ProductLineID = REPLACE(ProductLineID,' ',''),
		ProductID = REPLACE(ProductID,' ',''),
		FormatID = REPLACE(FormatID,' ','')

UPDATE sx_pf_gValueEffects
	SET EffectID = REPLACE(EffectID,' ','')

UPDATE sx_pf_hFormats 
	SET FormatID = REPLACE(FormatID,' ','')

UPDATE sx_pf_hLists 
	SET ListID = REPLACE(ListID,' ',''),
		FormatID = REPLACE(FormatID,' ','')

UPDATE sx_pf_hListValues
	SET ListID = REPLACE(ListID,' ',''),
		FormatID = REPLACE(FormatID,' ','')

UPDATE sx_pf_rPreferences
	SET FactoryID = REPLACE(FactoryID,' ',''),
		ProductLineID = REPLACE(ProductLineID,' ','')

UPDATE sx_pf_rRights 
	SET FactoryID = REPLACE(FactoryID,' ',''),
		ProductLineID = REPLACE(ProductLineID,' ',''),
		ProductID = REPLACE(ProductID,' ','')
		
UPDATE sx_pf_hListValues
    SET ValueText = REPLACE(ValueText,' ','')
	WHERE ListID = 'sxValueFormats'		

````
 



