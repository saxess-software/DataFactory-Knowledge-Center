
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
		(		 ColumnInt					INT
				,ColumnText1				NVARCHAR(255)
				,ColumnText2				NVARCHAR(MAX)
				,ColumnDate					DATETIME
				,ColumnMoney				MONEY						)

-------------------------------------------------------------------------------------------------------------------
GO


