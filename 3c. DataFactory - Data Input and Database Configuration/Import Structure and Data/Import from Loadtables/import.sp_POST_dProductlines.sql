/*
Mandy Hauck, Stefan Lindenlaub
2018/06
Import all values from load.tdProductlines with specific load-procedure as source
Testcall
	EXEC [import].[spPOST_dProductlines] 'SQL','','',''
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[import].[spPOST_dProductlines]') AND type in (N'P', N'PC'))
DROP PROCEDURE [import].[spPOST_dProductlines]
GO

CREATE PROCEDURE [import].[spPOST_dProductlines]
				(		@Username		AS NVARCHAR(255),
						@FactoryID		AS NVARCHAR(255),
						@ProductLineID	AS NVARCHAR(255),
						@Source			AS NVARCHAR(255)		  )
AS

BEGIN
	SET NOCOUNT ON

	-------------------------------------------------------------------------------------------------------------------
	-- ##### VARIABLES ###########
	DECLARE @TimestampCall					DATETIME		= CURRENT_TIMESTAMP;
	DECLARE @ProcedureName					NVARCHAR(255)	= OBJECT_SCHEMA_NAME(@@PROCID) + N'.' + OBJECT_NAME(@@PROCID);
	DECLARE @ResultCode						INT				= 501;
	DECLARE @EffectedRows					INT				= 0;					
	DECLARE @TransactUsername				NVARCHAR(255)	= N'';
	DECLARE @ParameterString				NVARCHAR(MAX)	= N''''
															+ ISNULL(@Username		, N'NULL')	 + N''',''' 
															+ ISNULL(@FactoryID		, N'NULL')	 + N''','''
															+ ISNULL(@ProductLineID	, N'NULL')	 + N''','''
															+ ISNULL(@Source		, N'NULL')	 + N'''';
	DECLARE @Comment						NVARCHAR(2000)	= N'';						
	DECLARE @NameShort						NVARCHAR(255)
	DECLARE @NameLong						NVARCHAR(255)
	DECLARE @CommentUser					NVARCHAR(MAX)
	DECLARE @CommentDev						NVARCHAR(255)
	DECLARE @ResponsiblePerson				NVARCHAR(255)
	DECLARE @ImageName						NVARCHAR(255)
	DECLARE @DefaultTemplate				NVARCHAR(255)
	DECLARE @GlobalAttributeSource1			NVARCHAR(255)
	DECLARE @GlobalAttributeAlias1 			NVARCHAR(255)
	DECLARE @GlobalAttributeSource2			NVARCHAR(255)
	DECLARE @GlobalAttributeAlias2 			NVARCHAR(255)
	DECLARE @GlobalAttributeSource3			NVARCHAR(255)
	DECLARE @GlobalAttributeAlias3 			NVARCHAR(255)
	DECLARE @GlobalAttributeSource4			NVARCHAR(255)
	DECLARE @GlobalAttributeAlias4 			NVARCHAR(255)
	DECLARE @GlobalAttributeSource5			NVARCHAR(255)
	DECLARE @GlobalAttributeAlias5 			NVARCHAR(255)
	DECLARE @GlobalAttributeSource6			NVARCHAR(255)
	DECLARE @GlobalAttributeAlias6 			NVARCHAR(255)
	DECLARE @GlobalAttributeSource7			NVARCHAR(255)
	DECLARE @GlobalAttributeAlias7 			NVARCHAR(255)
	DECLARE @GlobalAttributeSource8			NVARCHAR(255)
	DECLARE @GlobalAttributeAlias8 			NVARCHAR(255)
	DECLARE @GlobalAttributeSource9			NVARCHAR(255)
	DECLARE @GlobalAttributeAlias9 			NVARCHAR(255)
	DECLARE @GlobalAttributeSource10		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias10			NVARCHAR(255)
	DECLARE @GlobalAttributeSource11		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias11			NVARCHAR(255)
	DECLARE @GlobalAttributeSource12		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias12			NVARCHAR(255)
	DECLARE @GlobalAttributeSource13		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias13			NVARCHAR(255)
	DECLARE @GlobalAttributeSource14		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias14			NVARCHAR(255)
	DECLARE @GlobalAttributeSource15		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias15			NVARCHAR(255)
	DECLARE @GlobalAttributeSource16		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias16			NVARCHAR(255)
	DECLARE @GlobalAttributeSource17		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias17			NVARCHAR(255)
	DECLARE @GlobalAttributeSource18		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias18			NVARCHAR(255)
	DECLARE @GlobalAttributeSource19		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias19			NVARCHAR(255)
	DECLARE @GlobalAttributeSource20		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias20			NVARCHAR(255)
	DECLARE @GlobalAttributeSource21		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias21			NVARCHAR(255)
	DECLARE @GlobalAttributeSource22		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias22			NVARCHAR(255)
	DECLARE @GlobalAttributeSource23		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias23			NVARCHAR(255)
	DECLARE @GlobalAttributeSource24		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias24			NVARCHAR(255)
	DECLARE @GlobalAttributeSource25		NVARCHAR(255)
	DECLARE @GlobalAttributeAlias25			NVARCHAR(255)

	-------------------------------------------------------------------------------------------------------------------
	-- ##### DETERMINE TRANSACTION USER ###########
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);

	-------------------------------------------------------------------------------------------------------------------
	-- ##### TEMPORARY TABLES ###########
	IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
	CREATE TABLE #tmp 
				(	ProductLineID			NVARCHAR(255)
				   ,FactoryID				NVARCHAR(255)
				   ,NameShort				NVARCHAR(255)
				   ,NameLong				NVARCHAR(255)
				   ,CommentUser				NVARCHAR(255)
				   ,CommentDev				NVARCHAR(255)
				   ,ResponsiblePerson		NVARCHAR(255)
				   ,ImageName				NVARCHAR(255)
				   ,DefaultTemplate			NVARCHAR(255)
				   ,GlobalAttributeSource1  NVARCHAR(255)
				   ,GlobalAttributeAlias1 	NVARCHAR(255)
				   ,GlobalAttributeSource2	NVARCHAR(255)
				   ,GlobalAttributeAlias2 	NVARCHAR(255)
				   ,GlobalAttributeSource3	NVARCHAR(255)
				   ,GlobalAttributeAlias3 	NVARCHAR(255)
				   ,GlobalAttributeSource4	NVARCHAR(255)
				   ,GlobalAttributeAlias4 	NVARCHAR(255)
				   ,GlobalAttributeSource5	NVARCHAR(255)
				   ,GlobalAttributeAlias5 	NVARCHAR(255)
				   ,GlobalAttributeSource6	NVARCHAR(255)
				   ,GlobalAttributeAlias6 	NVARCHAR(255)
				   ,GlobalAttributeSource7	NVARCHAR(255)
				   ,GlobalAttributeAlias7 	NVARCHAR(255)
				   ,GlobalAttributeSource8	NVARCHAR(255)
				   ,GlobalAttributeAlias8 	NVARCHAR(255)
				   ,GlobalAttributeSource9	NVARCHAR(255)
				   ,GlobalAttributeAlias9 	NVARCHAR(255)
				   ,GlobalAttributeSource10 NVARCHAR(255)
				   ,GlobalAttributeAlias10  NVARCHAR(255)
				   ,GlobalAttributeSource11 NVARCHAR(255)
				   ,GlobalAttributeAlias11  NVARCHAR(255)
				   ,GlobalAttributeSource12 NVARCHAR(255)
				   ,GlobalAttributeAlias12  NVARCHAR(255)
				   ,GlobalAttributeSource13 NVARCHAR(255)
				   ,GlobalAttributeAlias13  NVARCHAR(255)
				   ,GlobalAttributeSource14 NVARCHAR(255)
				   ,GlobalAttributeAlias14  NVARCHAR(255)
				   ,GlobalAttributeSource15 NVARCHAR(255)
				   ,GlobalAttributeAlias15  NVARCHAR(255)
				   ,GlobalAttributeSource16 NVARCHAR(255)
				   ,GlobalAttributeAlias16  NVARCHAR(255)
				   ,GlobalAttributeSource17 NVARCHAR(255)
				   ,GlobalAttributeAlias17  NVARCHAR(255)
				   ,GlobalAttributeSource18 NVARCHAR(255)
				   ,GlobalAttributeAlias18  NVARCHAR(255)
				   ,GlobalAttributeSource19 NVARCHAR(255)
				   ,GlobalAttributeAlias19  NVARCHAR(255)
				   ,GlobalAttributeSource20 NVARCHAR(255)
				   ,GlobalAttributeAlias20  NVARCHAR(255)
				   ,GlobalAttributeSource21 NVARCHAR(255)
				   ,GlobalAttributeAlias21  NVARCHAR(255)
				   ,GlobalAttributeSource22 NVARCHAR(255)
				   ,GlobalAttributeAlias22  NVARCHAR(255)
				   ,GlobalAttributeSource23 NVARCHAR(255)
				   ,GlobalAttributeAlias23  NVARCHAR(255)
				   ,GlobalAttributeSource24 NVARCHAR(255)
				   ,GlobalAttributeAlias24  NVARCHAR(255)
				   ,GlobalAttributeSource25 NVARCHAR(255)
				   ,GlobalAttributeAlias25  NVARCHAR(255)		)

	INSERT INTO #tmp
		SELECT   tdPL.ProductLineID			
				,tdPL.FactoryID				
				,tdPL.NameShort				
				,tdPL.NameLong				
				,tdPL.CommentUser			
				,tdPL.CommentDev			
				,tdPL.ResponsiblePerson		
				,tdPL.ImageName				
				,tdPL.DefaultTemplate		
				,tdPL.GlobalAttributeSource1
				,tdPL.GlobalAttributeAlias1 
				,tdPL.GlobalAttributeSource2
				,tdPL.GlobalAttributeAlias2 
				,tdPL.GlobalAttributeSource3
				,tdPL.GlobalAttributeAlias3 
				,tdPL.GlobalAttributeSource4
				,tdPL.GlobalAttributeAlias4 
				,tdPL.GlobalAttributeSource5
				,tdPL.GlobalAttributeAlias5 
				,tdPL.GlobalAttributeSource6
				,tdPL.GlobalAttributeAlias6 
				,tdPL.GlobalAttributeSource7
				,tdPL.GlobalAttributeAlias7 
				,tdPL.GlobalAttributeSource8
				,tdPL.GlobalAttributeAlias8 
				,tdPL.GlobalAttributeSource9
				,tdPL.GlobalAttributeAlias9 
				,tdPL.GlobalAttributeSource10
				,tdPL.GlobalAttributeAlias10 
				,tdPL.GlobalAttributeSource11
				,tdPL.GlobalAttributeAlias11 
				,tdPL.GlobalAttributeSource12
				,tdPL.GlobalAttributeAlias12 
				,tdPL.GlobalAttributeSource13
				,tdPL.GlobalAttributeAlias13 
				,tdPL.GlobalAttributeSource14
				,tdPL.GlobalAttributeAlias14 
				,tdPL.GlobalAttributeSource15
				,tdPL.GlobalAttributeAlias15 
				,tdPL.GlobalAttributeSource16
				,tdPL.GlobalAttributeAlias16 
				,tdPL.GlobalAttributeSource17
				,tdPL.GlobalAttributeAlias17 
				,tdPL.GlobalAttributeSource18
				,tdPL.GlobalAttributeAlias18 
				,tdPL.GlobalAttributeSource19
				,tdPL.GlobalAttributeAlias19 
				,tdPL.GlobalAttributeSource20
				,tdPL.GlobalAttributeAlias20 
				,tdPL.GlobalAttributeSource21
				,tdPL.GlobalAttributeAlias21 
				,tdPL.GlobalAttributeSource22
				,tdPL.GlobalAttributeAlias22 
				,tdPL.GlobalAttributeSource23
				,tdPL.GlobalAttributeAlias23 
				,tdPL.GlobalAttributeSource24
				,tdPL.GlobalAttributeAlias24 
				,tdPL.GlobalAttributeSource25
				,tdPL.GlobalAttributeAlias25  
		FROM	load.tdProductLines tdPL
		WHERE	(@FactoryID = '' OR tdPL.FactoryID = @FactoryID)
		 AND    (@ProductLineID = '' OR tdPL.ProductLineID = @ProductLineID)
		 AND    (@Source = '' OR tdPL.Source = @Source)
	
	-------------------------------------------------------------------------------------------------------------------
	-- ##### POST ###########
	DECLARE MyCursor CURSOR FOR
		SELECT *
		FROM #tmp t
	OPEN MyCursor
	FETCH MyCursor INTO @ProductLineID,@FactoryID,@NameShort,@NameLong,@CommentUser,@CommentDev,@ResponsiblePerson,@ImageName,@DefaultTemplate,@GlobalAttributeSource1  ,@GlobalAttributeAlias1 ,@GlobalAttributeSource2,@GlobalAttributeAlias2 ,@GlobalAttributeSource3,@GlobalAttributeAlias3 ,@GlobalAttributeSource4,@GlobalAttributeAlias4 ,@GlobalAttributeSource5,@GlobalAttributeAlias5 ,@GlobalAttributeSource6,@GlobalAttributeAlias6 ,@GlobalAttributeSource7,@GlobalAttributeAlias7 ,@GlobalAttributeSource8,@GlobalAttributeAlias8 ,@GlobalAttributeSource9,@GlobalAttributeAlias9 ,@GlobalAttributeSource10 ,@GlobalAttributeAlias10  ,@GlobalAttributeSource11 ,@GlobalAttributeAlias11  ,@GlobalAttributeSource12 ,@GlobalAttributeAlias12  ,@GlobalAttributeSource13 ,@GlobalAttributeAlias13  ,@GlobalAttributeSource14 ,@GlobalAttributeAlias14  ,@GlobalAttributeSource15 ,@GlobalAttributeAlias15  ,@GlobalAttributeSource16 ,@GlobalAttributeAlias16  ,@GlobalAttributeSource17 ,@GlobalAttributeAlias17  ,@GlobalAttributeSource18 ,@GlobalAttributeAlias18  ,@GlobalAttributeSource19 ,@GlobalAttributeAlias19  ,@GlobalAttributeSource20 ,@GlobalAttributeAlias20  ,@GlobalAttributeSource21 ,@GlobalAttributeAlias21  ,@GlobalAttributeSource22 ,@GlobalAttributeAlias22  ,@GlobalAttributeSource23 ,@GlobalAttributeAlias23  ,@GlobalAttributeSource24 ,@GlobalAttributeAlias24  ,@GlobalAttributeSource25 ,@GlobalAttributeAlias25  
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXECUTE @ResultCode = [dbo].[sx_pf_POST_ProductLine]
				 @Username
				,@ProductLineID				
				,@FactoryID			
				,@NameShort
				,@NameLong
				,@CommentUser
				,@CommentDev
				,@ResponsiblePerson
				,@ImageName
				,@DefaultTemplate
				,@GlobalAttributeSource1  
				,@GlobalAttributeAlias1 
				,@GlobalAttributeSource2
				,@GlobalAttributeAlias2 
				,@GlobalAttributeSource3
				,@GlobalAttributeAlias3 
				,@GlobalAttributeSource4
				,@GlobalAttributeAlias4 
				,@GlobalAttributeSource5
				,@GlobalAttributeAlias5 
				,@GlobalAttributeSource6
				,@GlobalAttributeAlias6 
				,@GlobalAttributeSource7
				,@GlobalAttributeAlias7 
				,@GlobalAttributeSource8
				,@GlobalAttributeAlias8 
				,@GlobalAttributeSource9
				,@GlobalAttributeAlias9 
				,@GlobalAttributeSource10 
				,@GlobalAttributeAlias10  
				,@GlobalAttributeSource11 
				,@GlobalAttributeAlias11  
				,@GlobalAttributeSource12 
				,@GlobalAttributeAlias12  
				,@GlobalAttributeSource13 
				,@GlobalAttributeAlias13  
				,@GlobalAttributeSource14 
				,@GlobalAttributeAlias14  
				,@GlobalAttributeSource15 
				,@GlobalAttributeAlias15  
				,@GlobalAttributeSource16 
				,@GlobalAttributeAlias16  
				,@GlobalAttributeSource17 
				,@GlobalAttributeAlias17  
				,@GlobalAttributeSource18 
				,@GlobalAttributeAlias18  
				,@GlobalAttributeSource19 
				,@GlobalAttributeAlias19  
				,@GlobalAttributeSource20 
				,@GlobalAttributeAlias20  
				,@GlobalAttributeSource21 
				,@GlobalAttributeAlias21  
				,@GlobalAttributeSource22 
				,@GlobalAttributeAlias22  
				,@GlobalAttributeSource23 
				,@GlobalAttributeAlias23  
				,@GlobalAttributeSource24 
				,@GlobalAttributeAlias24  
				,@GlobalAttributeSource25 
				,@GlobalAttributeAlias25 

		PRINT @ResultCode
	FETCH MyCursor INTO  @ProductLineID,@FactoryID,@NameShort,@NameLong,@CommentUser,@CommentDev,@ResponsiblePerson,@ImageName,@DefaultTemplate,@GlobalAttributeSource1  ,@GlobalAttributeAlias1 ,@GlobalAttributeSource2,@GlobalAttributeAlias2 ,@GlobalAttributeSource3,@GlobalAttributeAlias3 ,@GlobalAttributeSource4,@GlobalAttributeAlias4 ,@GlobalAttributeSource5,@GlobalAttributeAlias5 ,@GlobalAttributeSource6,@GlobalAttributeAlias6 ,@GlobalAttributeSource7,@GlobalAttributeAlias7 ,@GlobalAttributeSource8,@GlobalAttributeAlias8 ,@GlobalAttributeSource9,@GlobalAttributeAlias9 ,@GlobalAttributeSource10 ,@GlobalAttributeAlias10  ,@GlobalAttributeSource11 ,@GlobalAttributeAlias11  ,@GlobalAttributeSource12 ,@GlobalAttributeAlias12  ,@GlobalAttributeSource13 ,@GlobalAttributeAlias13  ,@GlobalAttributeSource14 ,@GlobalAttributeAlias14  ,@GlobalAttributeSource15 ,@GlobalAttributeAlias15  ,@GlobalAttributeSource16 ,@GlobalAttributeAlias16  ,@GlobalAttributeSource17 ,@GlobalAttributeAlias17  ,@GlobalAttributeSource18 ,@GlobalAttributeAlias18  ,@GlobalAttributeSource19 ,@GlobalAttributeAlias19  ,@GlobalAttributeSource20 ,@GlobalAttributeAlias20  ,@GlobalAttributeSource21 ,@GlobalAttributeAlias21  ,@GlobalAttributeSource22 ,@GlobalAttributeAlias22  ,@GlobalAttributeSource23 ,@GlobalAttributeAlias23  ,@GlobalAttributeSource24 ,@GlobalAttributeAlias24  ,@GlobalAttributeSource25 ,@GlobalAttributeAlias25  
	END
	CLOSE MyCursor
	DEALLOCATE MyCursor

	SET @ResultCode = 200;

	EXEC dbo.sx_pf_pPOST_API_LogEntry @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;

	RETURN @ResultCode;

END;

-------------------------------------------------------------------------------------------------------------------
GO
GRANT EXECUTE ON OBJECT ::[import].[spPOST_dProductlines] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[import].[spPOST_dProductlines] TO pf_PlanningFactoryService;
GO
