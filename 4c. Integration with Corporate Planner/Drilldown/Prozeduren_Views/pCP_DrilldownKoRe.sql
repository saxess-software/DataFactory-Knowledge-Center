	
		-- =============================================
	-- Author:		  CP Corporate Planning AG, Saxess Software GmbH
	-- Create date:   2016-05-31
	-- Description:	  Drilldown in die Kostenrechnung
	--                Für den Drilldown auf Perioden (IsPeriodFilter=1) wird in den Parametern PeriodFrom und PerodTo das Datum in der Form yyyy-pp 
	--                übergeben, wobei yyyy das Geschäftsjahr und pp der Periode entspricht.
	--                Beim Drilldown auf Tagesbasis (IsPeriodFilter=0) wird in den Parametern PeriodFrom und PeriodTo das Datum in der Form yyyymmdd 
	--                übergeben, wobei yyyy das Kalenderjahr, mm deMonat und dd dem Tag entspricht.
	-- In Parameter:  Client: Der Mandant, für den die Werte abgefragt werden.
	--				  CompanyCode: Der Buchungskreis, für den die Werte abgefragt werden.
	--				  CostType: Die Kostenart, für das die Werte abgefragt werden sollen.	
	--                KoReTypeId: Die Kostenstelle oder der Kostenträger, für den die Werte abgefragt werden sollen (Ist abhängig von KoReType).
	--				  PeriodForm: Anfangsperiode / Anfangsdatum
	--			      PeriodTo: Endperiode / Enddatum
	--                KoReType: 0 = Kostenstelle
	--						    1 = Kostensräger
	--				  IsPeriodFilter: Legt fest, ob auf Perioden oder Buchungsdatum gefiltert werden soll.
	-- Out Parameter: 
	-- Resultset 1:   Kann frei definiert werden.
	-- Resultset 2:	  KumuliertesSoll: Die Summe der Sollwerte der Abfrage
	--                KumuliertesHaben: Die Summe der Habenwerte der Abfrage
	--                KumuliertesSaldo: Die Summe der Salden der Abfrage
	-- =============================================
	

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pCP_DrilldownKoRe]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[pCP_DrilldownKoRe]
	GO

	CREATE PROCEDURE [dbo].[pCP_DrilldownKoRe] 
				@Client varchar(255),
				@CompanyCode varchar(255),
				@CostType varchar(255),
				@KoreTypeId varchar(255),
				@PeriodFrom varchar(10),
				@PeriodTo varchar(10),
				@KoReType tinyint,
				@IsPeriodFilter tinyint

				AS
				BEGIN
					SET NOCOUNT ON;

					-- Query for List
					SELECT 
					--@Client
					--,@CompanyCode
					--,@CostType
					--,@KoreTypeId
					--,@PeriodFrom
					--,@PeriodTo
					--,@KoReType
					--,@IsPeriodFilter

					 fV.ProductID
					,fV.ProductLineID
					,fV.FactoryID
					,fV.ValueSeriesID
					,dVS.NameShort AS ValueSeriesName
					,Right(LEFT(TimeID,6),2) AS Monat
					,LEFT(TimeID,4) AS Jahr
					

					,CAST(ValueInt AS money) / 100 AS Wert
					
					FROM sx_pf_fValues fV LEFT JOIN sx_pf_dValueSeries dVS ON
						fV.ValueSeriesKey = dVS.ValueSeriesKey 
					
					WHERE fV.FactoryID = @Client AND
						  fV.FactoryID + '_' + fV.ProductLineID = @KoreTypeID AND
						  Replicate('0',8-Len(fV.ProductlineID) - Len(fV.ProductID) - 1) + fV.ProductlineID + '_' + fV.ProductID = @CostType AND
						  TimeID /100 >= CAST (REPLACE(@PeriodFrom,'-','') AS INT) AND
						  TimeID /100 <= CAST (REPLACE(@PeriodTo,'-','') AS INT)

					-- Query for Summary Linie
					SELECT 	0 AS [KumuliertesSoll], 
							0 AS [KumuliertesHaben],
							CAST(SUM(ValueInt) AS money)/100 AS [KumuliertesSaldo]
					FROM  sx_pf_fValues 
					
					WHERE FactoryID = @Client AND
						  FactoryID + '_' + ProductLineID = @KoreTypeID AND
						  Replicate('0',8-Len(ProductlineID) - Len(ProductID) - 1) + ProductlineID + '_' + ProductID = @CostType AND
						  TimeID /100 >= CAST (REPLACE(@PeriodFrom,'-','') AS INT) AND
						  TimeID /100 <= CAST (REPLACE(@PeriodTo,'-','') AS INT)

			END