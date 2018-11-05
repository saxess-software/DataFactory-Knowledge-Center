
/*
Author: 	Mandy Hauck 
Created: 	2018/10
Summary:	Roll out specified template from Factory 'ZT' in products based on this template in all Factories except Factory 'ZT'

	EXEC [control].[spRolloutTemplate] 'FTE_VM'
*/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[spRolloutTemplate]') AND type in (N'P',N'PC'))
DROP PROCEDURE [control].[spRolloutTemplate] 
GO

CREATE PROCEDURE [control].[spRolloutTemplate] 
					(		@Username			NVARCHAR(255)	= '',
							@Templates			NVARCHAR(255)	= ''	)
				
AS 
SET NOCOUNT ON

-------------------------------------------------------------------------------------------------------------------
-- ##### VARIABLES ###########
	-- Procedure specific
	DECLARE @TargetFactoryID		NVARCHAR(255)	= ''
	DECLARE @TargetProductLineID	NVARCHAR(255)	= ''
	DECLARE @TargetProductID		NVARCHAR(255)	= ''
	DECLARE @TemplateFactoryID		NVARCHAR(255)	= ''
	DECLARE @TemplateProductlineID	NVARCHAR(255)	= ''
	DECLARE @TemplateProductID		NVARCHAR(255)	= ''

	DECLARE @ToDoListe				AS Table		(	 TargetFactoryID			NVARCHAR(255) NOT NULL
														,TargetProductLineID		NVARCHAR(255) NOT NULL
														,TargetProductID			NVARCHAR(255) NOT NULL
														,TargetProductTemplate		NVARCHAR(255) NOT NULL
														,TemplateFactoryID			NVARCHAR(255) NOT NULL
														,TemplateProductlineID		NVARCHAR(255) NOT NULL
														,TemplateProductID			NVARCHAR(255) NOT NULL
														,TemplateTemplate			NVARCHAR(255) NOT NULL		)
	
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
													+ ISNULL(@ProductLineID	, N'NULL')	+ N''','''
													+ N'''';
													
-------------------------------------------------------------------------------------------------------------------
-- ##### GENERAL CHECKS ###########
BEGIN TRY
	BEGIN TRANSACTION [spProcedureName];
	
	-- Determine transaction user
	SELECT @TransactUsername = dbo.sx_pf_Determine_TransactionUsername (@Username);
	
	IF @TransactUsername  = N'403' 
		BEGIN
			SET @ResultCode = 403;
			RAISERROR('Transaction user don`t exists', 16, 10);
		END;
													
---------------------------------------------------------------------------------------------------------------------
-- #### TEMPORARY TABLES ###############

INSERT INTO @ToDoListe 
	SELECT   dP.FactoryID		AS TargetFactoryID
			,dP.ProductLineID	AS TargetProductLineID
			,dP.ProductID		AS TargetProductID
			,dP.Template		AS TargetProductTemplate
			,dP2.FactoryID		AS TemplateFactoryID
			,dP2.ProductLineID	AS TemplateProductlineID
			,dP2.ProductID		AS TemplateProductID
			,dP2.Template		AS TemplateTemplate
	FROM	sx_pf_dProducts dP
	 INNER JOIN dbo.sx_pf_dProducts dP2 ON dP.Template = dP2.Template
	WHERE   dP.FactoryID NOT IN  ('ZT') 								-- Target factories in which templates must not be updated
		AND dP2.FactoryID = 'ZT'										-- Source factory
		AND	dP2.Template = @Templates 									-- Source template which should be used for rollout

------------------------------------------------------------------------------------------------------------
-- ##### EXECUTE Rollout #######################
DECLARE MyCursor CURSOR FOR
	SELECT   TargetFactoryID		
			,TargetProductLineID	
			,TargetProductID
			,TemplateFactoryID
			,TemplateProductlineID		
			,TemplateProductID					
	FROM @ToDoListe
OPEN MyCursor
FETCH MyCursor INTO @TargetFactoryID,@TargetProductLineID,@TargetProductID,@TemplateFactoryID,@TemplateProductlineID,@TemplateProductID	
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC sx_pf_POST_Template 'SQL', @TargetProductID,@TargetProductLineID,@TargetFactoryID,@TemplateProductID,@TemplateProductLineID,@TemplateFactoryID,0

	SET @EffectedRows = @EffectedRows + 1
      
	FETCH MyCursor INTO @TargetFactoryID,@TargetProductLineID,@TargetProductID,@TemplateFactoryID,@TemplateProductlineID,@TemplateProductID	
END
CLOSE MyCursor
DEALLOCATE MyCursor 


-------------------------------------------------------------------------------------------------------------------
-- ##### COMMIT & API LOG ###########
	SET @ResultCode = 200

	COMMIT TRANSACTION [spProcedureName];
END TRY
	BEGIN CATCH
		DECLARE @Error_state INT = ERROR_STATE();
		SET @Comment = ERROR_MESSAGE();

		ROLLBACK TRANSACTION [spProcedureName];		

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

---------------------------------------------------------------------------------------------------------------------
GO
GRANT EXECUTE ON OBJECT ::[control].[spRolloutTemplate] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[control].[spRolloutTemplate] TO pf_PlanningFactoryService;
GO


