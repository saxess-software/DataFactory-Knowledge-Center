
-- Script for creating PanningFactoryAdmin Users
-- Gerd Tautenhahn, Saxess Software GmbH 2016/04

IF OBJECT_ID('MakeMeAdmin') IS NOT NULL
DROP PROCEDURE MakeMeAdmin
GO

CREATE PROCEDURE MakeMeAdmin AS

DECLARE @Username NVARCHAR(255)
DECLARE @UserNachname NVARCHAR(255)
DECLARE @UserVorname NVARCHAR(255)
DECLARE @UserMail NVARCHAR(255)


--######## CONFIGURATION ##################################

--1a. Define User and Rights
SET @Username = SYSTEM_USER		-- the User who executes this script
								-- but could be defined by name e.g. 'W8\admin'

--1b. Optional
SET @UserNachname = ''
SET @UserVorname = ''
SET @UserMail = ''

--2. Delete if already exits

DELETE FROM sx_pf_rUser WHERE UserName = @Username
DELETE FROM sx_pf_rRights WHERE UserName = @Username

--######## END CONFIGURATION ##################################



DECLARE @UserKey Integer

INSERT INTO sx_pf_rUser
           (UserName
           ,PersonSurname
           ,PersonFirstName
           ,Email
           ,LDAPIP
           ,[Status])
     VALUES
           (@Username 
           ,@UserNachname
           ,@UserVorname 
           ,@UserMail
           ,''
           ,'Active')

SELECT @UserKey = scope_identity()

INSERT INTO sx_pf_rRights
           (UserKey
           ,UserName
           ,FactoryID
           ,ProductLineID
           ,ProductID
           ,[Right]
		   ,ReadCommentMandatory
		   ,WriteCommentMandatory)
     VALUES
           (@UserKey
           ,@Username
           ,''
           ,''
           ,''
           ,'Write'
		   ,0
		   ,0)
GO
