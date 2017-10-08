

/*

Post all Templates from ZT in all Factories except ZT

*/

DECLARE @ToDoListe AS Table (
 TargetFactoryID			NVARCHAR(255) NOT NULL
,TargetProductLineID		NVARCHAR(255) NOT NULL
,TargetProductID			NVARCHAR(255) NOT NULL
,TargetProductTemplate		NVARCHAR(255) NOT NULL
,TemplateFactoryID			NVARCHAR(255) NOT NULL
,TemplateProductlineID		NVARCHAR(255) NOT NULL
,TemplateProductID			NVARCHAR(255) NOT NULL
,TemplateTemplate			NVARCHAR(255) NOT NULL
)

INSERT INTO @ToDoListe 
	SELECT   dP.FactoryID		AS TargetFactoryID
			,dP.ProductLineID	AS TargetProductLineID
			,dP.ProductID		AS TargetProductID
			,dP.Template		AS TargetProductTemplate
			,dP2.FactoryID		AS TemplateFactoryID
			,dP2.ProductLineID	AS TemplateProductlineID
			,dP2.ProductID		AS TemplateProductID
			,dP2.Template		AS TemplateTemplate
	FROM	sx_pf_dProducts dP
	 INNER JOIN dbo.sx_pf_dProducts dP2 ON dP.Template = dP2.Template
	WHERE   dP.FactoryID NOT IN  ('ZT','ZS','CM') 
	 AND    dP2.FactoryID = 'ZT'
	 --AND	dP2.Template = 'Template Name' -- for specific Template

-- Check Values at ToDoList
SELECT *		
FROM @ToDoListe

DECLARE @TargetFactoryID			NVARCHAR(255) 
DECLARE @TargetProductLineID		NVARCHAR(255) 
DECLARE @TargetProductID			NVARCHAR(255) 
DECLARE @TemplateFactoryID			NVARCHAR(255) 
DECLARE @TemplateProductlineID		NVARCHAR(255)
DECLARE @TemplateProductID			NVARCHAR(255) 

DECLARE MyCursor CURSOR FOR
	SELECT   TargetFactoryID		
			,TargetProductLineID	
			,TargetProductID
			,TemplateFactoryID
			,TemplateProductlineID		
			,TemplateProductID					
	FROM @ToDoListe
OPEN MyCursor
FETCH MyCursor INTO @TargetFactoryID,@TargetProductLineID,@TargetProductID,@TemplateFactoryID,@TemplateProductlineID,@TemplateProductID	
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC sx_pf_POST_Template 'SQL', @TargetProductID,@TargetProductLineID,@TargetFactoryID,@TemplateProductID,@TemplateProductLineID,@TemplateFactoryID,0
      
      FETCH MyCursor INTO @TargetFactoryID,@TargetProductLineID,@TargetProductID,@TemplateFactoryID,@TemplateProductlineID,@TemplateProductID	
	  Print  @TargetProductID+'_'+@TargetProductLineID+'_'+@TargetFactoryID + ' done'
END
CLOSE MyCursor
DEALLOCATE MyCursor 