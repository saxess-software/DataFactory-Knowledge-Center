#Runbooks to automate database task

### Overview
* they take the role an SQL Agent does on a local Server
* they need an automatization account
* one automatization account can have many runbooks - lets say one per customer database
* there are different types of runbook
    * PowerShell
    * PowerShell Workflow
    * Graphical
    * Graphical Workflow
    * Python

* a runbook is mosly a powershell script

* The Workflow must be named the same than the runbook - it is the runbook ?

````Powershell

Workflow AD00487_SternWywiol_Invest_2018
{
    [string] $SqlServer = "datafactory01-sqlserver.database.windows.net"
    
    [int] $SqlServerPort = 1433

    [string] $Database ="AD00487_SternWywiol_Invest_2018"

    [sting] $Procedure = "result.spInvestmentbuchungen 'SQL','SM',''"

    [PSCredential] $SqlCredential = Get-AutomationPSCredential -Name 'RunbookUser'

    # Get the username and password from the SQL Credential
    $SqlUsername = $SqlCredential.UserName
    $SqlPass = $SqlCredential.GetNetworkCredential().Password
    
    inlinescript {

        Write-Output "Server $using:SqlServer";
        Write-Output "Database $using:Database"
        Write-Output "Table $using:Table";
        Write-Output "Username $using:SqlUsername";
        Write-Output "Password $using:SqlPass";

        # Define the connection to the SQL Database
        $Conn = New-Object System.Data.SqlClient.SqlConnection("Server=tcp:$using:SqlServer,$using:SqlServerPort;Database=$using:Database;User ID=$using:SqlUsername;Password=$using:SqlPass;Trusted_Connection=False;Encrypt=True;Connection Timeout=30;")
        
        # Open the SQL connection
        $Conn.Open()

        # Define the SQL command to run

        $Cmd=new-object system.Data.SqlClient.SqlCommand("EXEC $using:Procedure",$Conn)
        $Cmd.CommandTimeout=120

        # Execute the SQL command
        $Ds=New-Object system.Data.DataSet
        $Da=New-Object system.Data.SqlClient.SqlDataAdapter($Cmd)
        [void]$Da.fill($Ds)

        # Output the count
        $Ds.Tables[0].rows.count;
        # The following for test takes very long with many rows
        #$DS.Tables[0].Select();

        # Close the SQL connection
        $Conn.Close()
    }
}
````

### FAQ - Runbook is not running
* try to execute the procedure in Management Studio with the credentials of the runbook user
* did you give the procedure in the runbook all parameters ?


### Other ways
* still an SQL Agent on a local computer can automate azure - just create the azure database as linked server
* you can execute the runbook also as local powershell script - without changes
* create the procedure TestEntry (see downwards) and call it at first in your procedure - to see if your procedure is called

-- Testcall
-- EXEC TestEntry

````SQL
DROP PROCEDURE IF EXISTS dbo.TestEntry;
GO

CREATE PROCEDURE TestEntry

AS

DECLARE @Username			NVARCHAR(255) = 'Test'
DECLARE @TransactUsername	NVARCHAR(255) = 'Test'
DECLARE @ProcedureName		NVARCHAR(255) = 'Test'
DECLARE @Parameterstring	NVARCHAR(255) = 'Test'
DECLARE @EffectedRows		INT = 0
DECLARE @Resultcode			INT = 0
DECLARE @Timestampcall		DATETIME = GETDATE()
DECLARE @Comment			NVARCHAR(255) = 'Test'

EXEC dbo.sx_pf_pPOST_API_LogEntry @Username, @TransactUsername, @ProcedureName, @ParameterString, @EffectedRows, @ResultCode, @TimestampCall, @Comment;

RETURN @ResultCode

GO

GRANT EXECUTE ON OBJECT ::TestEntry TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::TestEntry TO pf_PlanningFactoryService;
GO


````