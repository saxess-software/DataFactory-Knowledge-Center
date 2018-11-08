
/*
Author: 	Heathcliff Power
Created: 	2018/11
Summary:	Snippet user failure report | Something will be tested and checked

*/

SET @TestSource = 'ProductID'									
SET @TestName	= 'Cost center is no longer active'			

	BEGIN TRY
	--  Insert
		INSERT INTO [control].[tCustomFailureReport]
			SELECT	 @Timestamp																	AS [Timestamp]
					,fV.FactoryID																AS FactoryID
					,fV.ProductLineID															AS ProductLineID
					,fV.ProductID																AS ProductID
					,@TestSource																AS TestSource
					,@TestName																	AS TestName
					,'Warning'																	AS ResultType
					,fV.ValueText + ' is not a valid cost center'								AS ResultText
					,1																			AS ResultNumeric		
			FROM dbo.sx_pf_fValues fV
			WHERE	fV.FactoryID = '1'
				AND fV.ValueText NOT IN (	SELECT dP.ProductID
											FROM dbo.sx_pf_dProducts dP
											WHERE dP.FactoryID = '4'	)

	-- Standard handling if test is executed succesfully  
			IF @@ROWCOUNT = 0
				BEGIN
					INSERT INTO [control].[tCustomFailureReport]
						SELECT 	 @Timestamp
								,'AllFID' 
								,'AllPLID'
								,'AllPID'
								,@TestSource
								,@TestName
								,'OK'								AS ResultType
								,'No problem detected'
								, 0 
				END
	END TRY

	-- Standard handling if test has not been executed succesfully - test batch is aborted
	BEGIN CATCH
		INSERT INTO [control].[tCustomFailureReport]
			SELECT	@Timestamp 
					,'ErrorFID'
					,'ErrorPLID'
					,'ErrorPID'
					,@TestSource
					,@TestName
					,'ERROR' AS ResultType
					,'Test has been aborted'
					,-1 AS Wert
	END CATCH

--------------------------------------------------------------------------------------------------------------------------------------

