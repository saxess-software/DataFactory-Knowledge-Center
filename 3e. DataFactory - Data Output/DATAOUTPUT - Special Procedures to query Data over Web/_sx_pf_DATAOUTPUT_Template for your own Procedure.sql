
/*
[Describe the sense of this DATAOUTPUT Procecude]

Testcall
DECLARE @RESULT INT
EXEC @RESULT = sx_pf_DATAOUTPUT_[Name] 'SQL'
Print @RESULT
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sx_pf_DATAOUTPUT_Name') AND type in (N'P', N'PC'))
DROP PROCEDURE sx_pf_DATAOUTPUT_Name
GO

CREATE PROCEDURE sx_pf_DATAOUTPUT_Name (@Username NVARCHAR(255), @FactoryID NVARCHAR (255) = '', @ProductlineID NVARCHAR(255)='')

AS 

SET NOCOUNT ON

-- Fixed Block for Logging
DECLARE @TransactUsername NVARCHAR(255) = N'';
DECLARE @ProcedureName AS NVARCHAR (255) = OBJECT_NAME(@@PROCID);
DECLARE @ParameterString AS NVARCHAR (MAX) = N'''' + ISNULL(@Username, N'NULL') + N''',''' + ISNULL(@FactoryID, N'NULL') + N''',''' + ISNULL(@ProductlineID, N'NULL') + N'''';
DECLARE @EffectedRows AS INT = 0;						-- SET during Execution
DECLARE @ResultCode AS INT = 501;						-- SET during Execution
DECLARE @TimestampCall AS DATETIME = CURRENT_TIMESTAMP;
DECLARE @Comment AS NVARCHAR (2000) = N''				-- SET during Execution

-- determine Transaktionuser
SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username)
IF @TransactUsername  = '403'	BEGIN
									SET @ResultCode = 403
									EXEC sx_pf_pPOST_API_LogEntry @Username,@TransactUsername,@ProcedureName,@ParameterString,@EffectedRows,@ResultCode,@TimestampCall,@Comment
									RETURN @ResultCode
								END

--SET @TransactUsername = 'support@planning-factory.com'

-- Write your OUTPUT Query here ************************************************************
	SELECT
		 fV.FactoryID
		,fV.FactoryID + ' ' + dF.NameShort AS FactoryIDName
		,fV.ProductLineID
		,fV.ProductLineID + ' ' + dPL.NameShort	 AS ProductLineIDName
		,fV.ProductID
		,fV.ProductID + ' ' + dP.NameShort	 AS ProductIDName
		,fV.TimeID
		,fV.ValueSeriesID
		,IIF(dVS.IsNumeric=1,CAST(CAST(ValueInt as Money)/dVS.Scale AS NVARCHAR),ValueText) AS Value

	FROM sx_pf_fValues fV
		-- for FactoryName / Properties
		LEFT JOIN sx_pf_dFactories dF 
			ON fV.FactoryKey = dF.FactoryKey

		-- for ProductlineName / Properties
		LEFT JOIN sx_pf_dProductlines dPL
			ON fV.ProductLineKey = dPL.ProductlineKey

		-- for ProductName / Properties
		LEFT JOIN sx_pf_dProducts dP 
			ON fV.ProductKey = dP.ProductKey

		-- für IsNumeric / Scale
		LEFT JOIN dbo.sx_pf_dValueSeries dVS 
			ON fV.ValueSeriesKey = dVS.ValueSeriesKey

		-- Right Filter
		INNER JOIN dbo.sx_pf_vUserRights vUR 
			ON fV.FactoryID = vUR.FactoryID AND
				fV.ProductLineID = vUR.ProductLineID AND
				vUR.UserName = @TransactUsername AND
				VUR.[Right] IN ('Read', 'Write')
	WHERE  
		-- this uses the optional passed parameter or not
		(fV.FactoryID = @FactoryID  OR @FactoryID = '') AND
		(fV.ProductlineID = @ProductlineID OR @ProductlineID = '')

			  
SET @ResultCode = 200

-- Write Logentry
EXEC [dbo].[sx_pf_pPOST_API_LogEntry] @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;

RETURN @ResultCode

GO

GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_[Name] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_[Name] TO pf_PlanningFactoryService;
GO