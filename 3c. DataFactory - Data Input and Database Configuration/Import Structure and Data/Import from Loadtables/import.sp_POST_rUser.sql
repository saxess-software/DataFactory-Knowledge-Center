/*
Stefan Lindenlaub
2018/01
Import User from load.trUser
	EXEC [import].[sp_POST_rUser] ''
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[import].[sp_POST_rUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [import].[sp_POST_rUser]
GO

CREATE PROCEDURE [import].[sp_POST_rUser]
			     (  @UserName AS NVARCHAR(255))

AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
DECLARE @TimestampCall		AS DATETIME = CURRENT_TIMESTAMP
DECLARE @ProcedureName		AS NVARCHAR (255) = OBJECT_NAME(@@PROCID)
DECLARE @RC					AS INT
DECLARE @EffectedRows		AS INT = 0

DECLARE @PersonSurname		AS NVARCHAR(255)
DECLARE @PersonFirstName	AS NVARCHAR(255)
DECLARE @EMail				AS NVARCHAR(255)
DECLARE @LDAPIP				AS NVARCHAR(255)
DECLARE @Status				AS NVARCHAR(255)

-------------------------------------------------------------------------------------------------------------------
-- ##### TEMPORARY TABLES ###########
IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
CREATE TABLE #tmp 
		(	 UserName		 NVARCHAR(255)
			,PersonSurname	 NVARCHAR(255)
			,PersonFirstName NVARCHAR(255)
			,EMail			 NVARCHAR(255)
			,LDAPIP			 NVARCHAR(255)
			,Status			 NVARCHAR(255))

INSERT INTO #tmp
	SELECT   trU.UserName
			,trU.PersonSurname
			,trU.PersonFirstName
			,trU.EMail		
			,trU.LDAPIP		
			,trU.Status		
	FROM	load.trUser trU
	WHERE	(@UserName = '' OR trU.UserName = @UserName)

-------------------------------------------------------------------------------------------------------------------
-- ##### POST ###########
DECLARE MyCursor CURSOR FOR
	SELECT * FROM #tmp t
OPEN MyCursor
FETCH MyCursor INTO @UserName,@PersonSurname,@PersonFirstName,@EMail,@LDAPIP,@Status
WHILE @@FETCH_STATUS = 0
BEGIN
	EXECUTE @RC = [dbo].[sx_pf_POST_User]
			'SQL'				
			,@UserName
			,@PersonSurname	
			,@PersonFirstName
			,@EMail			
			,@LDAPIP			
			,@Status			

	Print @RC
FETCH MyCursor INTO @UserName,@PersonSurname,@PersonFirstName,@EMail,@LDAPIP,@Status
END
CLOSE MyCursor
DEALLOCATE MyCursor

-------------------------------------------------------------------------------------------------------------------
GO
GRANT EXECUTE ON OBJECT ::[import].[sp_POST_rUser] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[import].[sp_POST_rUser] TO pf_PlanningFactoryService;
GO
