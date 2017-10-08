

-- To set a Timeline fixation for all products of To Do list


````SQL
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
		ProductLineID = '4'
		AND FactoryID <> 'ZT' 

--SELECT * FROM @ToDoListe

DECLARE @FactoryID NVARCHAR(255) 
DECLARE @ProductLineID NVARCHAR(255) 
DECLARE @ProductID NVARCHAR(255)
DECLARE MyCursor CURSOR FOR
	SELECT * FROM @ToDoListe
OPEN MyCursor
FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
      -- set fixation after first TimeID
      EXEC sx_pf_POST_ProductProperty 'SQL',@ProductID,'4',@FactoryID,'xl_pdp_header_fixation_offset_timeline','','','','','1','0','1','2',''
      
      -- set Autoscroll off
      --EXEC sx_pf_POST_ProductProperty	'SQL',@ProductID,@ProductLineID,@FactoryID,'xl_pdp_no_autoscroll','','','','','1','0','1','2',''
      
      FETCH MyCursor INTO @FactoryID,@ProductLineID,@ProductID
	  Print  @ProductID+'_'+@ProductLineID+'_'+@FactoryID + ' done'
END
CLOSE MyCursor
DEALLOCATE MyCursor 

````
