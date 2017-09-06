

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pCP_SelectValuesKoRe]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pCP_SelectValuesKoRe]
GO


CREATE PROCEDURE [dbo].[pCP_SelectValuesKoRe]
					@CompanyCode VARCHAR(255), 
					@ClientId VARCHAR(255),
					@PeriodFrom INT,
					@PeriodTo INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	FactoryID AS Mandanten_ID,
			FactoryID + '_' +  ProductLineID AS Kostenstellen_ID,
			NULL AS Kostentraeger_ID,
			ProductLineID + '_' +  ProductID AS Konten_ID,
			CONVERT(varchar(255),NULL) AS ICPartner_ID,
			CONVERT(varchar(255),NULL) AS Segment1_ID,
			CONVERT(varchar(255),NULL) AS Segment2_ID,
			Convert(int,(LEFT(TimeID,4)*100+1)*100+Right(Left(TimeID,6),2)) AS Perioden_Key,
			CONVERT(numeric(19,0),0.0) AS Soll,
			CONVERT(numeric(19,0),0.0) AS Haben,
			CONVERT(numeric(19,0),Sum(ValueInt)) AS Saldo_Periode

	FROM	sx_pf_fValues V
	WHERE   1=1 
			AND V.FactoryID = @ClientId
		--	AND (TimeID BETWEEN @PeriodFrom AND @PeriodTo)


	GROUP BY
			FactoryID,
			FactoryID + '_' +  ProductLineID ,
			ProductLineID + '_' +  ProductID ,
			Convert(int,(LEFT(TimeID,4)*100+1)*100+Right(Left(TimeID,6),2))



END
    		
    	