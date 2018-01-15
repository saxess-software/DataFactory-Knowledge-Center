
/*

Stefan Lindenlaub
2018/01

Import Data from load.tfValues using PostValue

*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[import].[sp_POST_fValues]') AND type in (N'P', N'PC'))
DROP PROCEDURE [import].[sp_POST_fValues]
GO

CREATE PROCEDURE [import].[sp_POST_fValues]
					 @FactoryID AS NVARCHAR(255),
					 @ProductlineID AS NVARCHAR(255),
					 @ProductID	 AS NVARCHAR (255),
					 @ValueSeriesID	AS NVARCHAR (255),
					 @TimeID INT
		   

AS

SET NOCOUNT ON

DECLARE @TimestampCall AS DATETIME = CURRENT_TIMESTAMP
DECLARE @ProcedureName AS NVARCHAR (255) = OBJECT_NAME(@@PROCID)
DECLARE @RC INT

DECLARE @ValueFormula			 AS NVARCHAR (255)
DECLARE @ValueINT				 AS INT
DECLARE @ValueText				 AS NVARCHAR (255)
DECLARE @ValueComment			 AS NVARCHAR (255)

-- Temptable for Cursor

IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
	CREATE TABLE #tmp (
		ProductID		NVARCHAR (255)
		,ProductLineID	NVARCHAR (255)
		,FactoryID		NVARCHAR (255)
		,ValueSeriesID	NVARCHAR (255)
		,TimeID			INT
		,ValueFormula	NVARCHAR (255)
		,ValueINT		INT
		,ValueText		NVARCHAR (255)
		,ValueComment	NVARCHAR (255)	
		  )

INSERT INTO #tmp
	SELECT   tfV.ProductID		
			,tfV.ProductLineID	
			,tfV.FactoryID		
			,tfV.ValueSeriesID	
			,tfV.TimeID			
			,tfV.ValueFormula	
			,tfV.ValueINT		
			,tfV.ValueText		
			,tfV.ValueComment			
	FROM	load.tfValues tfV
	WHERE	(@FactoryID = '' OR tfV.FactoryID = @FactoryID)
	 AND    (@ProductLineID = '' OR tfV.ProductLineID = @ProductLineID)
	 AND    (@ProductID = '' OR tfV.ProductID = @ProductID)
	 AND    (@ValueSeriesID = '' OR tfV.ValueSeriesID = @ValueSeriesID)
	 AND    (@TimeID = 0 OR tfV.TimeID = @TimeID)



DECLARE MyCursor CURSOR FOR
	SELECT *
	FROM #tmp t
OPEN MyCursor
FETCH MyCursor INTO @ProductID,@ProductLineID,@FactoryID,@ValueSeriesID,@TimeID,@ValueFormula,@ValueINT,@ValueText,@ValueComment

WHILE @@FETCH_STATUS = 0
BEGIN
EXECUTE @RC = [dbo].[sx_pf_POST_Value]
		'SQL'
		,@ProductID		
		,@ProductLineID	
		,@FactoryID		
		,@ValueSeriesID	
		,@TimeID			
		,@ValueFormula	
		,@ValueINT		
		,@ValueText		
		,@ValueComment							
Print @RC
FETCH MyCursor INTO @ProductID,@ProductLineID,@FactoryID,@ValueSeriesID,@TimeID,@ValueFormula,@ValueINT,@ValueText,@ValueComment
END
CLOSE MyCursor
DEALLOCATE MyCursor

GO
