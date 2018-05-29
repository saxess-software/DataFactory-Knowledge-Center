## Collation problem between local copy of Azure database and tempDB

- Collation on Azure might differ from collation of local server
- When using a local copy of an Azure database, procedures and scripts might result in an error due to different collations of the database in use (the copy of the azure database) and the tempDB 

## To avoid the problem

- When using temporary tables (or other objects stored in the tempDB) add the collation to all columns with type nvarchar()

Example:

CREATE TABLE #ProductToDoList
		(
		 FactoryKey		BIGINT
		,ProductlineKey BIGINT
		,ProductKey		BIGINT
		,FactoryID		NVARCHAR(255) COLLATE database_default	NOT NULL
		,ProductLineID	NVARCHAR(255) COLLATE database_default	NOT NULL
		,ProductID		NVARCHAR(255) COLLATE database_default	NOT NULL
		)


