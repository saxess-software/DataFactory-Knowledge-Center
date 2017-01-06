### Clients
* Excel ab Version 2010 (kein Excel für Macintosh unter iOS)
* aktivierte Makros (Signatur möglich)
* Webclient mit allen aktuellen Browsern

## Sofern Entwicklung von Komponenten durch saxess erfolgt:
* Visual Studio Code
* GitHub Desktop
* Notepad++ 
* Excel auf Server oder anderem PC mit Fernzugriff
* Sysadmin Rechte auf SQL Server (für Konfiguration SQL Server Agent, Debugger, Profiler)


Cloudversion

* keine Installation
* Zugriff mit Excel und Webclient von jedem PC mit Internetzugang

* eigene Datenbank auf unserem Webserver
* Datendownload jederzeit als CSV Datei möglich
* tägliche Bereitstellung eines Datenbankbackups möglich


Einzelplatzinstallation

* SQL Server 2012 Express oder höher
* aktiviertes TCP/IP Protokoll auf SQL Server
* Excel


Lokales Netzwerk mit Excel Clients
* zentraler Server mit SQL Server 2012 Express oder höher
* aktiviertes TCP/IP Protokoll auf SQL Server
* Excel auf PCs oder auf Terminalserver


Lokales Netzwerk mit Excel und Webclients
* Windows 2012 R2 Server
	* aktivierter Rolle IIS
	* aktivierte Windows Authentifizierung (falls User per Windows Login) oder 
	  Internetzugang, wenn User per OAuth mit User / PW authentifiziert werden

* zentraler Server mit SQL Server 2012 Express oder höher
	* Windows Benutzer für IIS zum Datenbankzugriff oder
	* gemischter Modus mit SQL Auth für IIS Zugriff per User/PW
	* aktiviertes TCP/IP Protokoll auf SQL Server




Installation auf Webserver im Internet

* SHA-2 256 Bit Zertifikat
* Windows Benutzer für IIS Server (kein Admininistrator)
* Windows Benutzer auf SQL Server nur dbowner Rolle, kein sysadmin


Eigener Hosting Betrieb
* Powershell
