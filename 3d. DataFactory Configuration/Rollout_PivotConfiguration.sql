/*
Script to rollout Webclient Pivot Configurations from one Factory to all other Factories
Preconditions:
	- the Property which is rolled out must already exist in all Factories

*/


-- Pivot Configuration der Masterpivot lesen
DECLARE @MasterFactoryID NVARCHAR(255) = 'AD'
DECLARE @PivotTableID NVARCHAR(255) = 'Pivot_1'
DECLARE @PivotConfiguration NVARCHAR(MAX) = ''


SELECT 
	@PivotConfiguration = ValueText 
FROM sx_pf_gFactories 
WHERE 
	FactoryID = @MasterFactoryID AND
	PropertyID = @PivotTableID


-- Configuration in allen anderen Factories schreiben
UPDATE sx_pf_gFactories 
SET ValueText = @PivotConfiguration, ValueInt = 0
WHERE 
	FactoryID != @MasterFactoryID AND
	FactoryID != 'ZT' AND
	PropertyID = @PivotTableID