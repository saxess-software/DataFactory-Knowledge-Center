/*
Stefan Lindenlaub
2018/01
Import Factories from load.tdFactories
	EXEC [import].[sp_POST_dFactories] ''
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[import].[sp_POST_dFactories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [import].[sp_POST_dFactories]
GO

CREATE PROCEDURE [import].[sp_POST_dFactories]
			       @FactoryID AS NVARCHAR(255)

AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
DECLARE @TimestampCall		AS DATETIME = CURRENT_TIMESTAMP
DECLARE @ProcedureName		AS NVARCHAR (255) = OBJECT_NAME(@@PROCID)
DECLARE @RC					AS INT
DECLARE @EffectedRows		AS INT = 0

DECLARE @NameShort			AS NVARCHAR(255)
DECLARE @NameLong			AS NVARCHAR(255)
DECLARE @CommentUser		AS NVARCHAR(MAX)
DECLARE @CommentDev			AS NVARCHAR(255)
DECLARE @ResponsiblePerson	AS NVARCHAR(255)
DECLARE @ImageName			AS NVARCHAR(255)

-------------------------------------------------------------------------------------------------------------------
-- ##### TEMPOARY TABLES ###########
IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
CREATE TABLE #tmp 
			(		 FactoryID			NVARCHAR(255)
					,NameShort			NVARCHAR(255)
					,NameLong			NVARCHAR(255)
					,CommentUser		NVARCHAR(255)
					,CommentDev			NVARCHAR(255)
					,ResponsiblePerson	NVARCHAR(255)
					,ImageName			NVARCHAR(255))
INSERT INTO #tmp
	SELECT tdF.FactoryID,
		   tdF.NameShort,
		   tdF.NameLong,
		   tdF.CommentUser,
		   tdF.CommentDev,
		   tdF.ResponsiblePerson,
		   tdF.ImageName 
	FROM   load.tdFactories tdF
	WHERE  (@FactoryID = '' OR tdF.FactoryID = @FactoryID) 

-------------------------------------------------------------------------------------------------------------------
-- ##### POST ###########
DECLARE MyCursor CURSOR FOR
	SELECT * FROM #tmp t
OPEN MyCursor
FETCH MyCursor INTO @FactoryID,@NameShort,@NameLong,@CommentUser,@CommentDev,@ResponsiblePerson,@ImageName
WHILE @@FETCH_STATUS = 0
BEGIN
	EXECUTE @RC = [dbo].[sx_pf_POST_Factory]
			'SQL'				--@Username
			,@FactoryID			--@FactoryID
			,@NameShort			--@NameShort
			,@NameLong			--@NameLong
			,@CommentUser		--@CommentUser
			,@CommentDev		--@CommentDev
			,@ResponsiblePerson	--@ResponsiblePerson
			,@ImageName			--@ImageName	
	Print @RC
FETCH MyCursor INTO @FactoryID,@NameShort,@NameLong,@CommentUser,@CommentDev,@ResponsiblePerson,@ImageName
END
CLOSE MyCursor
DEALLOCATE MyCursor

-------------------------------------------------------------------------------------------------------------------
GO
GRANT EXECUTE ON OBJECT ::[import].[sp_POST_dFactories] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[import].[sp_POST_dFactories] TO pf_PlanningFactoryService;
GO
