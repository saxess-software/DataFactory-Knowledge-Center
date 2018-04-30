/*
	EXEC [control].[spParamTables]
*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[spParamTables]') AND type in (N'P', N'PC'))
DROP PROCEDURE [control].[spParamTables]
GO

CREATE PROCEDURE [control].[spParamTables]
AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
DECLARE @TemplateProductID						NVARCHAR(255)
DECLARE @RC										INT

-------------------------------------------------------------------------------------------------------------------
-- ##### CREATE ###########
	DECLARE MyCursor CURSOR FOR

		SELECT dP.ProductID
		FROM [dbo].[sx_pf_dProducts] dP
		WHERE dP.FactoryID = 'ZT' AND dP.ProductLIneID = 'PARAM'

	OPEN MyCursor
		FETCH MyCursor INTO @TemplateProductID
		WHILE @@FETCH_STATUS = 0
			BEGIN
				BEGIN
					EXEC @RC = [param].[spCreateParamTable] 'SQL',@TemplateProductID
						PRINT @RC
				END
				BEGIN
					EXEC @RC =[param].[spFillParamTable]  'SQL',@TemplateProductID
					PRINT @RC
				END
      			FETCH MyCursor INTO @TemplateProductID
			END
	CLOSE MyCursor
	DEALLOCATE MyCursor

-------------------------------------------------------------------------------------------------------------------	
GO
GRANT EXECUTE ON OBJECT ::[control].[spParamTables] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[control].[spParamTables] TO pf_PlanningFactoryService;
GO