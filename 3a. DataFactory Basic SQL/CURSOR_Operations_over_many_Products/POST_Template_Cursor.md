

````SQL
/*
Script to execute POST_Template for all selected Products
Gerd Tautenhahn for saxess-software gmbh
03/2017 DataFactory 4.0
*/


DECLARE @ToDoListe AS Table (
 FactoryID  NVARCHAR(255) NOT NULL
,ProductLineID NVARCHAR(255) NOT NULL
,ProductID NVARCHAR(255) NOT NULL
)

INSERT INTO @ToDoListe 
	SELECT 
		 FactoryID
		,ProductLineID
		,ProductID
	FROM
		sx_pf_dProducts

	WHERE 
		Template = 'P_Leihaussen_VM'
		AND FactoryID <> 'ZT' 

SELECT * FROM @ToDoListe

DECLARE @FactoryID NVARCHAR(255) 
DECLARE @ProductLineID NVARCHAR(255) 
DECLARE @ProductID NVARCHAR(255)
DECLARE MyCursor CURSOR FOR
	SELECT * FROM @ToDoListe
OPEN MyCursor
FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC sx_pf_POST_Template 'SQL', @ProductID,@ProductLineID,@FactoryID,'P_12','MPT','ZT',0
      
      FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID
	  Print  @ProductID+'_'+@ProductLineID+'_'+@FactoryID + ' done'
END
CLOSE MyCursor
DEALLOCATE MyCursor 


````