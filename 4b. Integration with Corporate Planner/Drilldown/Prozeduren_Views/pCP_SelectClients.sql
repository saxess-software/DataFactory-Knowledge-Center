-- Procedure for creation of Factories as first hierarchie level in CP

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pCP_SelectClients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pCP_SelectClients]
GO

CREATE PROCEDURE dbo.pCP_SelectClients
AS
BEGIN
	SET NOCOUNT ON;

	SELECT   
				FactoryID AS Mandanten_ID
				,NameShort AS MandantenName
				,1 AS MandantenGeschaeftsjahresbeginn
	FROM     sx_pf_dFactories
	ORDER BY MandantenName
END
			