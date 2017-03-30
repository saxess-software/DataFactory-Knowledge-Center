

````SQL
/*
Table for storing monitoring informations
DataFactory 4.0
Gerd Tautenhahn for saxess-software gmbh
03/2017
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'control.tMonitoring') AND type in (N'U'))
DROP TABLE control.tMonitoring
GO

CREATE TABLE control.tMonitoring
(
    	EntryKey BIGINT NOT NULL IDENTITY (1,1),
	MainGroup NVARCHAR(255) NOT NULL,
	SubGroup NVARCHAR(255) NOT NULL,
	Measure NVARCHAR(255) NOT NULL,
	MonitoringDateTime DATETIME NOT NULL,
  	ValueTyp NVARCHAR(255) NOT NULL, -- INT, STRING, MONEY
	ValueInt BIGINT NOT NULL,
	ValueMoney MONEY NOT NULL,
	ValueString NVARCHAR(255) NOT NULL,
	Message NVARCHAR(MAX)

	CONSTRAINT PK_control_tMonitoring PRIMARY KEY CLUSTERED (EntryKey)
)
GO
````
