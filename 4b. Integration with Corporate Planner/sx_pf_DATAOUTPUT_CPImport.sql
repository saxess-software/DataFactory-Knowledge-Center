
/*
Procedure to deliver dimensional data to the enduser
PlanningFactory 4.0
Gerd Tautenhahn, saxess-software gmbh
03/2016
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sx_pf_DATAOUTPUT_CPImport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sx_pf_DATAOUTPUT_CPImport]
GO

CREATE PROCEDURE sx_pf_DATAOUTPUT_CPImport (@Username AS NVARCHAR(255), @FactoryID AS NVARCHAR(255), @ProductLineID AS NVARCHAR(255))

AS
BEGIN
	 BEGIN TRY
		BEGIN TRANSACTION ONE

		DECLARE @TransactUsername AS NVARCHAR (255)
		DECLARE @FactoryKey AS BIGINT
		DECLARE @ProductLineKey AS BIGINT
		DECLARE @RightFlag AS INT

		--<fix log block>
		DECLARE @ProcedureName AS NVARCHAR (255) = OBJECT_NAME(@@PROCID)
		DECLARE @ParameterString AS NVARCHAR (MAX) = ''				-- SET HERE (all Parameters)
		DECLARE @EffectedRows AS INTEGER = 0						-- SET during Execution
		DECLARE @ResultCode AS INTEGER = 501						-- SET during Execution
		DECLARE @TimestampCall AS DATETIME = CURRENT_TIMESTAMP
		DECLARE @Comment AS NVARCHAR (2000) = ''					-- SET during Execution

		SET @ParameterString = '''' + @Username + ''',''' +  @FactoryID +''','''+ @ProductLineID +''
		--<fix log block/>

		-- clean IDs
		SET @Username = dbo.sx_pf_pProtectString(@Username)
		SET @FactoryID = dbo.sx_pf_pProtectID(@FactoryID)
		SET @ProductLineID = dbo.sx_pf_pProtectID(@ProductLineID)

		-- determine Transaction User
		SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username)
		IF @TransactUsername  = '403'	BEGIN
											SET @ResultCode = 403
											ROLLBACK TRANSACTION ONE
											EXEC sx_pf_pPOST_API_LogEntry @Username,@TransactUsername,@ProcedureName,@ParameterString,@EffectedRows,@ResultCode,@TimestampCall,@Comment
											RETURN @ResultCode
										END
		

		-- CASE 1 - Called for the whole cluster - deliver whatever the user gets with his rights
		IF @FactoryID = '' AND @ProductLineID = '' 
			BEGIN
				SELECT fV.ValueSeriesID							-- A
					,dVS.NameShort         AS ValueSeriesName	-- B
					,fV.ProductID								-- C
					,dP.NameShort          AS ProductName		-- D
					,fV.ProductLineID							-- E
					,dPL.NameShort         AS ProductLineName	-- F
					,fV.FactoryID								-- G
					,dF.NameShort          AS FactoryName		-- H
         
					,fV.TimeID															-- I
					,TRY_CAST(fV.TimeID AS Integer) / 10000 as Year					-- J
					,(TRY_CAST(fV.TimeID AS Integer) % 10000) /100 as Month			-- K
					,TRY_CAST(TRY_CAST(fV.TimeID as nvarchar) AS Datetime) as [Date]	--L

					,dF.ResponsiblePerson  AS FResponsiblePerson	-- M
					,dPL.ResponsiblePerson AS PLResponsiblePerson	-- N
         
					,dP.ResponsiblePerson		-- O
					,dP.[Status]				-- P
					,dP.GlobalAttribute1		-- Q
					,dP.GlobalAttribute2		-- R

					,TRY_CAST(fV.ValueInt as Money) / isnull(dVS.Scale,1) AS Value -- S

					,dP.GlobalAttribute3
					,dP.GlobalAttribute4
					,dP.GlobalAttribute5
					,dP.GlobalAttribute6
					,dP.GlobalAttribute7
					,dP.GlobalAttribute8
					,dP.GlobalAttribute9
					,dP.GlobalAttribute10
					,dVS.ValueSeriesNo
					,dVS.VisibilityLevel
					,dVS.ValueSource
					,dVS.Unit
					,dVS.Effect
					,dVS.EffectParameter

				FROM   sx_pf_fValues fV
						LEFT JOIN sx_pf_dValueSeries dVS
							ON fV.ValueSeriesKey = dVS.ValueSeriesKey
						LEFT JOIN sx_pf_dProducts dP
							ON fV.ProductKey = dP.ProductKey
						LEFT JOIN sx_pf_dProductLines dPL
							ON fV.ProductLineKey = dPL.ProductLineKey
						LEFT JOIN sx_pf_dFactories dF
							ON fV.FactoryKey = dF.FactoryKey
						LEFT JOIN sx_pf_vUserRights vR
							ON fV.FactoryID = vR.FactoryID AND 
								fV.ProductLineID = vR.ProductLineID			

				WHERE fV.ValueInt <> 0 AND dVS.[IsNumeric] = 1 
					AND vR.[Right] IN ('Write','Read') AND vR.Username = @TransactUsername


				SET @ResultCode = 200
			END
								
		-- CASE 2 - Called for one Factory - delivier only this if Rights fit
		IF (@FactoryID <> '' AND @ProductLineID = '') 
			BEGIN
				-- 3. If Factory not exists break
				SELECT @FactoryKey = FactoryKey FROM sx_pf_dFactories WHERE FactoryID = @FactoryID
				IF @FactoryKey IS NULL
									BEGIN
										SET @ResultCode = 404
										ROLLBACK TRANSACTION ONE
										EXEC sx_pf_pPOST_API_LogEntry @Username,@TransactUsername,@ProcedureName,@ParameterString,@EffectedRows,@ResultCode,@TimestampCall,@Comment
										RETURN @ResultCode
									END
				-- Check Rights
				SELECT @RightFlag = Count(FactoryID) FROM sx_pf_vUserRights WHERE Username = @TransactUsername AND FactoryID = @FactoryID AND [Right] IN ('Write','Read')
				IF @RightFlag > 0
					BEGIN
						-- SELECT Values
						SELECT
							 fV.ValueSeriesID							-- A
							,dVS.NameShort         AS ValueSeriesName	-- B
							,fV.ProductID								-- C
							,dP.NameShort          AS ProductName		-- D
							,fV.ProductLineID							-- E
							,dPL.NameShort         AS ProductLineName	-- F
							,fV.FactoryID								-- G
							,dF.NameShort          AS FactoryName		-- H
         
							,fV.TimeID															-- I
							,TRY_CAST(fV.TimeID AS Integer) / 10000 as Year					-- J
							,(TRY_CAST(fV.TimeID AS Integer) % 10000) /100 as Month			-- K
							,TRY_CAST(TRY_CAST(fV.TimeID as nvarchar) AS Datetime) as [Date]	--L

							,dF.ResponsiblePerson  AS FResponsiblePerson	-- M
							,dPL.ResponsiblePerson AS PLResponsiblePerson	-- N
         
							,dP.ResponsiblePerson		-- O
							,dP.[Status]				-- P
							,dP.GlobalAttribute1		-- Q
							,dP.GlobalAttribute2		-- R

							,TRY_CAST(fV.ValueInt as Money) / isnull(dVS.Scale,1) AS Value -- S

							,dP.GlobalAttribute3
							,dP.GlobalAttribute4
							,dP.GlobalAttribute5
							,dP.GlobalAttribute6
							,dP.GlobalAttribute7
							,dP.GlobalAttribute8
							,dP.GlobalAttribute9
							,dP.GlobalAttribute10
							,dVS.ValueSeriesNo
							,dVS.VisibilityLevel
							,dVS.ValueSource
							,dVS.Unit
							,dVS.Effect
							,dVS.EffectParameter

						FROM   sx_pf_fValues fV
								LEFT JOIN sx_pf_dValueSeries dVS
									ON fV.ValueSeriesKey = dVS.ValueSeriesKey
								LEFT JOIN sx_pf_dProducts dP
									ON fV.ProductKey = dP.ProductKey
								LEFT JOIN sx_pf_dProductLines dPL
									ON fV.ProductLineKey = dPL.ProductLineKey
								LEFT JOIN sx_pf_dFactories dF
									ON fV.FactoryKey = dF.FactoryKey	

						WHERE fV.ValueInt <> 0 AND dVS.[IsNumeric] = 1  AND fV.FactoryKey = @FactoryKey

						SET @ResultCode = 200
					END
				ELSE
					SET @ResultCode = 401
			END

		-- CASE 3 - Called for one ProductLine

		IF (@FactoryID <> '' AND @ProductLineID <> '')
			BEGIN
				-- 3. If Factory not exists break
				SELECT @FactoryKey = FactoryKey FROM sx_pf_dFactories WHERE FactoryID = @FactoryID
				SELECT @ProductLineKey = ProductLineKey FROM sx_pf_dProductLines WHERE FactoryKey = @FactoryKey AND ProductLineID = @ProductLineID
				IF @FactoryKey IS NULL OR @ProductLineKey IS NULL
									BEGIN
										SET @ResultCode = 404
										ROLLBACK TRANSACTION ONE
										EXEC sx_pf_pPOST_API_LogEntry @Username,@TransactUsername,@ProcedureName,@ParameterString,@EffectedRows,@ResultCode,@TimestampCall,@Comment
										RETURN @ResultCode
									END
				-- Check Rights
				SELECT @RightFlag = Count(ProductLineID) FROM sx_pf_vUserRights WHERE Username = @TransactUsername AND FactoryID = @FactoryID AND ProductLineID = @ProductLineID AND [Right] IN ('Write','Read')
				IF @RightFlag > 0
					BEGIN
						SELECT
							 fV.ValueSeriesID							-- A
							,dVS.NameShort         AS ValueSeriesName	-- B
							,fV.ProductID								-- C
							,dP.NameShort          AS ProductName		-- D
							,fV.ProductLineID							-- E
							,dPL.NameShort         AS ProductLineName	-- F
							,fV.FactoryID								-- G
							,dF.NameShort          AS FactoryName		-- H
         
							,fV.TimeID															-- I
							,TRY_CAST(fV.TimeID AS Integer) / 10000 as Year					-- J
							,(TRY_CAST(fV.TimeID AS Integer) % 10000) /100 as Month			-- K
							,TRY_CAST(TRY_CAST(fV.TimeID as nvarchar) AS Datetime) as [Date]	--L

							,dF.ResponsiblePerson  AS FResponsiblePerson	-- M
							,dPL.ResponsiblePerson AS PLResponsiblePerson	-- N
         
							,dP.ResponsiblePerson		-- O
							,dP.[Status]				-- P
							,dP.GlobalAttribute1		-- Q
							,dP.GlobalAttribute2		-- R

							,TRY_CAST(fV.ValueInt as Money) / isnull(dVS.Scale,1) AS Value -- S

							,dP.GlobalAttribute3
							,dP.GlobalAttribute4
							,dP.GlobalAttribute5
							,dP.GlobalAttribute6
							,dP.GlobalAttribute7
							,dP.GlobalAttribute8
							,dP.GlobalAttribute9
							,dP.GlobalAttribute10
							,dVS.ValueSeriesNo
							,dVS.VisibilityLevel
							,dVS.ValueSource
							,dVS.Unit
							,dVS.Effect
							,dVS.EffectParameter

						FROM   sx_pf_fValues fV
								LEFT JOIN sx_pf_dValueSeries dVS
									ON fV.ValueSeriesKey = dVS.ValueSeriesKey
								LEFT JOIN sx_pf_dProducts dP
									ON fV.ProductKey = dP.ProductKey
								LEFT JOIN sx_pf_dProductLines dPL
									ON fV.ProductLineKey = dPL.ProductLineKey
								LEFT JOIN sx_pf_dFactories dF
									ON fV.FactoryKey = dF.FactoryKey	

						WHERE fV.ValueInt <> 0 AND dVS.[IsNumeric] = 1  AND fV.ProductLineKey = @ProductLineKey

						SET @ResultCode = 200
					END
				ELSE 
					SET @ResultCode = 401 -- Rechte waren nicht da
			END

		EXEC sx_pf_pPOST_API_LogEntry @Username,@TransactUsername,@ProcedureName,@ParameterString,@EffectedRows,@ResultCode,@TimestampCall,@Comment
		COMMIT TRANSACTION ONE
		RETURN @ResultCode

	END TRY

	BEGIN CATCH
		PRINT 'Rollback due to not executable command.'	
		ROLLBACK TRANSACTION ONE
		SET @EffectedRows = 0
		SET @ResultCode = 500
		SET @Comment = ERROR_MESSAGE()
		EXEC sx_pf_pPOST_API_LogEntry @Username,@TransactUsername,@ProcedureName,@ParameterString,@EffectedRows,@ResultCode,@TimestampCall,@Comment
		RETURN @ResultCode
	END CATCH
END

GO


/*Testcall

DECLARE @RC int
DECLARE @Username nvarchar(255) = 'SQL'
DECLARE @FactoryID nvarchar(255) = 'ZT'
DECLARE @ProductLineID nvarchar(255) = 'U'

EXECUTE @RC = [dbo].[sx_pf_DATAOUTPUT_CPImport] 
   @Username
  ,@FactoryID
  ,@ProductLineID

PRINT @RC

TestCases:
	- With empty Factory/PL ID
	- With FactoryID
	- With ProductlineID
	- With unknown User
	- With User without Rights

*/