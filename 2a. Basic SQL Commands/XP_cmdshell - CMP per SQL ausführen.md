
Man kann per SQL ein CMD Kommando ausführen. Dafür müssen
  * die erweiterten Server Optionen aktiviert werden
  * cmdshell aktiviert werden
  
Diese Dinge einschalten können nur SQL sysadmins. Es ist nicht ganz ungefährlich, weil über CMD kann man fast alles tun auf einem PC. 
CMD wird wahrscheinlich mit den Rechten des SQL Server User aufgerufen, oder mit den Rechten des SQL Server Dienstes bei Ausführung über Taskplan


```` SQL
EXEC sp_configure 'show advanced options', 1

RECONFIGURE

EXEC sp_configure'xp_cmdshell', 1  

RECONFIGURE

xp_cmdshell 'whoami.exe'
````

Beispielaufruf SXI bat Die bat Datei muss absolute Pfade enthalten. 

```` SQL

xp_cmdshell 'C:\Saxess\SXIntegrator\pentaho\Personalplanung.bat'

````

Der bessere kann aber oft noch sein per SQL Server in das Windows Eventlog zu schreiben. Dieser kann direkt einen Task im Taskscheduler mit dort hinterlegten Rechten auslösen.
Hier ist das beschrieben:
[Trigger Task over Eventlog](https://github.com/saxess-software/DataFactory-Knowledge-Center/blob/master/2b.%20Basic%20SQL%20Server%20Knowledge/Trigger%20task%20scheduler%20event%20via%20SQL%20stored%20procedure.md)
