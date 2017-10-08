
### How to customize WebPivots

1) As a standard feature, when initializing the WebClient six standard WebPivots will be provided. These six standard WebPivots are based on six standard DATAOUTPUT prozedure which are the following:
- sx_pf_DATAOUPUT_NumericValues
- sx_pf_DATAOUPUT_FactorySummary
- sx_pf_DATAOUPUT_Profit
- sx_pf_DATAOUPUT_CashValues
- sx_pf_DATAOUPUT_Balance
- sx_pf_DATAOUPUT_TextValues
2) For information on the initalization process please have a look at [WebPivot_Configuration](https://github.com/saxess-software/SQL-Best-Practice/blob/master/3c.%20DataFactory%20Installation%20and%20Update/Webclient/WebPivot_Configuration.md).
3) In order to customize the existing WebPivots you can use the following script. Make sure that any procedure you would like to use for your WebPivot contains the two parameters @Username and @FactoryID as leading parameters.

````SQL

-- ##### DELETE a certain or various WebPivots
	DELETE FROM sx_pf_gFactories
	WHERE PropertyID IN ('Pivot_1', 'Pivot_2')    -- enter a specific or various PropertyIDs

-- #### GENERATE new WebPivots
-- Pivot 1 'Neue WebPivot 1'
	INSERT INTO sx_pf_gFactories
	SELECT	FactoryKey AS FactoryKey,
		FactoryID,
		'Pivot_1' AS PropertyID,     -- make sure to include the correct PropertyID of your WebPivot
		'NameMeinerProzedur1' AS PropertyName,  -- enter the name of your procedure
		'Neue WebPivot1' AS CommentUser,  -- enter the name of your new WebPivot
		'' AS CommentDEV,
		'' AS Unit,
		'',
		0 AS ValueINT,
		0 AS Scale,
		0 AS IsROSystemProperty,
		'' AS FormatID
	FROM sx_pf_dFactories
	WHERE FactoryID NOT IN ('ZT')
	
-- Pivot 2 'Neue WebPivot 2'
	INSERT INTO sx_pf_gFactories
	SELECT	FactoryKey AS FactoryKey,
		FactoryID,
		'Pivot_2' AS PropertyID,     -- make sure to include the correct PropertyID of your WebPivot
		'NameMeinerProzedur2' AS PropertyName,  -- enter the name of your procedure
		'Neue WebPivot2' AS CommentUser,  -- enter the name of your new WebPivot
		'' AS CommentDEV,
		'' AS Unit,
		'',
		0 AS ValueINT,
		0 AS Scale,
		0 AS IsROSystemProperty,
		'' AS FormatID
	FROM sx_pf_dFactories
	WHERE FactoryID NOT IN ('ZT')

````
