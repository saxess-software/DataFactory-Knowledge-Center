/*

DATAOUTPUT Procedure for analysing API Log
Stefan Lindenlaub 02/2017

*/


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sx_pf_DATAOUTPUT_APILog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sx_pf_DATAOUTPUT_APILog]
GO

CREATE PROCEDURE sx_pf_DATAOUTPUT_APILog

AS 

SET NOCOUNT ON 


SELECT api.LogKey
      ,api.SQLSystemUser
	  ,rU.UserKey
	  ,rU.PersonSurname
	  ,rU.PersonFirstName
	  ,rU.Email
	  ,rU.LDAPIP
	  ,rU.Status AS UserStatus
      ,api.UserName
      ,api.TransactUsername
      ,api.ProcedureName
      ,api.ParameterString
      ,api.EffectedRows
      ,api.ReturnCode
	  ,CASE WHEN api.ReturnCode = 200 THEN 'ok, operation done successfully, data updated'
			WHEN api.ReturnCode = 201 THEN 'ok, operation done successfully, new data created'
			WHEN api.ReturnCode = 204 THEN 'ok, but action did not result in any changed data - maybe action was useless'
			WHEN api.ReturnCode = 401 THEN 'forbidden, transaction not executed due to missing userrights'
			WHEN api.ReturnCode = 403 THEN 'forbidden, transaction not executed due to violation against rules or consistence rules'
			WHEN api.ReturnCode = 404 THEN 'not executed, objects or data entitys not found'
			WHEN api.ReturnCode = 500 THEN 'API hat intern einen Fehler verursacht'
			ELSE 'Unknown ReturnCode'
			END AS 'ReturnCode Description'
      ,api.TimestampCall
      ,api.TimestampReturn
	  ,CAST(FORMAT(api.TimestampCall,'dd.MM.yyyy','de-de') AS DATE) AS Datum
	  ,YEAR(api.TimestampCall) AS Jahr
	  ,MONTH(api.TimestampCall) AS Monat
	  ,CAST(YEAR(api.TimestampCall) AS NVARCHAR(max))+'-'+REPLICATE('0',2-LEN(CAST(Month(api.TimestampCall) AS NVARCHAR(max))))+CAST(Month(api.TimestampCall) AS NVARCHAR(max)) AS 'Jahr-Monat'
      ,api.Comment
      ,api.ProcessCode
	  ,DATEDIFF(MILLISECOND,[TimestampCall],[TimestampReturn]) AS 'Duration in ms'
	  ,CASE WHEN CHARINDEX('COPY',[ProcedureName])>0		THEN 'COPY'
			WHEN CHARINDEX('DATAOUTPUT',[ProcedureName])>0	THEN 'DATAOUTPUT'
			WHEN CHARINDEX('DELETE',[ProcedureName])>0		THEN 'DELETE'
			WHEN CHARINDEX('EXPORT',[ProcedureName])>0		THEN 'EXPORT'
			WHEN CHARINDEX('GET',[ProcedureName])>0			THEN 'GET'
			WHEN CHARINDEX('materialize',[ProcedureName])>0	THEN 'materialize'
			WHEN CHARINDEX('MOVE',[ProcedureName])>0		THEN 'MOVE'
			WHEN CHARINDEX('pGET',[ProcedureName])>0		THEN 'pGET'
			WHEN CHARINDEX('POST',[ProcedureName])>0		THEN 'POST'
			WHEN CHARINDEX('pPOST',[ProcedureName])>0		THEN 'pPOST'
			WHEN CHARINDEX('ROLLOUT',[ProcedureName])>0		THEN 'ROLLOUT'			
			ELSE 'OTHER'
			END AS Proceduretyp
 FROM sx_pf_API_Log api
	LEFT JOIN sx_pf_rUser rU ON rU.UserName = api.TransactUsername

GO

GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_APILog TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_APILog TO pf_PlanningFactoryService;