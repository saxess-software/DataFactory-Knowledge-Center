
/*
Table for storing validation informations
Validations can run regualy and can be first writen as 'ToDo' from a LeaderProcess and after execution set to done from 
validation process
DataFactory 4.0
Gerd Tautenhahn for saxess-software gmbh
03/2017
*/


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[control].[tProcessValidation]') AND type in (N'U'))
DROP TABLE [control].[tProcessValidation]
GO

CREATE TABLE control.tProcessValidation
(
    EntryKey BIGINT NOT NULL IDENTITY (1,1), 
	ValidationDate DATE NOT NULL,				-- Day of Validation
	RunNumber BIGINT NOT NULL,					-- Running Number of the Day, if runned more the one time a day
	ProcessGroup NVARCHAR(255) NOT NULL,  
	RuleName NVARCHAR(255) NOT NULL,
	Inititator NVARCHAR(255) NOT NULL,			-- the procedure etc. which did this check
	TargetValue MONEY NOT NULL,
	ActualValue MONEY NOT NULL,
	[Status] NVARCHAR(255) NOT NULL,				-- ToDo, Done, InProcess
	ErrorLevel NVARCHAR(255) NOT NULL,
	[Message] NVARCHAR(MAX) NOT NULL

	CONSTRAINT PK_control_ProcessValidation PRIMARY KEY CLUSTERED (EntryKey)
)
GO
