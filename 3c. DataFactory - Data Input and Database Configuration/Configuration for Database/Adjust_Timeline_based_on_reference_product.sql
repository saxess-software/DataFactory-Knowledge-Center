/*
Script to fill the Products in a Target Productline with all the TimeIDs according to a reference Product

*/


DECLARE @SourceFactoryID		NVARCHAR(255) = 'ZT'
DECLARE @SourceProductlineID	NVARCHAR(255) = 'U'
DECLARE @SourceProductID		NVARCHAR(255) = '1'
DECLARE	@TargetFactoryID		NVARCHAR(255) = 'I'
DECLARE @TargetProductLineID	NVARCHAR(255) = '2'
DECLARE @TargetTemplate			NVARCHAR(255) = 'Unikum_VM'		

-- Runtime, keep empty
DECLARE @ProductID NVARCHAR(255) = ''
DECLARE @TimeID BIGINT

-- The TimeIDs in the Source Product
IF OBJECT_ID('tempdb..#TargetTimeIDSet') IS NOT NULL DROP TABLE #TargetTimeIDSet
CREATE TABLE #TargetTimeIDSet
	(
	 TimeID BIGINT NOT NULL
	)

INSERT INTO #TargetTimeIDSet
	SELECT 
		TimeID
	
	FROM dbo.sx_pf_dTime dT 

	WHERE 
			dT.FactoryID		= @SourceFactoryID 
		AND	dT.ProductLineID	= @SourceProductlineID 
		AND	dT.ProductID		= @SourceProductID

-- The List of Target Products
IF OBJECT_ID('tempdb..#TargetProducts') IS NOT NULL DROP TABLE #TargetProducts
CREATE TABLE #TargetProducts
	(
		 ProductKey BIGINT			NOT	NULL
		,ProductID	NVARCHAR (255)	NOT NULL
	)

INSERT INTO #TargetProducts
	SELECT 
		  ProductKey
		 ,dP.ProductID
	FROM 
		dbo.sx_pf_dProducts dP
	WHERE 
			dP.FactoryID		= @TargetFactoryID 
		AND	dP.ProductLineID	= @TargetProductLineID
		AND dP.Template			= @TargetTemplate

-- The List of already existing TimeIDs
IF OBJECT_ID('tempdb..#NotToDoListe') IS NOT NULL DROP TABLE #NotToDoListe
CREATE TABLE #NotToDoListe
	(
	  ProductKey	BIGINT NOT NULL
	 ,TimeID		BIGINT NOT NULL
	)
INSERT INTO #NotToDoListe
	SELECT 
		 dT.ProductKey
		,dT.TimeID
	FROM 
		dbo.sx_pf_dTime dT 
			LEFT JOIN dbo.sx_pf_dProducts dP
				ON dT.ProductKey = dP.ProductKey
	WHERE 
			dT.FactoryID		= @TargetFactoryID 
		AND	dT.ProductLineID	= @TargetProductLineID
		AND dP.Template			= @TargetTemplate

DECLARE MyCursor CURSOR FOR

	-- The TimeIDs to create
	SELECT 
		  tp.ProductID
		 ,tti.TimeID
	FROM 
		#TargetTimeIDSet tti
			JOIN #TargetProducts tp
				ON 1=1
			LEFT JOIN #NotToDoListe ntd
				ON tp.ProductKey = ntd.ProductKey AND
				   tti.TimeID = ntd.TimeID
	WHERE ntd.TimeID IS NULL

OPEN MyCursor
FETCH MyCursor INTO @ProductID, @TimeID
WHILE @@FETCH_STATUS = 0
BEGIN

	EXEC dbo.sx_pf_POST_TimeID 'SQL',@ProductID,@TargetProductLineID, @TargetFactoryID,@TimeID

	FETCH MyCursor INTO @ProductID, @TimeID
END
CLOSE MyCursor
DEALLOCATE MyCursor