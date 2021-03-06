/*
Query to analyse the logfile for certain events

*/
SELECT [LogKey]
      ,[SQLSystemUser]
      ,[UserName]
      ,[TransactUsername]
      ,[ProcedureName]
      ,[ParameterString]
	  ,LEN(ParameterString) AS ParameterLength
      ,[EffectedRows]
      ,[ReturnCode]
      ,[TimestampCall]
      ,[TimestampReturn]
      ,[Comment]
      ,[ProcessCode]
	  ,RIGHT(Parameterstring, LEN(ParameterString) - CHARINDEX(',',ParameterString,10))
  FROM [DataFactory_BFW_2017_Last].[dbo].[sx_pf_API_Log] 
  
  WHERE 
			Logkey >= 1535151  
		AND Logkey <= 2371890 
		-- not the import actions
		AND SQLSystemUser <> 'sys.pf'
		-- not our admin actions
		AND SQLSystemUser <> 'DBFW01\saxess'
		-- only POSTs
		AND ProcedureName LIKE 'sx_pf_POST%'

		-- maybe some posts not
		AND ProcedureName NOT LIKE 'sx_pf_POST_Statement'
		AND ProcedureName NOT LIKE 'sx_pf_POST_Right%'
		-- only needed Productlines
		AND (
			RIGHT(Parameterstring, LEN(ParameterString) - CHARINDEX(',',ParameterString,10)) LIKE '''5%' 
		    OR 
			RIGHT(Parameterstring, LEN(ParameterString) - CHARINDEX(',',ParameterString,10)) LIKE '''4%' 
			)
  
  ORDER BY LogKey 