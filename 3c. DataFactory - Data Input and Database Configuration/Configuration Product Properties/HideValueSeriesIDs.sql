
/*

Stefan Lindenlaub
Saxess Software GmbH
03/2018

Hide ValueSeriesIDs for Webclient

*/

-- ############ Variables
DECLARE  @FactoryID		NVARCHAR (255)
		,@ProductlineID NVARCHAR (255)
		,@ProductID		NVARCHAR (255)

-- ############ Choose Target Products
DECLARE MyCursor CURSOR FOR

    SELECT dP.FactoryID
		  ,dP.ProductlineID
		  ,dP.ProductID
	FROM dbo.sx_pf_dProducts dP
	-- Filter Targets here (put where clause in comments for no filter)
	--WHERE dP.FactoryID = 'FactoryID'
	--  AND dP.ProductlineID = 'ProductLineID'
	--  AND dP.ProductID = 'ProductID'
	
OPEN MyCursor
FETCH MyCursor INTO @FactoryID,@ProductlineID,@ProductID
WHILE @@FETCH_STATUS = 0
    BEGIN

		EXEC sx_pf_POST_Productproperty 'SQL',@ProductID,@ProductlineID,@FactoryID,'pdp_ValueSeriesID_hidden','ValueSeriesID is hidden','','','','1','1','1','2',''

	FETCH MyCursor INTO @FactoryID,@ProductlineID,@ProductID
	END
CLOSE MyCursor
DEALLOCATE MyCursor

GO
