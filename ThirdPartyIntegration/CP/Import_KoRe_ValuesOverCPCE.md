This procedure extends the standard CPCE Procedure to import KoRe Values.  
If a Buchungskreis DF* ist requested, the Query will be redirected to a DataFactory Database.


````SQL
USE connectivityexpress

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pCP_SelectValuesKoRe]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pCP_SelectValuesKoRe]
GO

-- =============================================
-- Author:		  CP Corporate Planning AG, Saxess Software GmbH
-- Create date:   2014-05-05
-- Description:	  Abfrage Kore Salden.
-- In Parameter:  CompanyCode: Der Buchungskreis, für den die Werte abgefragt werden.
--				  ClientId: Der Mandant, für den die Werte abgefragt werden.	
--				  PeriodForm: Anfangsperiode
--			      PeriodTo: Endperiode
-- Out Parameter: Mandanten_ID
--                Kostenstellen_ID
--                Kostentraeger_ID
--	              Konten_ID
--	              ICPartner_ID
--	              Segment1_ID
--	              Segment2_ID
--                Perioden_Key
--				  Soll
--				  Haben
--				  Saldo_Periode
-- DataFactory Erweiterung:
-- DataFactory wird behandelt wie ein Buchungskreis, diese Abfrage holt eine Factory aus DF
-- wird ein Buchungskreis DF* angefragt, wird die Abfrage auf der DataFactory Datenbank ausgeführt.
-- damit diese Abfragewerte auf die vorhandene Struktur passen, muss die FactoryID in DF der MandantenID in CPCE entsprechen.
-- hierfür die MandantenID in der Tabelle sx_pf_dMandanten in der CPCE Datenbank anschauen
-- CP ruft diese Prozedur pro Mandant auf 
-- =============================================
CREATE PROCEDURE [dbo].[pCP_SelectValuesKoRe]
	@CompanyCode VARCHAR(255), 
	@ClientId VARCHAR(255),
	@PeriodFrom INT,
	@PeriodTo INT
AS
BEGIN
	SET NOCOUNT ON;

	
	IF @CompanyCode NOT LIKE 'DF%'   
		-- This Query Part delivers data from SX Integrator
		BEGIN
			SELECT	Mandanten_ID,
					Kostenstellen_ID,
					Kostentraeger_ID,
					Konten_ID,
					-- falls IC-Partnercode und Segmentinformationen benötigt, Quelltabelle auf sx_dwh_fKoReBuchungsjournal anpassen
					v.Kundenattribut0 AS ICPartner_ID,
					v.Kundenattribut1 AS Segment1_ID,
					v.Kundenattribut2 AS Segment2_ID,
					Perioden_Key,
					Soll,
					Haben,
					Saldo_Periode
					-- Saldo_Buchung AS Saldo_Periode
			FROM	dbo.sx_dwh_fKoRe_P v
			--FROM dbo.sx_dwh_fKoReBuchungsjournal
			WHERE   (Buchungskreis = @CompanyCode) AND 
					(Mandanten_ID = @ClientId) AND
					(Perioden_Key BETWEEN @PeriodFrom AND @PeriodTo)
		END 

	IF @CompanyCode LIKE 'DF%' 
		-- This Query Part delivers data from SX DataFactory
		BEGIN
			SELECT	 fV.FactoryID AS Mandanten_ID
					,fV.FactoryID +'_' + fV.ProductLineID AS Kostenstellen_ID
					,fV.ProductID AS Kostentraeger_ID --not a usual case, as values are aggregated
					,fV.ValueSeriesID AS Konten_ID
					,'-' AS ICPartner_ID
					,'-' AS Segment1_ID
					,'-' AS Segment2_ID
					,fV.TimeID/1000 +100 + Left(Right(fV.TimeID,4),2) AS Perioden_Key -- ist a bit strange, as SXIntegrator has a Period Key with coding of financial year
					,0 AS Soll
					,0 AS Haben
					,Sum(CAST(fV.ValueInt AS Money) / dVS.Scale) AS Saldo_Periode
					
			FROM	datafactory.dbo.sx_pf_fValues fV           --CONFIG: Set a hard target database here !!
					LEFT JOIN sx_pf_dValueSeries dVS ON
						fV.ValueSeriesKey = dVS.ValueSeriesKey

			WHERE   --(Buchungskreis = @CompanyCode) AND 
					(FactoryID = @ClientId) AND
					(TimeID/1000 +100 + Left(Right(TimeID,4),2) BETWEEN @PeriodFrom AND @PeriodTo)
		END 
END
    		
    	
GO

````
