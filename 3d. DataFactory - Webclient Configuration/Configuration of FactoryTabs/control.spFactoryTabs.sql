
/*
Author: 	Heathcliff Power
Created: 	2018/11
Summary:	Define FactoryTabs in WebClient
	EXEC [control].[spFactoryTabs] 'SQL'
	SELECT * FROM dbo.sx_pf_gFactories
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[spFactoryTabs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [control].[spFactoryTabs]
GO

CREATE PROCEDURE [control].[spFactoryTabs]		
					(		@Username			NVARCHAR(255),
							@FactoryID			NVARCHAR(255)		)
AS
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
	-- Procedure specific
	DECLARE @TabID					NVARCHAR(255)	= ''
	DECLARE @Label					NVARCHAR(255)	= ''
	DECLARE @CommentUser			NVARCHAR(MAX)	= ''
	DECLARE @PresentationType		NVARCHAR(255)	= ''	
	DECLARE @Source					NVARCHAR(MAX)	= ''		
	DECLARE @Layout					NVARCHAR(MAX)	= ''

	DECLARE @RC						BIGINT			= 501
	
	-- API log
	DECLARE @TransactUsername		NVARCHAR(255)	= N'';
	DECLARE @ProcedureName			NVARCHAR(255)	= OBJECT_SCHEMA_NAME(@@PROCID) + N'.' + OBJECT_NAME(@@PROCID);
	DECLARE @EffectedRows			INT 			= 0;						
	DECLARE @ResultCode				INT 			= 501;						
	DECLARE @TimestampCall			DATETIME 		= CURRENT_TIMESTAMP;
	DECLARE @Comment				NVARCHAR(2000) 	= N'';
	DECLARE @ParameterString		NVARCHAR(MAX)	= N''''
													+ ISNULL(@Username		, N'NULL')	+ N''','''	
													+ ISNULL(@FactoryID		, N'NULL')	+ N''','''	
													+ N'''';
													
-------------------------------------------------------------------------------------------------------------------
-- ##### GENERAL CHECKS ###########
BEGIN TRY
	BEGIN TRANSACTION [spFactoryTabs];
	
	-- Determine transaction user
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);
	
	IF @TransactUsername  = N'403' 
		BEGIN
			SET @ResultCode = 403;
			RAISERROR('Transaction user don`t exists', 16, 10);
		END;

-------------------------------------------------------------------------------------------------------------------
-- ##### DELETE ###########

	-- Project specific FactoryTabs
		DECLARE MyCursor CURSOR FOR

			SELECT dF.FactoryID 
			FROM dbo.sx_pf_dFactories dF 
			WHERE dF.FactoryID <> 'ZT'

		OPEN MyCursor
		FETCH MyCursor INTO @FactoryID
		WHILE @@FETCH_STATUS = 0
			BEGIN




			FETCH MyCursor INTO @FactoryID
			END
		CLOSE MyCursor
		DEALLOCATE MyCursor


	-- Standard FactoryTabs for Factory 'ZT'
		SET @FactoryID			= 'ZT' 

		-- Factory Tab 'Startseite der Factory'
			SET @TabID				= 'Tab_01'
			SET @Label				= 'Übersicht'
			SET @CommentUser		= 'Übersicht der verfügbaren Inhalten in Factory ZT'
			SET @PresentationType	= 'HTML'	
			SET @Source				= '<#NV>'		
			SET @Layout				= '' 

				EXECUTE @RC = dbo.sx_pf_POST_FactoryTab @Username,@FactoryID,@TabID,@Label,@CommentUser,@PresentationType,@Source,@Layout


		-- Factory Tab 'SystemFailureReport'
			SET @TabID				= 'Tab_02'
			SET @Label				= 'Systemfehler (MQT)'
			SET @CommentUser		= 'Übersicht der Systemfehler beim letzten Testlauf im Datenmodell - aktualisieren durch Prozedurausführung control.spSystemFailureReport. Letzte 14 Tage des Report in Datenbank abrufbar.'
			SET @PresentationType	= 'HTML_Static'	
			SET @Source				= 'sx_pf_GET_Info_SystemFailureReport'		
			SET @Layout				= '' 

				EXECUTE @RC = dbo.sx_pf_POST_FactoryTab @Username,@FactoryID,@TabID,@Label,@CommentUser,@PresentationType,@Source,@Layout


		-- Factory Tab 'UserFailureReport'
			SET @TabID				= 'Tab_03'
			SET @Label				= 'Anwenderfehler (MQT)'
			SET @CommentUser		= 'Übersicht der Anwenderfehler beim letzten Testlauf im Datenmodell - aktualisieren durch Prozedurausführung control.spCustomFailureReport. Letzte 14 Tage des Report in Datenbank abrufbar.'
			SET @PresentationType	= 'HTML_Static'	
			SET @Source				= 'sx_pf_GET_Info_CustomFailureReport'		
			SET @Layout				= '' 

				EXECUTE @RC = dbo.sx_pf_POST_FactoryTab @Username,@FactoryID,@TabID,@Label,@CommentUser,@PresentationType,@Source,@Layout


		-- Factory Tab 'DataFactoryStructureInformation'
			SET @TabID				= 'Tab_04'
			SET @Label				= 'Clusterstatistik (Live)'
			SET @CommentUser		= 'Übersicht der Objekte im Cluster'
			SET @PresentationType	= 'HTML_Static'	
			SET @Source				= 'result.spHTML_ClusterStatistik'		
			SET @Layout				= '' 

				EXECUTE @RC = dbo.sx_pf_POST_FactoryTab @Username,@FactoryID,@TabID,@Label,@CommentUser,@PresentationType,@Source,@Layout


		-- Factory Tab 'PerformanceMonitoring'
			SET @TabID				= 'Tab_05'
			SET @Label				= 'Performance (Live)'
			SET @CommentUser		= 'Übersicht der Datenbankzugriffe.'
			SET @PresentationType	= 'Pivot'	
			SET @Source				= ''		
			SET @Layout				= '' 

				EXECUTE @RC = dbo.sx_pf_POST_FactoryTab @Username,@FactoryID,@TabID,@Label,@CommentUser,@PresentationType,@Source,@Layout


		-- Factory Tab 'UserRightsMonitoring'
			SET @TabID				= 'Tab_06'
			SET @Label				= 'Rechteübersicht (Live)'
			SET @CommentUser		= 'Übersicht der Benutzerrechte'
			SET @PresentationType	= 'Pivot'	
			SET @Source				= 'sx_pf_GET_Info_Userrights'		
			SET @Layout				= '' 

				EXECUTE @RC = dbo.sx_pf_POST_FactoryTab @Username,@FactoryID,@TabID,@Label,@CommentUser,@PresentationType,@Source,@Layout





-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode = 200

	COMMIT TRANSACTION [spFactoryTabs];
END TRY
BEGIN CATCH
	DECLARE @Error_state INT = ERROR_STATE();
	SET @Comment = ERROR_MESSAGE();

	ROLLBACK TRANSACTION [spFactoryTabs];		

	IF @Error_state <> 10
	BEGIN
		SET @ResultCode = 500;		
		PRINT 'Rollback due to not executable command.';
	END
	ELSE IF @ResultCode IS NULL OR @ResultCode/100 = 2
	BEGIN
		SET @ResultCode = 500;	
	END;
END CATCH

EXEC dbo.sx_pf_pPOST_API_LogEntry @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;

RETURN @ResultCode;

-------------------------------------------------------------------------------------------------------------------
GO
GRANT EXECUTE ON OBJECT ::[control].[spFactoryTabs]  TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[control].[spFactoryTabs]  TO pf_PlanningFactoryService;
GO


