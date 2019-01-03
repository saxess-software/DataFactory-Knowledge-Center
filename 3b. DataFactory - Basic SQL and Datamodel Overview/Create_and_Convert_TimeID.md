
## Get Year / Month / Day from TimeID

Year from TimeID
````SQL
SELECT TimeID / 10000
````
YearMonth from TimeID
````SQL
SELECT TimeID / 100
````
Month from TimeID
````SQL
SELECT TimeID / 100 % 100
````
Day from TimeID
````SQL
SELECT TimeID % 100
````
Date as String from TimeID (still looking for a nicer way...)
````SQL
Right(TimeID,2) +'.' + CAST(TimeID / 100 % 100 AS NVARCHAR) + '.' + CAST(TimeID/10000 AS NVARCHAR)
````

## Convert to and from Datetime

TimeID from DateTime (replace GetDate with your Datetime Column)
````SQL
SELECT CONVERT(nvarchar(10), GetDate(),112)
````
Datetime from TimeID (you must cast TimeID as NVARCHAR)
````SQL
SELECT CONVERT(Datetime,CAST(TimeID AS NVARCHAR(10)))
````
Datetime from Date in ValueText
````SQL
CAST(f.ValueText AS datetime)
````
TimeID from Date in ValueText
````SQL
CONVERT(nvarchar(10),CAST(f.ValueText AS datetime),112)
````

## Special operations

Increment TimeID by 7 Days
````SQL
SELECT CONVERT(nvarchar(10),DATEADD(d,7,CONVERT(Datetime,CAST(TimeID AS NVARCHAR(10)))),112)
````

TimeID from XLS Datenumber
````SQL
SELECT CAST(47848 - 2 as Datetime)
````

SQL string to XLS Datenumber
````SQL
-- Date as NVARCHAR(255) 
SELECT DATEDIFF(DD,'1899-12-30',[Date])
````

Check if TimeID is weekday
````SQL
IIF(Datepart(weekday,CONVERT(Datetime,CAST(TimeID AS NVARCHAR(10))))<=5,1,0)  AS Day_is_Weekday
````


## List of Month based on Products of a given template
````SQL
-- MAX / MIN Jahre aller Investitionen ermitteln
DECLARE @Jahr_Min	INT
DECLARE @Jahr_Max	INT
DECLARE @Jahr		INT

SELECT
	 @Jahr_Min = MIN(ValueInt) -- SET Scale if Scale is not 1 !!
	,@Jahr_Max = MAX(ValueInt)

FROM dbo.sx_pf_fValues fV 
		LEFT JOIN dbo.sx_pf_dProducts dP
			ON fV.ProductKey = dP.ProductKey
WHERE 
		fV.ValueSeriesID	= 'J_ZAHL'
	AND dP.Template			= 'Investliste_VM'
	
-- Kalenderhilfstabellen
IF OBJECT_ID('tempdb..#Jahre') IS NOT NULL DROP TABLE #Jahre
CREATE TABLE #Jahre (Jahr INT NOT NULL) 
SET @Jahr = @Jahr_Min

WHILE @Jahr <= @Jahr_Max
BEGIN
	INSERT INTO #Jahre VALUES (@Jahr)
	SET @Jahr = @Jahr + 1;
END;

IF OBJECT_ID('tempdb..#Monate') IS NOT NULL DROP TABLE #Monate
CREATE TABLE #Monate (Monat INT NOT NULL) 
	INSERT INTO #Monate VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)

IF OBJECT_ID('tempdb..#Time') IS NOT NULL DROP TABLE #Time
CREATE TABLE #Time (Jahr INT NOT NULL, Monat INT NOT NULL, Periode INT NOT NULL)
INSERT INTO #Time 
	SELECT j.Jahr, m.Monat, j.Jahr * 100 + m.Monat AS Periode FROM #Jahre j LEFT JOIN #Monate m ON 1=1
````

## List of Days as static table

Creates a static table with all real calendar days between from and to TimeID

````SQL
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sx_pf_dTimeDays]') AND type in (N'U'))
DROP TABLE [dbo].[sx_pf_dTimeDays]
GO

CREATE TABLE sx_pf_dTimeDays
(
     	 Date_Datetime DATETIME
	,TimeID BIGINT
)

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
SET @StartDate = '20170101'
SET @EndDate = '20181231'

WHILE @StartDate <= @EndDate
      BEGIN
             INSERT INTO sx_pf_dTimeDays
             (
                Date_Datetime,
		TimeID
             )
             SELECT
		 @StartDate
		,Year(@StartDate)* 10000 + MONTH(@StartDate)*100 + Day(@StartDate)

             SET @StartDate = DATEADD(dd, 1, @StartDate)
      END
      
-- SELECT * FROM sx_pf_dTimeDays
````


## List of Days a temp table
Creates a temporary table with all real calendaric TimeIDs between two days.
````SQL
-- Hilfstabelle Tageskalender *****************************************************************
-- Gibt alle TimeIDs zwischen FromDate und ToDate zurück
IF OBJECT_ID ('tempdb..#Days') IS NOT NULL DROP TABLE #Days

CREATE TABLE #Days
	(
	TimeID BIGINT
		)

DECLARE @FromDate	DATE = '2019-01-01'
DECLARE @ToDate		DATE = '2019-12-31'    

WHILE @ToDate>=@FromDate

	BEGIN
		INSERT INTO #Days
			SELECT FORMAT(@fromdate,'yyyyMMdd') AS TimeID

		SET @FromDate = dateadd(d, 1, @fromdate)
			
	END

SELECT * FROM #Days	
````

## List of Weeks with startdate - enddate as TimeID
````SQL
DECLARE @FromDate DATE = '2016-08-01'    
DECLARE @ToDate DATE  = '2017-12-31'    

SELECT @fromdate = dateadd(day, datediff(day, 0, @FromDate)/7*7, 0), 
@todate = dateadd(day, datediff(day, 0, @ToDate)/7*7, 6)


--INSERT INTO #Weeks
	SELECT
		Format(dateadd(d, number * 7, @fromdate),'yyyyMMdd') StartTimeID, 
		Format(dateadd(d, number * 7 + 6, @fromdate),'yyyyMMdd') EndTimeID
	FROM
	master..spt_values
	WHERE type = 'P' and
	@todate >= dateadd(d, number * 7, @fromdate)
````

## Generate TimeID as running number (laufende Nummer)
````SQL
10000000 + ROW_NUMBER()OVER(PARTITION BY '[Partitionierungsmerkmal]' ORDER BY '[Sortiermerkmal]') *100 +1
````
