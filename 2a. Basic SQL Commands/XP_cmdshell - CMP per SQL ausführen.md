
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
