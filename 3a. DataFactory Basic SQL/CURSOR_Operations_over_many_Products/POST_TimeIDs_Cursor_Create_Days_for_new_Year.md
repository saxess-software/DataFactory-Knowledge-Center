

````SQL
/*
Script to POST new TimeIDs for one Year on a daily base into a Template
Gerd Tautenhahn for saxess-software gmbh
10/2017 DataFactory 4.0
*/


DECLARE @ToDoListe AS Table (
 FromDate Datetime NOT NULL
,TimeID BIGINT NOT NULL
,Name_of_Day NVARCHAR(255) NOT NULL
)


DECLARE @Year AS INT
DECLARE @FirstDateOfYear DATETIME
DECLARE @LastDateOfYear DATETIME
--CONFIG ****************
SELECT @year = 2018 -- Set the Year
--************************

SELECT @FirstDateOfYear = DATEADD(yyyy, @Year - 1900, 0);
SELECT @LastDateOfYear = DATEADD(yyyy, @Year - 1900 + 1, 0);

-- Write all Days of the Year into a List
WITH cte AS (
				SELECT 1 AS DayID,
				@FirstDateOfYear AS FromDate,
				DATENAME(dw, @FirstDateOfYear) AS Name_of_Day
				UNION ALL
				SELECT cte.DayID + 1 AS DayID,
				DATEADD(d, 1 ,cte.FromDate),
				DATENAME(dw, DATEADD(d, 1 ,cte.FromDate)) AS Name_of_Day
				FROM cte
				WHERE DATEADD(d,1,cte.FromDate) < @LastDateOfYear
				)


INSERT INTO @ToDoListe 

	SELECT 
		 FromDate AS Date
		,CONVERT(nvarchar(10), FromDate,112) AS TimeID
		,Name_of_Day
	FROM CTE
	WHERE Name_of_Day NOT IN ('Samstag','Sonntag') -- CONFIG !!

	OPTION (MaxRecursion 370) -- erlaubt größeren Rekursionswerte als den Standard von 100


--SELECT * FROM @ToDoListe

DECLARE @FactoryID NVARCHAR(255) = 'ZT'    -- CONFIG: Set Targets
DECLARE @ProductLineID NVARCHAR(255) = 'U'
DECLARE @ProductID NVARCHAR(255) = '21'
DECLARE @Day DATETIME 
DECLARE @TimeID	BIGINT
DECLARE @Name_of_Day NVARCHAR(255)

DECLARE MyCursor CURSOR FOR
	SELECT * FROM @ToDoListe
OPEN MyCursor
FETCH MyCursor INTO @Day,@TimeID,@Name_of_Day
WHILE @@FETCH_STATUS = 0
BEGIN
	  -- Create TimeID
      EXEC sx_pf_POST_TimeID 'SQL', @ProductID,@ProductLineID,@FactoryID,@TimeID
	  -- Name of the day into a ValueSeries
	  EXEC sx_pf_POST_Value 'SQL', @ProductID,@ProductLineID,@FactoryID,'K1',@TimeID,'','',@Name_of_Day,''
      
      FETCH MyCursor INTO @Day,@TimeID,@Name_of_Day
	  
END
CLOSE MyCursor
DEALLOCATE MyCursor 


````