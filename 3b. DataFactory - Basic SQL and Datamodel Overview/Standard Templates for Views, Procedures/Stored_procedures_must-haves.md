# Stored procedures must-haves

- Header with information on content of procedure, creation date, author
- Every DATAOUTPUT Procedure must have the parameters: @username, @factoryid,@productlineid (to use it with the webclient)
- To call a dataoutput procedure from a webcluster via PowerQuery it must be named as dbo.sx_pf_DATAOUTPUT_Name
- Drop procedure if already exists and create procedure
- Clean IDs
- Set nocount on
- Write API log entry
- Grant execute to PlanningFactoryUser & PlanningFactoryService

```sql

/*
Procedure name / procedure content
Author
Creation date
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sx_pf_DATAOUTPUT_fValues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sx_pf_DATAOUTPUT_fValues]
GO

CREATE PROCEDURE sx_pf_DATAOUTPUT_fValues (@Username AS NVARCHAR(255), @FactoryID AS NVARCHAR(255)='', @ProductLineID AS NVARCHAR(255)='')

AS

SET NOCOUNT ON

		

	EXEC sx_pf_pPOST_API_LogEntry @Username,@TransactUsername,@ProcedureName,@ParameterString,@EffectedRows,@ResultCode,@TimestampCall,@Comment
		
		

GO
  
GRANT EXECUTE ON OBJECT ::[dbo].[sx_pf_DATAOUTPUT_fValues] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[dbo].[sx_pf_DATAOUTPUT_fValues] TO pf_PlanningFactoryService;
GO
```
