
### How to use the pivot view in the Webclient

1. This script creates six standard pivot datasources for the Webclient
1. you can also use any other procedure for the Webclient, this procedure must have the two parameters @Username and @FactoryID as leading parameters
1. if the used procedure has more parameters (like ProductlineID etc.) this must be declared as optional with standard parameter in the procedure (... @ProductlineID NVARCHAR(255)='')

````SQL
/* 
	This script creates tabs Factory Level of the webclient 
	in all factories execpt ZT. 
	01/2018 Gerd Tautenhahn for saxess-software gmbh
	DataFactory 4.0
*/

DECLARE @FactoryID nvarchar(255)

DECLARE MyCursor CURSOR FOR

    -- For all Factories exept ZT
    SELECT dF.FactoryID FROM dbo.sx_pf_dFactories dF WHERE dF.FactoryID <> 'ZT'

OPEN MyCursor
FETCH MyCursor INTO @FactoryID
WHILE @@FETCH_STATUS = 0
    BEGIN
		
		--first Tab
		EXEC dbo.sx_pf_POST_FactoryTab 'SQL', @FactoryID, N'Tab_1', N'Pivot 1', N'Diese Darstellung zeigt...', N'Pivot', N'sx_pf_DATAOUTPUT_spLMValidierung', N''
		--second Tab
		EXEC dbo.sx_pf_POST_FactoryTab 'SQL', @FactoryID, N'Tab_2', N'Pivot 2', N'Diese Darstellung zeigt...', N'Pivot', N'sx_pf_DATAOUTPUT_spLMValidierung', N''
		--third Tab
		EXEC dbo.sx_pf_POST_FactoryTab 'SQL', @FactoryID, N'Tab_3', N'Pivot 3', N'Diese Darstellung zeigt...', N'Pivot', N'sx_pf_DATAOUTPUT_spLMValidierung', N''
		--fourth Tab
		EXEC dbo.sx_pf_POST_FactoryTab 'SQL', @FactoryID, N'Tab_4', N'Pivot 4', N'Diese Darstellung zeigt...', N'Pivot', N'sx_pf_DATAOUTPUT_spLMValidierung', N''

		FETCH MyCursor INTO @FactoryID
END
CLOSE MyCursor
DEALLOCATE MyCursor

````
