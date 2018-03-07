
/*

Stefan Lindenlaub
Saxess Software GmbH
03/2018

Activate Autoscroll

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

		EXEC sx_pf_POST_Productproperty 'SQL',@ProductID,@ProductlineID,@FactoryID,'xl_pdp_no_autoscroll','Autoscroll','','','','0','0','1','2',''

	FETCH MyCursor INTO @FactoryID,@ProductlineID,@ProductID
	END
CLOSE MyCursor
DEALLOCATE MyCursor

GO
