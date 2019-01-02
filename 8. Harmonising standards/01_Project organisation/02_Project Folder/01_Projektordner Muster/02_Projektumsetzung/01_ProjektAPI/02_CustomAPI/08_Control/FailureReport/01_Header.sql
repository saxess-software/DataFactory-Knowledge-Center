
/*
Author: 	Mandy Hauck
Created: 	2018/11
Summary:	Procedure to fill the Table control.tCustomFailureReport
			Procedure will be build from many subsnipptes

	EXEC [control].[spCustomFailureReport] '','',''
	SELECT * FROM [control].[tCustomFailureReport]

*/

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[spCustomFailureReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [control].[spCustomFailureReport]
GO

CREATE PROCEDURE  [control].[spCustomFailureReport] (	@FactoryID		NVARCHAR(255) = '', 
														@ProductlineID	NVARCHAR(255) = '',
														@ProductID		NVARCHAR(255) = ''		)
AS

-------------------------------------------------------------------------------------------------------------------
-- ## VARIABLES ####
DECLARE @Timestamp 	Datetime 	= GETDATE()
DECLARE @TestName	NVARCHAR (255) 	= ''
DECLARE @TestSource	NVARCHAR (255) 	= ''

-------------------------------------------------------------------------------------------------------------------
-- ## DELETE ####
	-- self cleaning older than 14 Days
	BEGIN													    
		DELETE FROM [control].[tCustomFailureReport] WHERE Timestamp < DATEADD(day,-14,GETDATE());
	END
										       
-------------------------------------------------------------------------------------------------------------------
-- ## SNIPPETS ####

