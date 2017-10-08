

````SQL
/*
VIEW zur Anzeige der Kostenstellenhierarchie

Testcall

SELECT * FROM [calc].[vKostenstellenhierarchie_all]

*/

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[calc].[vKostenstellenhierarchie_all]'))
DROP VIEW [calc].[vKostenstellenhierarchie_all]
GO


CREATE VIEW [calc].[vKostenstellenhierarchie_all]

AS

SELECT 
	  MandantenID
	 ,FactoryID + ' ' + FactoryNameShort AS FactoryIDName
	 ,KostenstellenID + ' ' + KostenstellenName AS KostenstellenIDName 

FROM staging.tKostenstellenhierarchie_all
	

GO

GRANT SELECT ON OBJECT::[calc].[vKostenstellenhierarchie_all] TO pf_PlanningFactoryUser;  
GO  

````