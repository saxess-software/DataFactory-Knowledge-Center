
/*
Author: 	Stefan Lindenlaub
Created: 	2018/12
Summary:	Dieses Skript rollt das Layout einer Productline auf alle anderen Productlines innerhalb der gleichen Factory aus
*/

-- ###############################################################################
  -- Hier die Factory/Productline definieren, dessen Layout ausgerollt werden soll
		DECLARE @FactoryID		nvarchar(255) = 'Inv2018'
		DECLARE @ProductlineID  nvarchar(255) = '0500-AHA'
-- ###############################################################################

  -- Variable für Layout
  	DECLARE @LayoutProductLine nvarchar(max) = ''

 -- Layout der definierten Productline in Variable schreiben
 	SELECT @LayoutProductLine = ValueText
 	FROM sx_pf_rPreferences
 	WHERE FactoryID = @FactoryID 
 		AND ProductLineID = @ProductlineID
 
 -- bestehende Layouts aller anderen Productlines innerhalb der Factory löschen
 	DELETE FROM sx_pf_rPreferences
 	WHERE FactoryID = @FactoryID
 		AND ProductLineID <> @ProductlineID 
 		AND SettingName = 'ProductLineLayoutPreferences'

 -- Layout ausrollen 
 	INSERT INTO sx_pf_rPreferences
 		SELECT	0 AS UserKey,
 				'All' AS UserName,
 				FactoryID,
 				ProductLineID,
 				'ProductLineLayoutPreferences' AS SettingTable ,
 				0 AS ValueINT,
 				@LayoutProductLine AS 'Value Text'
 		FROM sx_pf_dProductLines
 		WHERE FactoryID = @FactoryID
 			AND ProductLineID <> @ProductlineID


	
	