
/*

Stefan Lindenlaub
2018/01

Import Rights from load.trRights

*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[import].[sp_POST_rRights]') AND type in (N'P', N'PC'))
DROP PROCEDURE [import].[sp_POST_rRights]
GO

CREATE PROCEDURE [import].[sp_POST_rRights]
			      @UserName AS NVARCHAR(255),
				  @Right AS NVARCHAR(255)

AS

SET NOCOUNT ON

DECLARE @TimestampCall AS DATETIME = CURRENT_TIMESTAMP
DECLARE @ProcedureName AS NVARCHAR (255) = OBJECT_NAME(@@PROCID)
DECLARE @RC INT
DECLARE @EffectedRows AS INT = 0

DECLARE @FactoryID				AS NVARCHAR(255)
DECLARE @ProductLineID			AS NVARCHAR(255)
DECLARE @ProductID				AS NVARCHAR(255)
DECLARE	@ReadCommentMandatory   AS INT
DECLARE @WriteCommentMandatory  AS INT

-- Temptable for Cursor

IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
	CREATE TABLE #tmp (		 UserName		 NVARCHAR(255)
							,FactoryID		 NVARCHAR(255)
							,ProductLineID   NVARCHAR(255)
							,ProductID		 NVARCHAR(255)
							,[Right]		 NVARCHAR(255)
							,ReadCommentMandatory INT
							,WriteCommentMandatory INT
						    )

INSERT INTO #tmp
	SELECT   trR.UserName		 
			,trR.FactoryID		 
			,trR.ProductLineID  
			,trR.ProductID		 
			,trR.[Right]		 
			,trR.ReadCommentMandatory
			,trR.WriteCommentMandatory
	FROM	load.trRights trR
	WHERE	(@UserName = '' OR trR.UserName = @UserName)
	  AND   (@Right = '' OR trR.[Right] = @Right)


DECLARE MyCursor CURSOR FOR
	SELECT *
	FROM #tmp t
OPEN MyCursor
FETCH MyCursor INTO @UserName, @FactoryID, @ProductLineID, @ProductID, @Right, @ReadCommentMandatory, @WriteCommentMandatory
WHILE @@FETCH_STATUS = 0
BEGIN
EXECUTE @RC = [dbo].[sx_pf_POST_Right]
		'SQL'
		,@UserName				
		,@FactoryID				
		,@ProductLineID						
		,@Right					
		,@ReadCommentMandatory 
		,@WriteCommentMandatory

Print @RC
FETCH MyCursor INTO @UserName, @FactoryID, @ProductLineID, @ProductID, @Right, @ReadCommentMandatory, @WriteCommentMandatory
END
CLOSE MyCursor
DEALLOCATE MyCursor

GO
