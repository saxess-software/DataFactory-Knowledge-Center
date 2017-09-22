
This script copys a product (typically one of your templates) to many Factories.
e.g. to rollout a template to many Factories

`````SQL

DECLARE @FactoryID NVARCHAR(255) 
DECLARE @ProductLineID NVARCHAR(255) 
DECLARE @NameShort NVARCHAR(255) 
DECLARE @SourceProductID NVARCHAR(255) 
DECLARE MyCursor CURSOR FOR

	SELECT 
		 FactoryID
		,ProductLineID
		,CASE NameShort 
			WHEN 'Investitionen' THEN 'Investitionsliste'
			WHEN 'Investments' THEN 'List of Investments'
			ELSE 'Fehler'
		 END AS NameShort
		,CASE NameShort 
			WHEN 'Investitionen' THEN '1'
			WHEN 'Investments' THEN '2'
			ELSE 'Fehler'
		 END AS SourceProductID
	FROM
		sx_pf_dProductlines

	WHERE 
		FactoryID <> 'ZT' 

OPEN MyCursor
FETCH MyCursor INTO @FactoryID,@ProductLineID,@NameShort, @SourceProductID
WHILE @@FETCH_STATUS = 0
BEGIN
      EXEC dbo.sx_pf_COPY_Product 'SQL', 'ZT', 'I', @SourceProductID,@FactoryID,@ProductLineID,'1',@NameShort
      
      FETCH MyCursor INTO  @FactoryID,@ProductLineID,@NameShort, @SourceProductID
	
END
CLOSE MyCursor
DEALLOCATE MyCursor 

`````