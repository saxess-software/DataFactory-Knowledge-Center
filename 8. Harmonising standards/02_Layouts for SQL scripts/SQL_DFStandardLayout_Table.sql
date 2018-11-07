
/*
Author: 	Heathcliff Power
Created: 	2018/01
Summary:	This template provides the layout used for creating tables

	SELECT * FROM [dbo].[TableName]
*/

IF OBJECT_ID('[dbo].[TableName]', 'U') IS NOT NULL 
DROP TABLE [dbo].[TableName]
GO

-------------------------------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[TableName]
		(		 ColumnInt					INT				NOT NULL
				,ColumnText1				NVARCHAR(255)	NOT NULL
				,ColumnText2				NVARCHAR(MAX)	NOT NULL
				,ColumnDate					DATETIME		NOT NULL
				,ColumnMoney				MONEY			NOT NULL	)

-------------------------------------------------------------------------------------------------------------------
GO

GRANT SELECT ON OBJECT:: [dbo].[TableName] TO pf_PlanningFactoryUser;
GRANT SELECT ON OBJECT:: [dbo].[TableName] TO pf_PlanningFactoryService;

GO
