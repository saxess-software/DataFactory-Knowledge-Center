/*
Dataoutput to monitor all Values in Products, where the ValueSeries has a Drop-Down List definied, which are not ListMember

Testcall
DECLARE @RESULT INT
EXEC @RESULT = sx_pf_DATAOUTPUT_ListMemberCheck 'SQL'
Print @RESULT
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sx_pf_DATAOUTPUT_ListMemberCheck') AND type in (N'P', N'PC'))
DROP PROCEDURE sx_pf_DATAOUTPUT_ListMemberCheck
GO

CREATE PROCEDURE sx_pf_DATAOUTPUT_ListMemberCheck (@Username NVARCHAR(255), @FactoryID NVARCHAR (255) = '', @ProductlineID NVARCHAR(255)='')

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


-- Listenwerte in NON-Numeric ValueSeries
SELECT
	 fV.FactoryID
	,fV.ProductLineID
	,fV.ProductID
	,fV.ValueSeriesID
	,dVS.ValueListID
	,'A List Value is in Use, wich is not member of the List of Drop-Down Texts.' AS ErrorText
	,fV.ValueText 

FROM sx_pf_fValues fV
	LEFT JOIN sx_pf_dValueSeries dVS 
		ON fV.ValueSeriesKey = dVS.ValueSeriesKey

	-- Right Filter
	INNER JOIN dbo.sx_pf_vUserRights vUR 
		ON fV.FactoryID = vUR.FactoryID AND
			fV.ProductLineID = vUR.ProductLineID AND
			vUR.UserName = @TransactUsername AND
			VUR.[Right] IN ('Read', 'Write')

WHERE
	dVS.IsNumeric = 0 AND
	fV.ValueText != '' AND
	dVS.ValueListID != '' AND
	dVS.ValueListID + '_' + fV.ValueText NOT IN 
						(
							SELECT 
								 ListID + '_' + ValueText
							FROM
								sx_pf_hListValues 
					)

UNION ALL

-- Listenwerte in Numeric ValueSeries
SELECT
	 fV.FactoryID
	,fV.ProductLineID
	,fV.ProductID
	,fV.ValueSeriesID
	,dVS.ValueListID
	,'A List Value is in Use, wich is not member of the List of Drop-Down Numbers.' AS ErrorText
	,CAST(fV.ValueInt AS NVARCHAR)

FROM sx_pf_fValues fV
	LEFT JOIN sx_pf_dValueSeries dVS 
		ON fV.ValueSeriesKey = dVS.ValueSeriesKey

	-- Right Filter
	INNER JOIN dbo.sx_pf_vUserRights vUR 
		ON fV.FactoryID = vUR.FactoryID AND
			fV.ProductLineID = vUR.ProductLineID AND
			vUR.UserName = @TransactUsername AND
			VUR.[Right] IN ('Read', 'Write')

WHERE
	dVS.IsNumeric = 1 AND
	fV.ValueText != '' AND
	dVS.ValueListID != '' AND
	dVS.ValueListID + '_' + CAST(fV.ValueInt AS NVARCHAR) NOT IN 
						(
							SELECT 
								 ListID + '_' + CAST(fV.ValueInt AS NVARCHAR)
							FROM
								sx_pf_hListValues 
						)

			  
SET @ResultCode = 200

-- Write Logentry
EXEC [dbo].[sx_pf_pPOST_API_LogEntry] @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;

RETURN @ResultCode

GO

GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_ListMemberCheck TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_ListMemberCheck TO pf_PlanningFactoryService;
GO