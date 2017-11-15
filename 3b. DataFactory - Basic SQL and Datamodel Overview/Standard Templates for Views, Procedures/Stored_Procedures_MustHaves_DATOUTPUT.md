
# Stored procedures must-haves | DATAOUTPUT/result - procedures

- Header with information on content of procedure, creation date, author
- Drop procedure if already exists and create procedure
- Clean IDs
- Set nocount on
- Check if user is an active user
- Check user rights and provide output according to rights
- Write API log entry
- Grant execute to PlanningFactoryUser & PlanningFactoryService

```sql
/*
Procedure name / procedure content
Author
Creation date
EXEC sx_pf_DATAOUTPUT_fValues_Test '1','AD',''
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sx_pf_DATAOUTPUT_fValues_Test]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sx_pf_DATAOUTPUT_fValues_Test]
GO

CREATE PROCEDURE sx_pf_DATAOUTPUT_fValues_Test (@Username AS NVARCHAR(255), @FactoryID AS NVARCHAR(255)='', @ProductLineID AS NVARCHAR(255)='')

AS

SET NOCOUNT ON

BEGIN
	 BEGIN TRY
		BEGIN TRANSACTION ONE

			DECLARE @TransactUsername AS NVARCHAR (255)
			DECLARE @FactoryKey AS BIGINT
			DECLARE @ProductLineKey AS BIGINT
			DECLARE @RightFlag AS INT

			--<fix log block>
			DECLARE @ProcedureName AS NVARCHAR (255) = OBJECT_NAME(@@PROCID)
			DECLARE @ParameterString AS NVARCHAR (MAX) = ''				-- SET HERE (all Parameters)
			DECLARE @EffectedRows AS INTEGER = 0						-- SET during Execution
			DECLARE @ResultCode AS INTEGER = 501						-- SET during Execution
			DECLARE @TimestampCall AS DATETIME = CURRENT_TIMESTAMP
			DECLARE @Comment AS NVARCHAR (2000) = ''					-- SET during Execution

			SET @ParameterString = '''' + @Username + ''',''' +  @FactoryID +''','''+ @ProductLineID +''
			--<fix log block/>

			-- clean IDs
			SET @Username = dbo.sx_pf_pProtectString(@Username)
			SET @FactoryID = dbo.sx_pf_pProtectID(@FactoryID)
			SET @ProductLineID = dbo.sx_pf_pProtectID(@ProductLineID)

			-- 1. Determine Transaction User
			SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username)
			IF @TransactUsername  = '403'	
					BEGIN
						SET @ResultCode = 403
						ROLLBACK TRANSACTION ONE
						EXEC sx_pf_pPOST_API_LogEntry @Username,@TransactUsername,@ProcedureName,@ParameterString,@EffectedRows,@ResultCode,@TimestampCall,@Comment
						RETURN @ResultCode
					END
			
			-- 2. Check if FactoryID or ProductLineID exists. If not, Rollback return ResulcCode '404'
				SELECT @FactoryKey = FactoryKey FROM sx_pf_dFactories WHERE (@FactoryID = '' OR FactoryID = @FactoryID) AND FactoryID != 'ZT'
				SELECT @ProductLineKey = ProductLineKey FROM sx_pf_dProductLines WHERE (@FactoryID = '' OR FactoryID = @FactoryID) AND FactoryID != 'ZT' AND (@ProductLineID = '' OR ProductLineID = @ProductLineID)
				IF @FactoryKey IS NULL OR @ProductLineKey IS NULL
									BEGIN
										SET @ResultCode = 404
										ROLLBACK TRANSACTION ONE
										EXEC sx_pf_pPOST_API_LogEntry @Username,@TransactUsername,@ProcedureName,@ParameterString,@EffectedRows,@ResultCode,@TimestampCall,@Comment
										RETURN @ResultCode
									END

			-- 3. Select values according to user rights 
			SELECT * FROM   sx_pf_fValues fV 
				INNER JOIN (SELECT FactoryID,ProductLineID FROM sx_pf_vUserRights WHERE Username = @TransactUsername AND [Right] IN ('Write','Read') GROUP BY FactoryID,ProductLineID) vUR
						ON 	fV.FactoryID = vUR.FactoryID AND fV.ProductLineID = vUR.ProductLineID
			WHERE (@FactoryID = '' OR fV.FactoryID = @FactoryID) AND fV.FactoryID != 'ZT' AND (@ProductLineID = '' OR fV.ProductLineID = @ProductLineID)

			SET @ResultCode = 200

			EXEC sx_pf_pPOST_API_LogEntry @Username,@TransactUsername,@ProcedureName,@ParameterString,@EffectedRows,@ResultCode,@TimestampCall,@Comment
		
		COMMIT TRANSACTION ONE
		RETURN @ResultCode

	END TRY

	BEGIN CATCH
		PRINT 'Rollback due to not executable command.'	
		ROLLBACK TRANSACTION ONE
		SET @EffectedRows = 0
		SET @ResultCode = 500
		SET @Comment = ERROR_MESSAGE()
		EXEC sx_pf_pPOST_API_LogEntry @Username,@TransactUsername,@ProcedureName,@ParameterString,@EffectedRows,@ResultCode,@TimestampCall,@Comment
		RETURN @ResultCode
	END CATCH
END

GO
  
GRANT EXECUTE ON OBJECT ::[dbo].[sx_pf_DATAOUTPUT_fValues_Test] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[dbo].[sx_pf_DATAOUTPUT_fValues_Test] TO pf_PlanningFactoryService;
GO
--```


