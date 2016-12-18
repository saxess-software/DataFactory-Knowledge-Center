
### How to use the pivot view in the Webclient

1. API must be 4.0.57 or higher, with the Procedures GET_FactoryPivots, POST_FactoryPivot
1. the Pivots must be defined per Factory in Table sx_pf_gFactories (in Standard with use of procedure sx_pf_FactorySummary)
1. you can use any procedure for Webclient, the procedure must have the two parameters @Username and @FactoryID as leading parameters
1. if the used procedure has more parameters (like ProductlineID etc.) this must be declared as optional with standard parameter in the procedure (... @ProductlineID NVARCHAR(255)='')

````SQL
/* 
	This script creates two standard pivot table configurations for the webclient 
	in all factories execpt ZT. 
	11/2016 Gerd Tautenhahn for saxess-software gmbh
	DataFactory 4.0
*/

DECLARE @FactoryKey BIGINT
DECLARE @FactoryID nvarchar(255)

DELETE FROM dbo.sx_pf_gFactories WHERE PropertyID IN ('Pivot_1','Pivot_2')

DECLARE MyCursor CURSOR FOR

	-- Abfrage füllt Cursor
	SELECT FactoryKey,dF.FactoryID FROM dbo.sx_pf_dFactories dF WHERE dF.FactoryID <> 'ZT'

OPEN MyCursor
FETCH MyCursor INTO @FactoryKey, @FactoryID
WHILE @@FETCH_STATUS = 0
	BEGIN
     	 	-- First Pivot Table
			INSERT INTO dbo.sx_pf_gFactories
			(FactoryKey
			,FactoryID
			,PropertyID
			,PropertyName
			,CommentUser
			,CommentDev
			,Unit
			,ValueText
			,ValueInt
			,Scale
			,IsROSystemProperty
			,FormatID
			)
			VALUES  (@FactoryKey  
					,@FactoryID  
					,N'Pivot_1'  
					,N'sx_pf_DATAOUTPUT_FactorySummary' 
					,N'My Pivot 1'  
					,N''  
					,N''  
					,N''  
					,0  
					,0  
					,0  
					,N''  
					)

			 -- Second Pivot Table
			INSERT INTO dbo.sx_pf_gFactories
			(FactoryKey
			,FactoryID
			,PropertyID
			,PropertyName
			,CommentUser
			,CommentDev
			,Unit
			,ValueText
			,ValueInt
			,Scale
			,IsROSystemProperty
			,FormatID
			)
			VALUES  (@FactoryKey  
					,@FactoryID  
					,N'Pivot_2'  
					,N'sx_pf_DATAOUTPUT_FactorySummary'  
					,N'My Pivot 2' 
					,N'' 
					,N''  
					,N'' 
					,0  
					,0  
					,0  
					,N''  
					)

      		FETCH MyCursor INTO  @FactoryKey, @FactoryID
	END
CLOSE MyCursor
DEALLOCATE MyCursor
````
