
/*

Stefan Lindenlaub
2018/04

Skript zum Anonymisieren von Factories, Productlines und Products


*/

---------------------------------------------------
-- ### VARIABLES ###

DECLARE @FactoriesTo AS NVARCHAR(255) = 'Abteilung'			-- Enter here what Factories should be, e.g. Abteilungen, Profitcenter etc
DECLARE @ProductlinesTo AS NVARCHAR(255) = 'Kostenstelle'	-- Enter here what Productlines should be, e.g. Kostenstellen
DECLARE @ProductsTo AS NVARCHAR(255) = 'Mitarbeiter'		-- Enter here what Products should be, e.g. Mitarbeiter

---------------------------------------------------
-- Factories
UPDATE dbo.sx_pf_dFactories
SET NameShort = @FactoriesTo + ' ' + FactoryID
WHERE FactoryID NOT IN ('ZT','ZS')

-- Productlines
UPDATE dbo.sx_pf_dProductLines
SET NameShort = @ProductlinesTo + ' ' + ProductLineID
WHERE FactoryID NOT IN ('ZT','ZS')

-- Products
UPDATE dbo.sx_pf_dProducts
SET NameShort = @ProductsTo + ' '  + ProductID
WHERE FactoryID NOT IN ('ZT','ZS')

-- Maybe you have to go on anonymize Globalattributs, Lists etc. as well!
