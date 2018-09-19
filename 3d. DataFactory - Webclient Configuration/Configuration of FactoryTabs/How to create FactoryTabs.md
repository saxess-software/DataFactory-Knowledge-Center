On the Factory Level, you can have in the Webclient different Tabs which show
* PivotTables and/or PivotCharts - Type "Pivot"
* HTML Pages (based on file or URL, files you can edit with the editor) - Type "HTML_URL"
* HTML Pages (based on a Query, you can't edit them in the editor) - Type "HTML_Static"

To create the Tabs you use the procedure "sx_POST_FactoryTab", you must POST this Tab per Factory.


## Tabs of Type PivotTable / PivotChart
* this type of Tab need a DataSource - this DataSource must be a Stored Procedure
* the Procedure can be in any schema and can have any name
* this StoredProcedure must ensure
    * it has tree parameter @Username, @FactoryID, @ProductlineID
    * it returns one Resultset
    * it has a GRANT EXECUTE to pf_PlanningFactoryUser
    * it has a GRANT EXECUTE to pf_PlanningFactoryService
* it is recommend that this Procedure
    * implements security by checking TransactUsername and joins vUserRights based on this
    * writes an API Log Entry

Example
```` SQL
Example of POST a Pivot Table
DECLARE @RC					INT
DECLARE @Username 			NVARCHAR(255) = 'SQL'
DECLARE @FactoryID			NVARCHAR(255) = '[FactoryID]'
DECLARE @TabID				NVARCHAR(255) = 'Tab01' -- Number of Tab
DECLARE @Label				NVARCHAR(255) = 'Investments'
DECLARE @CommentUser		NVARCHAR(MAX) = 'You can pivot your Investments here.'
DECLARE @PresentationType	NVARCHAR(255) = 'Pivot'	
DECLARE @Source				NVARCHAR(MAX) = 'result.Investments'		
DECLARE @Layout				NVARCHAR(MAX) = ''

EXECUTE @RC = dbo.sx_pf_POST_FactoryTab 
		@Username,
		@FactoryID,
		@TabID,
		@Label,
		@CommentUser,
		@PresentationType,
		@Source,
		@Layout

PRINT @RC
```` 

After that you will get a Tab with this name and an empty Pivottable. You can than create on the GUI and Pivot / PivotChart Configuration and save this. 

If you have the same Tab in many Factories, you must rollout the Layout String to all Tabs. Best way is to set up a master factory and rollout its configuration by script.


#### FAQ 1: I see a Tab with the name, but no empty PivotTable - anything runs into an Error
* You forgot to GRANT Rights
* The SP brings no data for the current user - check it by returing static query values without security
* There are two columns with the same name
* There is a column with a reserverd name e.g. "Right" or "Left"
* The Procedure runs into an error on database, when executed for this Factory



## Tabs of Type HTML

They must be placed anywhere on the Server (on Azure you need FTP Connection) and can then be referenced with a path relative to wwwroot.
You can create and edit them with the editor on Start page and then move them somewhere else to get the right css classes.

```` SQL
DECLARE @RC					INT
DECLARE @Username 			NVARCHAR(255) = 'SQL'
DECLARE @FactoryID			NVARCHAR(255) = 'SM'

-- Tab 1 mit Startseite
DECLARE @TabID				NVARCHAR(255) = 'Tab01'
DECLARE @Label				NVARCHAR(255) = 'Info'
DECLARE @CommentUser		NVARCHAR(MAX) = 'Analytic Overview'
DECLARE @PresentationType	NVARCHAR(255) = 'HTML_URL'	
DECLARE @Source				NVARCHAR(MAX) = 'assets/html/info.html'		
DECLARE @Layout				NVARCHAR(MAX) = ''

EXECUTE @RC = dbo.sx_pf_POST_FactoryTab 
		@Username,
		@FactoryID,
		@TabID,
		@Label,
		@CommentUser,
		@PresentationType,
		@Source,
		@Layout

PRINT @RC
````


## Rollout of Tabs from a Masterfactory to all Factories

```` SQL
DECLARE @MasterFactoryID	NVARCHAR(255) = 'SM'  -- SET ID of MasterFactory !
DECLARE @FactoryID			NVARCHAR(255) = ''
DECLARE @TabID				NVARCHAR(255) = ''
DECLARE @Label				NVARCHAR(255) = ''
DECLARE @CommentUser		NVARCHAR(MAX) = ''
DECLARE @PresentationType	NVARCHAR(255) = ''	
DECLARE @Source				NVARCHAR(MAX) = ''		
DECLARE @Layout				NVARCHAR(MAX) = ''


DECLARE MyCursor CURSOR FOR

	-- Query fills the Cursor
	SELECT 
		 dF.FactoryID
		,gF.PropertyID		AS TabID
		,gF.PropertyName	AS Label
		,gF.CommentUser	AS CommentUser
		,gF.Unit			AS PresentationType
		,gF.ValueText		AS [Source]
		,gF.CommentDev		AS Layout
	FROM dbo.sx_pf_gFactories gF
		LEFT JOIN (	
					SELECT FactoryID FROM dbo.sx_pf_dFactories
					WHERE FactoryID NOT IN (@MasterFactoryID,'ZT')
					) dF
						ON 1=1
	WHERE 
			gF.FactoryID = @MasterFactoryID
		AND gF.PropertyID IN ('Tab01','Tab02','Tab03')   -- Maybe change Tabs

OPEN MyCursor
	-- Stuff the columns of the first row into the Cursor
	FETCH MyCursor INTO @FactoryID,@TabID,@Label,@CommentUser,@PresentationType,@Source,@Layout
	WHILE @@FETCH_STATUS = 0
		BEGIN
     	 		EXEC dbo.sx_pf_POST_FactoryTab  'SQL', @FactoryID,@TabID,@Label,@CommentUser,@PresentationType,@Source,@Layout

			-- Stuff the columns of the next row into the Cursor
      		FETCH MyCursor INTO @FactoryID,@TabID,@Label,@CommentUser,@PresentationType,@Source,@Layout
		END
CLOSE MyCursor
DEALLOCATE MyCursor

````
