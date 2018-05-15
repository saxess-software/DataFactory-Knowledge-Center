/*
Trigger um Parametertabellen aus Factory ZT und ProductLine PARAM zu kreieren und zu befüllen
Werden ausgelöst, sobald in sx_pf_fValues oder dProducts Update, Insert oder Delete Operationen erfolgen
Mandy Hauck 04.2018
*/

-------------------------------------------------------------------------------------------------------------------
-- ##### Trigger auf Tabelle fValues ###########
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[trParamTable_from_fValues]'))
DROP TRIGGER [trParamTable_from_fValues]
GO

CREATE TRIGGER [trParamTable_from_fValues]
ON dbo.sx_pf_fValues
AFTER INSERT, UPDATE, DELETE 
AS 

BEGIN
	DECLARE @FactoryID				NVARCHAR(255) = ''
	DECLARE @ProductlineID			NVARCHAR(255) = ''
	BEGIN
		SELECT  @FactoryID = FactoryID, 
				@ProductLineID = ProductlineID
		FROM Inserted
	
		IF @FactoryID = 'ZT' AND @ProductLineID ='PARAM'
		BEGIN
			EXEC [control].[spParamTables]
		END
	END
	BEGIN
		SELECT  @FactoryID = FactoryID, 
				@ProductLineID = ProductlineID
		FROM Deleted
	
		IF @FactoryID = 'ZT' AND @ProductLineID ='PARAM'
		BEGIN
			EXEC [control].[spParamTables]
		END
	END

END
GO

-------------------------------------------------------------------------------------------------------------------
-- ##### Trigger auf Tabelle dProducts ###########
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[trParamTable_from_dProducts]'))
DROP TRIGGER [trParamTable_from_dProducts]
GO

CREATE TRIGGER [trParamTable_from_dProducts]
ON dbo.sx_pf_dProducts
AFTER INSERT, UPDATE, DELETE 
AS 

BEGIN
	DECLARE @FactoryID				NVARCHAR(255) = ''
	DECLARE @ProductlineID			NVARCHAR(255) = ''
	BEGIN
		SELECT  @FactoryID = FactoryID, 
				@ProductLineID = ProductlineID
		FROM Inserted
	
		IF @factoryID = 'ZT' AND @ProductLineID ='PARAM'
		BEGIN
			EXEC [control].[spParamTables]
		END
	END
	BEGIN
		SELECT  @FactoryID = FactoryID, 
				@ProductLineID = ProductlineID
		FROM Deleted
	
		IF @factoryID = 'ZT' AND @ProductLineID ='PARAM'
		BEGIN
			EXEC [control].[spParamTables]
		END
	END
END
GO


-------------------------------------------------------------------------------------------------------------------
-- ##### Trigger auf Tabelle dValueSeries ###########
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[trParamTable_from_dValueSeries]'))
DROP TRIGGER [trParamTable_from_dValueSeries]
GO

CREATE TRIGGER [trParamTable_from_dValueSeries]
ON dbo.sx_pf_dValueSeries
AFTER INSERT, UPDATE, DELETE 
AS 

BEGIN
	DECLARE @FactoryID				NVARCHAR(255) = ''
	DECLARE @ProductlineID			NVARCHAR(255) = ''
	BEGIN
		SELECT  @FactoryID = FactoryID, 
				@ProductLineID = ProductlineID
		FROM Inserted
	
		IF @factoryID = 'ZT' AND @ProductLineID ='PARAM'
		BEGIN
			EXEC [control].[spParamTables]
		END
	END
	BEGIN
		SELECT  @FactoryID = FactoryID, 
				@ProductLineID = ProductlineID
		FROM Deleted
	
		IF @factoryID = 'ZT' AND @ProductLineID ='PARAM'
		BEGIN
			EXEC [control].[spParamTables]
		END
	END
END
GO


