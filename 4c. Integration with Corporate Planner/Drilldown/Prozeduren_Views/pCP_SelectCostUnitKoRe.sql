-- Procedure to create Productlines as CostUnit in CP

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pCP_SelectCostUnitKoRe]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pCP_SelectCostUnitKoRe]
GO


CREATE PROCEDURE [dbo].[pCP_SelectCostUnitKoRe]
					@Clients NVARCHAR(max)
					
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @xml XML = @Clients;
					 
	CREATE TABLE #clients(ClientId VARCHAR(255));
					
	insert into #clients(ClientId)
	SELECT T.c.value('.', 'VARCHAR(255)') AS ClientId
	FROM @xml.nodes('declare namespace x="http://tempuri.org/KoReDataSet.xsd";/x:KoReDataSet/x:tblClient/x:Id') T(c);
					
	SELECT	FactoryID + '_' + ProductlineID AS Kostentraeger_ID, 
			NameShort AS KostentraegerName, 
			FactoryID AS Mandanten_Id

	FROM    sx_pf_dProductlines k

	INNER JOIN #clients c ON c.ClientId=k.FactoryID
	
END			