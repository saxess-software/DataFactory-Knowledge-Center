/*
Script to import parts oft API_Log from another database into the current Database
Gerd Tautenhahn for saxess-software gmbh
DataFactory 4.0 - 01/2018

*/

USE DataFactory_BFW_2017_20171107;     --The target database (usually the older backup of DataFactory)


DECLARE  @FirstLogKeyToImport	BIGINT			= 1535152
		,@LastLogKeyToImport	BIGINT			= 2371890
		,@SQLSystemuser			NVARCHAR(255)	= ''
		,@Username				NVARCHAR(255)	= ''
		,@TransactUsername		NVARCHAR(255)	= ''
		,@ProcedureName			NVARCHAR(255)	= ''
		,@ParameterString		NVARCHAR(MAX)	= ''
		,@ReturnCode			BIGINT			= 0
		,@SQL					NVARCHAR(MAX)	='';


DECLARE MyCursor CURSOR LOCAL FOR
	
	-- Collect the needed API Events	
	SELECT 
		 SQLSystemUser
		,UserName
		,TransactUsername
		,ProcedureName
		,ParameterString
		,ReturnCode

	FROM DataFactory_BFW_2017_Last.dbo.sx_pf_API_Log 
	WHERE 
			LogKey >= @FirstLogKeyToImport 
		AND LogKey <= @LastLogKeyToImport 
		AND SQLSystemUser <> 'sys.pf'
		AND SQLSystemUser <> 'DBFW01\saxess'
		AND ProcedureName LIKE 'sx_pf_POST%'
		AND ProcedureName NOT LIKE 'sx_pf_POST_Statement'
		AND ProcedureName NOT LIKE 'sx_pf_POST_Right%'
		AND (
			RIGHT(Parameterstring, LEN(ParameterString) - CHARINDEX(',',ParameterString,10)) LIKE '''5%' 
		    OR 
			RIGHT(Parameterstring, LEN(ParameterString) - CHARINDEX(',',ParameterString,10)) LIKE '''4%' 
			)
	
	ORDER BY Logkey
		
OPEN MyCursor
	
	FETCH MyCursor INTO  @SQLSystemuser		
						,@Username			
						,@TransactUsername	
						,@ProcedureName		
						,@ParameterString	
						,@ReturnCode		

	WHILE @@FETCH_STATUS = 0
		BEGIN
				-- write an IF statement for evey needed Procedure

				IF @ProcedureName = 'sx_pf_POST_ProductDataTableValues'
					BEGIN
						SET @SQL = 'EXEC dbo.sx_pf_POST_ProductDataTableValues ' + @ParameterString
						EXEC (@SQL)

					END

				IF @ProcedureName = 'sx_pf_POST_Product'
					BEGIN
						SET @SQL = 'EXEC dbo.sx_pf_POST_Product ' + @ParameterString
						EXEC (@SQL)

					END


				FETCH MyCursor INTO  @SQLSystemuser		
									,@Username			
									,@TransactUsername	
									,@ProcedureName		
									,@ParameterString	
									,@ReturnCode		
		END
CLOSE MyCursor
DEALLOCATE MyCursor

