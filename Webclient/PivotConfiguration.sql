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

