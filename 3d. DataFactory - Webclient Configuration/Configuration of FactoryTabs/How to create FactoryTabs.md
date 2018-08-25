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


FAQ:

#### I see a Tab with the name, but no empty PivotTable
* You forgot to GRANT Rights
* The SP brings no data for the current user - check it by returing static query values without security