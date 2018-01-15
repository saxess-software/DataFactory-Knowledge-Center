
/*

Import Data from load.tfValues using PostProductDataTableValues

Import Products from load.tdProducts

*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[import].[sp_POST_dProducts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [import].[sp_POST_dProducts]
GO

CREATE PROCEDURE [import].[sp_POST_dProducts]
		@ProductID		AS NVARCHAR(255),
		@ProductLineID	AS NVARCHAR(255),
		@FactoryID		AS NVARCHAR(255)
				   
				   

AS

SET NOCOUNT ON

DECLARE @TimestampCall AS DATETIME = CURRENT_TIMESTAMP
DECLARE @ProcedureName AS NVARCHAR (255) = OBJECT_NAME(@@PROCID)
DECLARE @RC INT

DECLARE @TimeType				 AS NVARCHAR (255)
DECLARE @NameShort				 AS NVARCHAR (255)
DECLARE @NameLong				 AS NVARCHAR (255)
DECLARE @CommentUser			 AS NVARCHAR (255)
DECLARE @CommentDev				 AS NVARCHAR (255)
DECLARE @ResponsiblePerson		 AS NVARCHAR (255)
DECLARE @ImageName				 AS NVARCHAR (255)
DECLARE @Status					 AS NVARCHAR (255)
DECLARE @Template				 AS NVARCHAR (255)
DECLARE @TemplateVersion		 AS NVARCHAR (255)
DECLARE @GA1 					 AS NVARCHAR (255)
DECLARE @GA2 					 AS NVARCHAR (255)
DECLARE @GA3 					 AS NVARCHAR (255)
DECLARE @GA4 					 AS NVARCHAR (255)
DECLARE @GA5 					 AS NVARCHAR (255)
DECLARE @GA6 					 AS NVARCHAR (255)
DECLARE @GA7 					 AS NVARCHAR (255)
DECLARE @GA8 					 AS NVARCHAR (255)
DECLARE @GA9 					 AS NVARCHAR (255)
DECLARE @GA10					 AS NVARCHAR (255)
DECLARE @GA11					 AS NVARCHAR (255)
DECLARE @GA12					 AS NVARCHAR (255)
DECLARE @GA13					 AS NVARCHAR (255)
DECLARE @GA14					 AS NVARCHAR (255)
DECLARE @GA15					 AS NVARCHAR (255)
DECLARE @GA16					 AS NVARCHAR (255)
DECLARE @GA17					 AS NVARCHAR (255)
DECLARE @GA18					 AS NVARCHAR (255)
DECLARE @GA19					 AS NVARCHAR (255)
DECLARE @GA20					 AS NVARCHAR (255)
DECLARE @GA21					 AS NVARCHAR (255)
DECLARE @GA22					 AS NVARCHAR (255)
DECLARE @GA23					 AS NVARCHAR (255)
DECLARE @GA24					 AS NVARCHAR (255)
DECLARE @GA25					 AS NVARCHAR (255)

-- Temptable for Cursor

IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
	CREATE TABLE #tmp (		
			ProductID				NVARCHAR (255)
		   ,ProductLineID			NVARCHAR (255)
		   ,FactoryID				NVARCHAR (255)
		   ,TimeType				NVARCHAR (255)
		   ,NameShort				NVARCHAR (255)
		   ,NameLong				NVARCHAR (255)
		   ,CommentUser				NVARCHAR (255)
		   ,CommentDev				NVARCHAR (255)
		   ,ResponsiblePerson		NVARCHAR (255)
		   ,ImageName				NVARCHAR (255)
		   ,Status					NVARCHAR (255)
		   ,Template				NVARCHAR (255)
		   ,TemplateVersion			NVARCHAR (255)
		   ,GA1 					NVARCHAR (255)
		   ,GA2 					NVARCHAR (255)
		   ,GA3 					NVARCHAR (255)
		   ,GA4 					NVARCHAR (255)
		   ,GA5 					NVARCHAR (255)
		   ,GA6 					NVARCHAR (255)
		   ,GA7 					NVARCHAR (255)
		   ,GA8 					NVARCHAR (255)
		   ,GA9 					NVARCHAR (255)
		   ,GA10					NVARCHAR (255)
		   ,GA11					NVARCHAR (255)
		   ,GA12					NVARCHAR (255)
		   ,GA13					NVARCHAR (255)
		   ,GA14					NVARCHAR (255)
		   ,GA15					NVARCHAR (255)
		   ,GA16					NVARCHAR (255)
		   ,GA17					NVARCHAR (255)
		   ,GA18					NVARCHAR (255)
		   ,GA19					NVARCHAR (255)
		   ,GA20					NVARCHAR (255)
		   ,GA21					NVARCHAR (255)
		   ,GA22					NVARCHAR (255)
		   ,GA23					NVARCHAR (255)
		   ,GA24					NVARCHAR (255)
		   ,GA25					NVARCHAR (255)
		  )

INSERT INTO #tmp
	SELECT   tdP.ProductID
			,tdP.ProductLineID			
			,tdP.FactoryID
			,tdP.TimeType				
			,tdP.NameShort				
			,tdP.NameLong				
			,tdP.CommentUser			
			,tdP.CommentDev			
			,tdP.ResponsiblePerson		
			,tdP.ImageName
			,tdP.Status				
			,tdP.Template
			,tdP.TemplateVersion		
			,tdP.GlobalAttribute1 
			,tdP.GlobalAttribute2 
			,tdP.GlobalAttribute3 
			,tdP.GlobalAttribute4 
			,tdP.GlobalAttribute5 
			,tdP.GlobalAttribute6 
			,tdP.GlobalAttribute7 
			,tdP.GlobalAttribute8 
			,tdP.GlobalAttribute9 
			,tdP.GlobalAttribute10
			,tdP.GlobalAttribute11
			,tdP.GlobalAttribute12
			,tdP.GlobalAttribute13
			,tdP.GlobalAttribute14
			,tdP.GlobalAttribute15
			,tdP.GlobalAttribute16
			,tdP.GlobalAttribute17
			,tdP.GlobalAttribute18
			,tdP.GlobalAttribute19
			,tdP.GlobalAttribute20
			,tdP.GlobalAttribute21
			,tdP.GlobalAttribute22
			,tdP.GlobalAttribute23
			,tdP.GlobalAttribute24
			,tdP.GlobalAttribute25
	FROM	load.tdProducts tdP
	WHERE	(@FactoryID = '' OR tdP.FactoryID = @FactoryID)
	 AND    (@ProductLineID = '' OR tdP.ProductLineID = @ProductLineID)
	 AND    (@ProductID = '' OR tdP.ProductID = @ProductID)
	
DECLARE MyCursor CURSOR FOR
	SELECT *
	FROM #tmp t
OPEN MyCursor
FETCH MyCursor INTO @ProductID,@ProductLineID,@FactoryID,@TimeType,@NameShort,@NameLong,@CommentUser,@CommentDev,@ResponsiblePerson,@ImageName,@Status,@Template,@TemplateVersion,@GA1 ,@GA2 ,@GA3 ,@GA4 ,@GA5 ,@GA6 ,@GA7 ,@GA8 ,@GA9 ,@GA10,@GA11,@GA12,@GA13,@GA14,@GA15,@GA16,@GA17,@GA18,@GA19,@GA20,@GA21,@GA22,@GA23,@GA24,@GA25

WHILE @@FETCH_STATUS = 0
BEGIN
EXECUTE @RC = [dbo].[sx_pf_POST_Product]
		'SQL'
		,@ProductID
		,@ProductLineID				
		,@FactoryID			
		,@TimeType			
		,@NameShort			
		,@NameLong			
		,@CommentUser		
		,@CommentDev			
		,@ResponsiblePerson	
		,@ImageName			
		,@Status				
		,@Template			
		,@TemplateVersion	
		,@GA1 				
		,@GA2 				
		,@GA3 				
		,@GA4 				
		,@GA5 				
		,@GA6 				
		,@GA7 				
		,@GA8 				
		,@GA9 				
		,@GA10				
		,@GA11				
		,@GA12				
		,@GA13				
		,@GA14				
		,@GA15				
		,@GA16				
		,@GA17				
		,@GA18				
		,@GA19				
		,@GA20				
		,@GA21				
		,@GA22				
		,@GA23				
		,@GA24				
		,@GA25	
					
Print @RC
FETCH MyCursor INTO  @ProductID,@ProductLineID,@FactoryID,@TimeType,@NameShort,@NameLong,@CommentUser,@CommentDev,@ResponsiblePerson,@ImageName,@Status,@Template,@TemplateVersion,@GA1 ,@GA2 ,@GA3 ,@GA4 ,@GA5 ,@GA6 ,@GA7 ,@GA8 ,@GA9 ,@GA10,@GA11,@GA12,@GA13,@GA14,@GA15,@GA16,@GA17,@GA18,@GA19,@GA20,@GA21,@GA22,@GA23,@GA24,@GA25
END
CLOSE MyCursor
DEALLOCATE MyCursor

GO
