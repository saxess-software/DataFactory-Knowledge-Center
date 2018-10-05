
SET @TestSource = 'ProductDataTable'	-- usually the name of the folder this snippet is in
SET @TestName	= 'Test for negativ Values in any Unikum Template.'			-- an friendly description of the test

	BEGIN TRY
	
		INSERT INTO control.tCustomFailureReport
			SELECT 
				 @Timestamp,
				 fV.FactoryID
				,fV.ProductlineID
				,fV.ProductID
				,@TestSource
				,@TestName
				,'FAILURE' AS ResultType -- or FAILURE or WARNING

				,'Wert ' 
					+ CAST(fV.ValueInt AS NVARCHAR(255)) 
					+ ' in Periode ' 
					+ CAST(fV.TimeID AS NVARCHAR(255)) + ' ist negativ, das soll nicht sein.' AS ResultText

				,fV.ValueInt AS ResultNumeric

			FROM dbo.sx_pf_fValues fV 
				LEFT JOIN dbo.sx_pf_dProducts dP
					ON fV.ProductKey = dP.ProductKey

			WHERE	
					
					dP.Template LIKE '%Unikum%'
				AND	fV.ValueInt < 0

	-- #### STANDARD HANDLING FOR SUCCESS / ERROR - KEEP THIS - NO NEED TO EDIT ########################################################
			IF @@ROWCOUNT = 0
				BEGIN
					INSERT INTO control.tCustomFailureReport
						SELECT 
							 @Timestamp
							,'AllFID' 
							,'AllPLID'
							,'AllPID'
							,@TestSource
							,@TestName
							,'OK' AS ResultType
							,'No problems found.'
							, 0 
					END
	END TRY
	
	BEGIN CATCH
		INSERT INTO control.tCustomFailureReport
			SELECT
				 @Timestamp 
				,'ErrorFID'
				,'ErrorPLID'
				,'ErrorPID'
				,@TestSource
				,@TestName
				,'ERROR' AS ResultType
				,'Test crashed itself.'
				,-1 AS Wert

	END CATCH

