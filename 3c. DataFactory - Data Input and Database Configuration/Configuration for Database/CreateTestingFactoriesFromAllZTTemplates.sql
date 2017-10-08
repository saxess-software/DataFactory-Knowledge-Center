/* Script to create the testing database from Templatelines
Gerd Tautenhahn for saxess-software gmbh
04/2016 PlanningFactory 4.0
Preconditions:
	- a Cluster with Factory ZT exists
	- the Products should be filled manually with demo values
*/

DECLARE @ProductCount INT = 30
DECLARE @Counter INT = 0


DECLARE @TemplateProductID nvarchar(255) =''
DECLARE @TemplateProductName nvarchar(255) =''
DECLARE @TemplateName nvarchar (255) = ''
DECLARE @TemplateProductLineID nvarchar(255) =''
DECLARE @TemplateProductLineName nvarchar(255) =''
DECLARE @TemplateFactoryID nvarchar(255) = 'ZT'

DECLARE @ProductID nvarchar(255) =''
DECLARE @ProductLineID nvarchar(255) =''
DECLARE @FactoryID nvarchar(255) =''

	-- Create a Factory from each ZT-Productline
	DECLARE MyCursor CURSOR FOR

	SELECT ProductLineID, NameShort
	FROM sx_pf_dProductlines WHERE FactoryID = @TemplateFactoryID

	OPEN MyCursor
	FETCH MyCursor INTO @TemplateProductLineID, @TemplateProductLineName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		  EXEC sx_pf_POST_Factory 'SQL',@TemplateProductLineID, @TemplateProductLineName,'','','','',''

		  FETCH MyCursor INTO @TemplateProductLineID, @TemplateProductLineName
	END
	CLOSE MyCursor
	DEALLOCATE MyCursor

	-- Create a Productline from each ZT-Product in the fitting ZT-Factory

	DECLARE MyCursor CURSOR FOR

	SELECT ProductLineID, ProductID, NameShort
	FROM sx_pf_dProducts WHERE FactoryID = @TemplateFactoryID

	OPEN MyCursor
	FETCH MyCursor INTO @TemplateProductLineID, @TemplateProductID, @TemplateProductName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		  EXEC sx_pf_POST_ProductLine 'SQL',@TemplateProductID ,@TemplateProductLineID, @TemplateProductName,'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''

		  FETCH MyCursor INTO @TemplateProductLineID, @TemplateProductID, @TemplateProductName
	END
	CLOSE MyCursor
	DEALLOCATE MyCursor


	-- Create N Products from each ZT-Product in the fitting Productline

	DECLARE MyCursor CURSOR FOR

	SELECT ProductLineID, ProductID, NameShort, Template
	FROM sx_pf_dProducts WHERE FactoryID = @TemplateFactoryID

	OPEN MyCursor
	FETCH MyCursor INTO @TemplateProductLineID, @TemplateProductID, @TemplateProductName, @TemplateName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		  SET @Counter = 1
		  WHILE @Counter <= @ProductCount
			BEGIN		  
				EXEC sx_pf_POST_Product 'SQL', @Counter ,@TemplateProductID,@TemplateProductlineID,'', @TemplateProductName,'','','','','','',@TemplateName,'','','','','','','','','','','','','','','','','','','','','','','','','',''
				SET @Counter = @Counter + 1
			END
		  
		  FETCH MyCursor INTO @TemplateProductLineID, @TemplateProductID, @TemplateProductName, @TemplateName
	END
	CLOSE MyCursor
	DEALLOCATE MyCursor




