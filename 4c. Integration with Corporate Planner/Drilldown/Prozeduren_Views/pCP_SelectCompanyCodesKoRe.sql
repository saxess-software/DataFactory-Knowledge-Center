

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pCP_SelectCompanyCodesKoRe]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pCP_SelectCompanyCodesKoRe]
GO


CREATE PROCEDURE [dbo].[pCP_SelectCompanyCodesKoRe] 

AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT	'3' AS Buchungskreis, 
					FactoryID AS Mandanten_ID
	FROM			sx_pf_dFactories
END