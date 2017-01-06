# DataFactory - Options for Installation 

## Overview
DataFactory uses Microsoft SQL Server 2012 as core component. In small environments and for development its possible to use the system just as database with Excel as Client. In bigger environments you can add the IIS based Web Components to access the system over the webclient.

### Database
As Database we can use any edition of Microsoft SQL Server 2012 or higher. We recommend
* up to 20 User Microsoft SQL Server Express
* up to 2.000 Users Microsoft SQL Server Standard
* above 2.000 User Microsoft SQL Enterprise 2016 (for using In-Memory-OLTP Technology)

### Clients
All Clients are free of installation, we can use:
* Excel from version 2010 (but no Excel for Macintosh, makros must be activateable)
* any current Webbrowser 


## Cloudversion
Its the easiest way, you can use DataFactory without an own database, we will provide you with your own database on our cloudserver.
* no installation necessary
* you can use DataFactory with Excel (portable client) or the webbrowser from every computer with internt access
* the first time, you must create an online account at www.plannning-factory.com for authentication
* even the data are located in our cloud you can access them easy for backup and local usage
	* you can downlaod your data anytime as CSV file or connect to your database direct with Excel PowerQuery
	* we can provide you daily with an backup of your database


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




Private Cloud

* SHA-2 256 Bit Zertifikat
* Windows Benutzer für IIS Server (kein Admininistrator)
* Windows Benutzer auf SQL Server nur dbowner Rolle, kein sysadmin


Eigener Hosting Betrieb
* Powershell




## Sofern Entwicklung von Komponenten durch saxess erfolgt:
* Visual Studio Code
* GitHub Desktop
* Notepad++ 
* Excel auf Server oder anderem PC mit Fernzugriff
* Sysadmin Rechte auf SQL Server (für Konfiguration SQL Server Agent, Debugger, Profiler)
