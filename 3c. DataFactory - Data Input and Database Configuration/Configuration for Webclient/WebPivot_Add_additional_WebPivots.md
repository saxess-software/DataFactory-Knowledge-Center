
### How to add an additional WebPivot to a certain factory

1. As a standard feature, when initializing the WebClient six standard WebPivots will be provided. In addition to it, you can include additional WebPivots.
1. In order to add an additional WebPivot to a certain factory you can use the following script. Make sure that any procedure you would like to use for your WebPivot contains the two parameters @Username and @FactoryID as leading parameters.

````SQL

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
		VALUES  
			(FactoryKey -- extract relevant FactoryKey from table 'gFactories'
			,FactoryID  -- extract relevant FactoryID from table 'gFactories'
			,N'Pivot_7' -- enter the PropertyID of your WebPivot 
			,N'NameMeinerProzedur'   -- enter the name of your procedure
			,N'NameDerWebPivot'   -- enter the name of your WebPivot
			,N''
			,N''
			,N''
			,0
			,0
			,0
			,N'')

````
