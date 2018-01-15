
/*

Import Data from load.tfValues using PostProductDataTableValues

Import ValueSeries from load.tdValueSeries

*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[import].[sp_POST_dValueSeries]') AND type in (N'P', N'PC'))
DROP PROCEDURE [import].[sp_POST_dValueSeries]
GO

CREATE PROCEDURE [import].[sp_POST_dValueSeries]
					@FactoryID     AS NVARCHAR(255),
					@ProductlineID AS NVARCHAR(255),
					@ProductID	 AS NVARCHAR (255),
					@ValueSeriesID	AS NVARCHAR (255)

		   

AS

SET NOCOUNT ON

DECLARE @TimestampCall AS DATETIME = CURRENT_TIMESTAMP
DECLARE @ProcedureName AS NVARCHAR (255) = OBJECT_NAME(@@PROCID)
DECLARE @RC INT

DECLARE @RequestedValueSeriesNo	 AS NVARCHAR (255)
DECLARE @NameShort				 AS NVARCHAR (255)
DECLARE @NameLong				 AS NVARCHAR (255)
DECLARE @CommentUser			 AS NVARCHAR (255)
DECLARE @CommentDev				 AS NVARCHAR (255)
DECLARE @ImageName				 AS NVARCHAR (255)
DECLARE @IsNumeric				 AS NVARCHAR (255)
DECLARE @VisibilityLevel		 AS NVARCHAR (255)
DECLARE @ValueSource			 AS NVARCHAR (255)
DECLARE @ValueListID			 AS NVARCHAR (255)
DECLARE @ValueFormatID			 AS NVARCHAR (255)
DECLARE @Unit					 AS NVARCHAR (255)
DECLARE @Scale					 AS NVARCHAR (255)
DECLARE @Effect					 AS NVARCHAR (255)
DECLARE @EffectParameter		 AS NVARCHAR (255)

-- Temptable for Cursor

IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
	CREATE TABLE #tmp (		
			ProductID				NVARCHAR (255)
		   ,ProductLineID			NVARCHAR (255)
		   ,FactoryID				NVARCHAR (255)
		   ,ValueSeriesID			NVARCHAR (255)
		   ,RequestedValueSeriesNo	NVARCHAR (255)
		   ,NameShort				NVARCHAR (255)
		   ,NameLong				NVARCHAR (255)
		   ,CommentUser				NVARCHAR (255)
		   ,CommentDev				NVARCHAR (255)
		   ,ImageName				NVARCHAR (255)
		   ,IsNumeric				NVARCHAR (255)
		   ,VisibilityLevel			NVARCHAR (255)
		   ,ValueSource				NVARCHAR (255)
		   ,ValueListID				NVARCHAR (255)
		   ,ValueFormatID			NVARCHAR (255)
		   ,Unit					NVARCHAR (255)
		   ,Scale					NVARCHAR (255)
		   ,Effect					NVARCHAR (255)
		   ,EffectParameter			NVARCHAR (255)
		  )

INSERT INTO #tmp
	SELECT   tdVS.ProductID				
			,tdVS.ProductLineID			
			,tdVS.FactoryID				
			,tdVS.ValueSeriesID			
			,tdVS.ValueSeriesNo	
			,tdVS.NameShort				
			,tdVS.NameLong				
			,tdVS.CommentUser				
			,tdVS.CommentDev				
			,tdVS.ImageName				
			,tdVS.IsNumeric				
			,tdVS.VisibilityLevel			
			,tdVS.ValueSource				
			,tdVS.ValueListID				
			,tdVS.ValueFormatID			
			,tdVS.Unit					
			,tdVS.Scale					
			,tdVS.Effect					
			,tdVS.EffectParameter	
	FROM	load.tdValueSeries tdVS
	WHERE	(@FactoryID = '' OR tdVS.FactoryID = @FactoryID)
	 AND    (@ProductLineID = '' OR tdVS.ProductLineID = @ProductLineID)
	 AND    (@ProductID = '' OR tdVS.ProductID = @ProductID)
	 AND    (@ValueSeriesID = '' OR tdVS.ValueSeriesID = @ValueSeriesID)

DECLARE MyCursor CURSOR FOR
	SELECT * 
	FROM #tmp t
OPEN MyCursor
FETCH MyCursor INTO @ProductID,@ProductLineID,@FactoryID,@ValueSeriesID,@RequestedValueSeriesNo,@NameShort,@NameLong,@CommentUser,@CommentDev,@ImageName,@IsNumeric,@VisibilityLevel,@ValueSource,@ValueListID,@ValueFormatID,@Unit,@Scale,@Effect,@EffectParameter

WHILE @@FETCH_STATUS = 0
BEGIN
EXECUTE @RC = [dbo].[sx_pf_POST_ValueSerie]
		'SQL'
		,@ProductID
		,@ProductLineID
		,@FactoryID
		,@ValueSeriesID
		,@RequestedValueSeriesNo
		,@NameShort
		,@NameLong
		,@CommentUser
		,@CommentDev
		,@ImageName
		,@IsNumeric
		,@VisibilityLevel
		,@ValueSource
		,@ValueListID
		,@ValueFormatID
		,@Unit
		,@Scale
		,@Effect
		,@EffectParameter				
Print @RC
FETCH MyCursor INTO @ProductID,@ProductLineID,@FactoryID,@ValueSeriesID,@RequestedValueSeriesNo,@NameShort,@NameLong,@CommentUser,@CommentDev,@ImageName,@IsNumeric,@VisibilityLevel,@ValueSource,@ValueListID,@ValueFormatID,@Unit,@Scale,@Effect,@EffectParameter
END
CLOSE MyCursor
DEALLOCATE MyCursor

GO
