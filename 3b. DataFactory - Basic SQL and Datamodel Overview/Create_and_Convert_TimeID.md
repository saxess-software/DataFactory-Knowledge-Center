
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

Check if TimeID is weekday
````SQL
IIF(Datepart(weekday,CONVERT(Datetime,CAST(TimeID AS NVARCHAR(10))))<=5,1,0)  AS Day_is_Weekday
````


## List of Month
Liste of TimeIDs per Month for given Years 2017-2018
````SQL
-- Helper for Timeline
IF OBJECT_ID('tempdb..#Jahre') IS NOT NULL DROP TABLE #Jahre
CREATE TABLE #Jahre (Jahr INT) 
	INSERT INTO #Jahre VALUES (2017),(2018)

IF OBJECT_ID('tempdb..#Monate') IS NOT NULL DROP TABLE #Monate
CREATE TABLE #Monate (Monat INT) 
	INSERT INTO #Monate VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)

IF OBJECT_ID('tempdb..#Monatsliste') IS NOT NULL DROP TABLE #Monatsliste;

CREATE TABLE #Monatsliste (
	TimeID BIGINT NOT NULL
	)

INSERT INTO #Monatsliste
	SELECT Jahr * 10000 + Monat*100 + 15 AS TimeID FROM #Jahre LEFT JOIN #Monate ON 1=1
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

DECLARE @FromDate DATE 
SELECT TOP 1 @FromDate = ImportDatum FROM staging.tMassnahmenwerte  -- den Tag des letzten Import als Starttag für den Zeitspreizer setzen 
DECLARE @ToDate DATE  = '2018-12-31'    

SELECT @fromdate = dateadd(day, datediff(day, 0, @FromDate), 0), 
@todate = dateadd(day, datediff(day, 0, @ToDate), 0)

INSERT INTO #Days
	SELECT
		Format(dateadd(d, number, @fromdate),'yyyyMMdd') TimeID
	FROM
	master..spt_values
	WHERE type = 'P' and
	@todate >= dateadd(d, number , @fromdate)
	
-- SELECT * FROM #Days	
````

