
TimeID from DateTime
````SQL
SELECT CONVERT(char(10), GETDATE(),112)
````

Liste of TimeIDs per Month for given Years 2017-2018
````SQL
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
