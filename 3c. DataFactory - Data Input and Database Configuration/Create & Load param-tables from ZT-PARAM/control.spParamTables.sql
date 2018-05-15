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
DECLARE	@TableSchema							NVARCHAR(MAX)	= 'param.'
DECLARE @TableDelete							NVARCHAR(MAX)
DECLARE @TableDeleteName						NVARCHAR(MAX)
DECLARE @SQLDrop								NVARCHAR(MAX)

DECLARE @RC										INT

-------------------------------------------------------------------------------------------------------------------
-- ##### IF EXISTS ###########
BEGIN
	DECLARE MyCursorParam CURSOR FOR
		SELECT 
		  tbl.name			AS TableName 
		FROM sys.tables tbl
		INNER JOIN sys.schemas sch ON tbl.schema_id = sch.schema_id
		WHERE sch.name = 'param' AND tbl.name LIKE 't%'
	OPEN MyCursorParam
	FETCH MyCursorParam INTO @TableDeleteName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @TableDelete = @TableSchema + @TableDeleteName
		SET @SQLDrop = 'IF OBJECT_ID(''' + @TableDelete + ''', ''U'') IS NOT NULL	DROP TABLE ' + @TableDelete

		EXECUTE sp_executesql @SQLDrop
		
		FETCH MyCursorParam INTO @TableDeleteName
	END
	CLOSE MyCursorParam
	DEALLOCATE MyCursorParam
END

-------------------------------------------------------------------------------------------------------------------
-- ##### CREATE ###########
	DECLARE MyCursorParam CURSOR FOR

		SELECT dP.ProductID
		FROM [dbo].[sx_pf_dProducts] dP
		WHERE dP.FactoryID = 'ZT' AND dP.ProductLIneID = 'PARAM'

	OPEN MyCursorParam
		FETCH MyCursorParam INTO @TemplateProductID
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
      			FETCH MyCursorParam INTO @TemplateProductID
			END
	CLOSE MyCursorParam
	DEALLOCATE MyCursorParam

-------------------------------------------------------------------------------------------------------------------	
GO
GRANT EXECUTE ON OBJECT ::[control].[spParamTables] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[control].[spParamTables] TO pf_PlanningFactoryService;
GO