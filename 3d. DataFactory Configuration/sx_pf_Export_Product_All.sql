/* Procedure to export all products 
by call [sx_pf_Export_Product] for each

This procedure works NOT on Azure Databases

This Procedure has no transaction, as it calls an other public procedure

Dependencies:
	- Functions: 
		- sx_pf_pProtectString
		- sx_pf_Determine_TransactionUsername
	 - Stored Procedures:
		- sx_pf_pPOST_API_LogEntry
	 - System 
		- sp_executesql
		- xp_cmdshell (be sure that server configurated correctly https://msdn.microsoft.com/en-US/library/ms175046.aspx) 
		- sp_configure
		- bcp utility

Planning Factory 4.0
02/2017 Gerd Tautenhahn for saxess-software gmbh

Test Call:
EXEC sx_pf_Export_Product_All 'SQL','d:\tmp\exportall', 1
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[sx_pf_EXPORT_Product_All]') AND type in (N'P', N'PC'))
DROP PROCEDURE [sx_pf_EXPORT_Product_All]
GO
 
CREATE  PROCEDURE [sx_pf_EXPORT_Product_All]
		@Username AS NVARCHAR(255),
		@LocalPath AS NVARCHAR(MAX),
		@OutputForSQLServer INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TransactUsername AS NVARCHAR(255);
	DECLARE @ProcedureName AS NVARCHAR (255) = OBJECT_NAME(@@PROCID);
	DECLARE @ParameterString AS NVARCHAR (MAX) = N'''' + ISNULL(@Username, N'NULL') + N''',''' + ISNULL(@LocalPath, N'NULL') 
		+ N''',''' + ISNULL(CAST(@OutputForSQLServer AS NVARCHAR(255)), N'NULL') + N'''';
	DECLARE @EffectedRows AS INT = 0;						-- SET during Execution
	DECLARE @ResultCode AS INT = 501;						-- SET during Execution
	DECLARE @TimestampCall AS DATETIME = CURRENT_TIMESTAMP;
	DECLARE @Comment AS NVARCHAR (2000) = N'';				-- SET during Execution

	DECLARE @products_cursor CURSOR;
	DECLARE @cursorState INT = 0;

	-- STEP 0.1 - NULL Protection
	IF @Username IS NULL SET @Username = ''
	IF @OutputForSQLServer IS NULL SET @OutputForSQLServer = 0
	
	BEGIN TRY
--		BEGIN TRANSACTION ONE;

	-- STEP 0.2 - Protect input parameters
		IF @LocalPath IS NULL
		BEGIN
			SET @ResultCode = 404;
			RAISERROR('Empty input parameters', 16, 10);
		END;
		 
		IF PATINDEX(N'%--%', @LocalPath) > 0
			OR PATINDEX(N'%/*%', @LocalPath) > 0
			OR PATINDEX(N'%*\%', @LocalPath) > 0
			OR PATINDEX(N'%''%', @LocalPath) > 0
		BEGIN
			SET @ResultCode = 404;
			RAISERROR('Invalid input parameters', 16, 10);
		END;

		SET @Username = [dbo].[sx_pf_pProtectString] (@Username);

		 -- STEP 1.1 - Determine transaction user
		SELECT @TransactUsername = [dbo].[sx_pf_Determine_TransactionUsername] (@Username);

		IF @TransactUsername  = N'403' 
		BEGIN
			SET @ResultCode = 403;
			RAISERROR('Transaction user don`t exists', 16, 10);
		END;

		-- STEP 3.1 Prepare products list and filepath
		IF RIGHT(@LocalPath, 1) <> N'\\'
		BEGIN
			SET @LocalPath = @LocalPath + N'\\';
		END;
		
		DECLARE @products AS TABLE (
			FactoryID NVARCHAR(255) NULL
			, ProductLineID NVARCHAR(255) NULL
			, ProductID NVARCHAR(255) NULL
			, [Filename] NVARCHAR(255) NULL
		);

		DECLARE @values AS TABLE (
		  Result NVARCHAR(max) NULL
		);

		IF OBJECT_ID('tempdb..##tmp_ExportAllProducts_Result') IS NULL
		BEGIN
			--DROP TABLE ##tmp_ExportAllProducts_Result;

			CREATE TABLE ##tmp_ExportAllProducts_Result (
				ID UNIQUEIDENTIFIER	NOT NULL
				, Result NVARCHAR(max) NULL
			);
		END;	

		INSERT INTO @products (FactoryID, ProductLineID, ProductID, [Filename])
		SELECT dP.FactoryID
			, dP.ProductLineID
			, dP.ProductID
			, @LocalPath + dP.FactoryID + N'_' + dP.ProductlineID + N'_' + dP.ProductID + N'_' + dP.NameShort + N'.sql'
		FROM [dbo].[sx_pf_dProducts] dP	INNER JOIN [dbo].[sx_pf_vUserRights] vUR
		  	ON dP.FactoryID = vUR.FactoryID 
				AND dP.ProductLineID = vUR.ProductLineID
				AND vUR.UserName = @TransactUsername
				AND vUR.[Right] IN (N'Read', N'Write');
		
		-- STEP 3.2 Export

		DECLARE @sql NVARCHAR(MAX)
		DECLARE @id NVARCHAR(MAX) = NEWID();
		DECLARE @FactoryID AS NVARCHAR(255), @ProductLineID AS NVARCHAR(255), @ProductID AS NVARCHAR(255)

		EXEC master.dbo.sp_configure 'show advanced options', 1
		RECONFIGURE
		EXEC master.dbo.sp_configure 'xp_cmdshell', 1
		RECONFIGURE 

		SET @products_cursor = CURSOR LOCAL FAST_FORWARD FOR   
		SELECT FactoryID, ProductLineID, ProductID
			, N'xp_cmdshell ''bcp "SELECT Result FROM ##tmp_ExportAllProducts_Result WHERE ID = N''''' + @id + N'''''" queryout "' + [Filename] + N'" -w -T'', NO_OUTPUT'  
		FROM @products;  
  		SET @cursorState = 1;

		OPEN @products_cursor;  
  		SET @cursorState = 2;

		FETCH NEXT FROM @products_cursor   
		INTO @FactoryID, @ProductLineID, @ProductID, @sql;  
  		
		WHILE @@FETCH_STATUS = 0  
		BEGIN  
   			INSERT INTO @values
			EXEC [dbo].[sx_pf_EXPORT_Product] @Username, @FactoryID, @ProductLineID, @ProductID, @OutputForSQLServer;			

			IF EXISTS(SELECT 1 FROM @values)
			BEGIN
				INSERT INTO ##tmp_ExportAllProducts_Result (ID, Result)
				SELECT @id, Result
				FROM @Values;

				EXEC sp_executesql @sql;

				DELETE FROM @Values; 
				DELETE FROM ##tmp_ExportAllProducts_Result
				WHERE ID = @id;
			END;
    		FETCH NEXT FROM @products_cursor   
			INTO @FactoryID, @ProductLineID, @ProductID, @sql;   
		END;
		 
		SET @ResultCode = 200;

	--	COMMIT TRANSACTION ONE;
	END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();
	 
	--	ROLLBACK TRANSACTION ONE;		

		IF @Error_state <> 10 BEGIN
			SET @ResultCode = 500;
			PRINT 'Rollback due to not executable command' + ISNULL(': '+ @Comment, '.');
		END
		ELSE IF @ResultCode IS NULL OR @ResultCode/100 = 2
		BEGIN
			SET @ResultCode = 500;	
		END;
	END CATCH

	EXEC master.dbo.sp_configure 'show advanced options', 1
	RECONFIGURE
	EXEC master.dbo.sp_configure 'xp_cmdshell', 0
	RECONFIGURE 

	IF @cursorState > 0 
	BEGIN
		IF @cursorState > 1 CLOSE @products_cursor; 
	 
		DEALLOCATE @products_cursor;  
	END;
	
	EXEC [dbo].[sx_pf_pPOST_API_LogEntry] @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;
	RETURN @ResultCode;
END
GO

  
GRANT EXECUTE ON OBJECT ::[dbo].[sx_pf_Export_Product_All] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[dbo].[sx_pf_Export_Product_All] TO pf_PlanningFactoryService;
GO



	