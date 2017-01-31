/****** Skript für SelectTopNRows-Befehl aus SSMS ******/
SELECT [LogKey]
      ,[SQLSystemUser]
      ,[UserName]
      ,[TransactUsername]
      ,[ProcedureName]
      ,[ParameterString]
      ,[EffectedRows]
      ,[ReturnCode]
      ,[TimestampCall]
      ,[TimestampReturn]
      ,[Comment]
      ,[ProcessCode]
	  ,DATEDIFF(MILLISECOND,[TimestampCall],[TimestampReturn]) AS Duration
	  ,CASE WHEN CHARINDEX('POST',[ProcedureName])>0 THEN 'POST'
			WHEN CHARINDEX('GET',[ProcedureName])>0  THEN 'GET'
			WHEN CHARINDEX('COPY',[ProcedureName])>0 THEN 'COPY'
	  ELSE 'OTHER' END
 FROM [DataFactory_SKRapid_Backup].[dbo].[sx_pf_API_Log]