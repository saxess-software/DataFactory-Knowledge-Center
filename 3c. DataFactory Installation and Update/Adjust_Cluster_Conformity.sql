/*
Script to Adjust Cluster Conformity
This may be necessary after:
	- API Updates, which establish more restrictive rules 
	- crashed values due to API bugs
	- crashed values due to manuall database actions out of scope of API 

Backup the cluster database before execution !!

Gerd Tautenhahn for saxess-software gmbh
04/2017 for DataFactory 4.0 

*/

PRINT 'Delete Elements with null Keys (Rowcount shows deleted rows)'

DELETE FROM dbo.sx_pf_dFactories WHERe FactoryKey = 0
DELETE FROM dbo.sx_pf_dProductLines WHERE FactoryKey = 0 OR ProductLineKey = 0
DELETE FROM dbo.sx_pf_dProducts WHERE FactoryKey = 0  OR ProductLineKey = 0 OR ProductKey = 0
DELETE FROM dbo.sx_pf_dValueSeries WHERE FactoryKey = 0  OR ProductLineKey = 0 OR ProductKey = 0 OR ValueSeriesKey = 0
DELETE FROM dbo.sx_pf_dTime WHERE FactoryKey = 0  OR ProductLineKey = 0 OR ProductKey = 0
DELETE FROM dbo.sx_pf_fValues WHERE FactoryKey = 0  OR ProductLineKey = 0 OR ProductKey = 0 OR ValueSeriesKey = 0
DELETE FROM dbo.sx_pf_fStatements WHERE FactoryKey = 0  OR ProductLineKey = 0 OR ProductKey = 0

PRINT CHAR(13)
PRINT 'Delete Elements with not existing Factory Keys (Rowcount shows deleted rows)' 
DELETE FROM dbo.sx_pf_dProductLines WHERE FactoryKey NOT IN (SELECT dF.FactoryKey FROM dbo.sx_pf_dFactories dF)
DELETE FROM dbo.sx_pf_dProducts WHERE FactoryKey NOT IN (SELECT dF.FactoryKey FROM dbo.sx_pf_dFactories dF)
DELETE FROM dbo.sx_pf_dValueSeries WHERE FactoryKey NOT IN (SELECT dF.FactoryKey FROM dbo.sx_pf_dFactories dF)
DELETE FROM dbo.sx_pf_dTime WHERE FactoryKey NOT IN (SELECT dF.FactoryKey FROM dbo.sx_pf_dFactories dF)
DELETE FROM dbo.sx_pf_fValues WHERE FactoryKey NOT IN (SELECT dF.FactoryKey FROM dbo.sx_pf_dFactories dF)
DELETE FROM dbo.sx_pf_fStatements WHERE FactoryKey NOT IN (SELECT dF.FactoryKey FROM dbo.sx_pf_dFactories dF)

PRINT CHAR(13)
PRINT 'Delete Elements with not existing ProductLine Keys (Rowcount shows deleted rows)' 
DELETE FROM dbo.sx_pf_dProducts WHERE ProductLineKey NOT IN (SELECT dPL.ProductlineKey FROM dbo.sx_pf_dProductLines dPL)
DELETE FROM dbo.sx_pf_dValueSeries WHERE ProductLineKey NOT IN (SELECT dPL.ProductlineKey FROM dbo.sx_pf_dProductLines dPL)
DELETE FROM dbo.sx_pf_dTime WHERE ProductLineKey NOT IN (SELECT dPL.ProductlineKey FROM dbo.sx_pf_dProductLines dPL)
DELETE FROM dbo.sx_pf_fValues WHERE ProductLineKey NOT IN (SELECT dPL.ProductlineKey FROM dbo.sx_pf_dProductLines dPL)
DELETE FROM dbo.sx_pf_fStatements WHERE ProductLineKey NOT IN (SELECT dPL.ProductlineKey FROM dbo.sx_pf_dProductLines dPL)

PRINT CHAR(13)
PRINT 'Delete Elements with not existing Products Keys (Rowcount shows deleted rows)' 
DELETE FROM dbo.sx_pf_dValueSeries WHERE ProductKey NOT IN (SELECT dP.ProductKey FROM dbo.sx_pf_dProducts dP)
DELETE FROM dbo.sx_pf_fValues WHERE ProductKey NOT IN (SELECT dP.ProductKey FROM dbo.sx_pf_dProducts dP)

PRINT CHAR(13)
PRINT 'Delete Elements with not existing ValueSeriesKeys (Rowcount shows deleted rows)' 
DELETE FROM dbo.sx_pf_fValues WHERE ValueSeriesKey NOT IN (SELECT dVS.ValueSeriesKey FROM dbo.sx_pf_dValueSeries dVS)


PRINT CHAR(13)
PRINT 'Adjust IDs to have not Dots (Rowcount not important - updates all)'

UPDATE sx_pf_dFactories 
    SET FactoryID = REPLACE(FactoryID,'.','')

UPDATE sx_pf_dProductLines  
    SET FactoryID = REPLACE(FactoryID,'.',''),
        ProductLineID = REPLACE(ProductLineID,'.',''),
        GlobalAttributeSource1 = REPLACE(GlobalAttributeSource1,'.',''), --due to ListIDs
        GlobalAttributeSource2 = REPLACE(GlobalAttributeSource2,'.',''), 
        GlobalAttributeSource3 = REPLACE(GlobalAttributeSource3,'.',''), 
        GlobalAttributeSource4 = REPLACE(GlobalAttributeSource4,'.',''), 
        GlobalAttributeSource5 = REPLACE(GlobalAttributeSource5,'.',''), 
        GlobalAttributeSource6 = REPLACE(GlobalAttributeSource6,'.',''), 
        GlobalAttributeSource7 = REPLACE(GlobalAttributeSource7,'.',''), 
        GlobalAttributeSource8 = REPLACE(GlobalAttributeSource8,'.',''), 
        GlobalAttributeSource9 = REPLACE(GlobalAttributeSource9,'.',''), 
        GlobalAttributeSource10 = REPLACE(GlobalAttributeSource10,'.',''), 
        GlobalAttributeSource11 = REPLACE(GlobalAttributeSource11,'.',''), 
        GlobalAttributeSource12 = REPLACE(GlobalAttributeSource12,'.',''), 
        GlobalAttributeSource13 = REPLACE(GlobalAttributeSource13,'.',''), 
        GlobalAttributeSource14 = REPLACE(GlobalAttributeSource14,'.',''), 
        GlobalAttributeSource15 = REPLACE(GlobalAttributeSource15,'.',''), 
        GlobalAttributeSource16 = REPLACE(GlobalAttributeSource16,'.',''), 
        GlobalAttributeSource17 = REPLACE(GlobalAttributeSource17,'.',''), 
        GlobalAttributeSource18 = REPLACE(GlobalAttributeSource18,'.',''), 
        GlobalAttributeSource19 = REPLACE(GlobalAttributeSource19,'.',''), 
        GlobalAttributeSource20 = REPLACE(GlobalAttributeSource20,'.',''), 
        GlobalAttributeSource21 = REPLACE(GlobalAttributeSource21,'.',''), 
        GlobalAttributeSource22 = REPLACE(GlobalAttributeSource22,'.',''), 
        GlobalAttributeSource23 = REPLACE(GlobalAttributeSource23,'.',''), 
        GlobalAttributeSource24 = REPLACE(GlobalAttributeSource24,'.',''), 
        GlobalAttributeSource25 = REPLACE(GlobalAttributeSource25,'.','')

UPDATE sx_pf_dProducts
    SET FactoryID = REPLACE(FactoryID,'.',''),
        ProductLineID = REPLACE(ProductLineID,'.',''),
        ProductID = REPLACE(ProductID,'.','')

UPDATE sx_pf_dValueSeries
    SET FactoryID = REPLACE(FactoryID,'.',''),
        ProductLineID = REPLACE(ProductLineID,'.',''),
        ProductID = REPLACE(ProductID,'.',''),
        ValueSeriesID = REPLACE(ValueSeriesID,'.',''),
        Effect = REPLACE(Effect,'.',''), --due to EffectID in gValueEffects
        ValueListID = REPLACE(ValueListID,'.',''),
        ValueFormatID = REPLACE(ValueFormatID,'.','')

UPDATE sx_pf_fValues    
    SET FactoryID = REPLACE(FactoryID,'.',''),
        ProductLineID = REPLACE(ProductLineID,'.',''),
        ProductID = REPLACE(ProductID,'.',''),
        ValueSeriesID = REPLACE(ValueSeriesID,'.','')

UPDATE sx_pf_fStatements
    SET FactoryID = REPLACE(FactoryID,'.',''),
        ProductLineID = REPLACE(ProductLineID,'.',''),
        ProductID = REPLACE(ProductID,'.','')

UPDATE sx_pf_gCluster   
    SET PropertyID = REPLACE(PropertyID,'.',''),
        FormatID = REPLACE(FormatID,'.','')

UPDATE sx_pf_gFactories 
    SET PropertyID = REPLACE(PropertyID,'.',''),
        FactoryID = REPLACE(FactoryID,'.',''),
        FormatID = REPLACE(FormatID,'.','')

UPDATE sx_pf_gProductLines  
    SET PropertyID = REPLACE(PropertyID,'.',''),
        FactoryID = REPLACE(FactoryID,'.',''),
        ProductLineID = REPLACE(ProductLineID,'.',''),
        FormatID = REPLACE(FormatID,'.','')

UPDATE sx_pf_gProducts
    SET PropertyID = REPLACE(PropertyID,'.',''),
        FactoryID = REPLACE(FactoryID,'.',''),
        ProductLineID = REPLACE(ProductLineID,'.',''),
        ProductID = REPLACE(ProductID,'.',''),
        FormatID = REPLACE(FormatID,'.','')

UPDATE sx_pf_gValueEffects
    SET EffectID = REPLACE(EffectID,'.','')

UPDATE sx_pf_hFormats 
    SET FormatID = REPLACE(FormatID,'.','')

UPDATE sx_pf_hLists 
    SET ListID = REPLACE(ListID,'.',''),
        FormatID = REPLACE(FormatID,'.','')

UPDATE sx_pf_hListValues
    SET ListID = REPLACE(ListID,'.',''),
        FormatID = REPLACE(FormatID,'.','')

UPDATE sx_pf_rPreferences
    SET FactoryID = REPLACE(FactoryID,'.',''),
        ProductLineID = REPLACE(ProductLineID,'.','')

UPDATE sx_pf_rRights 
    SET FactoryID = REPLACE(FactoryID,'.',''),
        ProductLineID = REPLACE(ProductLineID,'.',''),
        ProductID = REPLACE(ProductID,'.','')

PRINT CHAR(13)
PRINT 'Adjust IDs to have no spaces, not allowed since from API 4.0.59 on (Rowcount not important - updates all)'

UPDATE sx_pf_dFactories 
    SET FactoryID = REPLACE(FactoryID,' ','')

UPDATE sx_pf_dProductLines  
    SET FactoryID = REPLACE(FactoryID,' ',''),
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
    SET FactoryID = REPLACE(FactoryID,' ',''),
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
    SET PropertyID = REPLACE(PropertyID,' ',''),
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


PRINT CHAR(13)
PRINT 'Elimimate useless values (Rowcount shows deleted rows)'

-- eleminate empty Zeros from Numeric ValueSeries
DELETE fV FROM sx_pf_fValues fV LEFT JOIN sx_pf_dValueSeries dVS
	ON fV.ValueSeriesKey = dVS.ValueSeriesKey WHERE
	[ISNUMERIC] = 1 AND
	ValueFormula = '' AND
	ValueInt = 0

-- eleminate empty text values from Text ValueSeries
DELETE fV FROM sx_pf_fValues fV LEFT JOIN sx_pf_dValueSeries dVS
	ON fV.ValueSeriesKey = dVS.ValueSeriesKey WHERE
	[ISNUMERIC] = 0 AND
	ValueComment = '' AND
	ValueFormula = '' AND
	ValueText = ''

-- eleminate minus Values from Text ValueSeries (where former used as placeholders)
DELETE fV FROM sx_pf_fValues fV LEFT JOIN sx_pf_dValueSeries dVS
	ON fV.ValueSeriesKey = dVS.ValueSeriesKey WHERE
	--dVS.ValueSeriesNo = 1 AND
	[ISNUMERIC] = 0 AND
	ValueComment = '' AND
	ValueFormula = '' AND
	ValueText = '-'

PRINT CHAR(13)
PRINT 'Elimimate gaps in ValueSeries Numbers (Rowcount shows changed ValueSeries)'

-- Adjust Numbering of ValueSeries to have no gaps, starting with number one
UPDATE dVS SET dVS.ValueSeriesNo = dVS.NewNo FROM  
(
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY productKey ORDER BY ValueSeriesNo) AS NewNo
		,[ValueSeriesNo]

	FROM dbo.sx_pf_dValueSeries
) dVS WHERE dVS.ValueSeriesNo <> dVS.NewNo