## Informationen zu DataFactory für Systemadministratoren
### Überblick
DataFactory ist eine Client-Server Applikation auf Basis von Microsoft SQL Server und .NET Komponenten. DataFactory ermöglicht die Erfassung von Daten zur Unternehmensplanung und Organisation verschiedener Fachbereiche. Zumeist erfolgt die Erfassung von Daten für viele operative Bereiche, so das größere Benutzerzahlen zu erwarten sind.

Das System erlaubt über ERP Schnittstellen etc. eine Vielzahl von Automatisierungsprozessen zu vor- oder nachgelagerten Systemen.

Bei den Benutzern unterscheiden wir
- Poweruser (mit Design- und Strukturbearbeitungsrechten) 
- Datenerfasser. 
Die Poweruser kommen meist aus der Controlling- oder IT Abteilung. 



DataFactory nutzt zum Betrieb folgende serverseitigen Kompoenten:
- eine SQL Server Datenbank Version 2012+
- einen eigenen Webserver 

Die Clients der Poweruser benötigen:
- Excel 2013+ zum starten des Excel Clients
- aktueller Webbrowser

Die Clients der Datenerfasser benötigen:
- aktueller WebbrowserBrowser

Der Excel Client ist als "Portable Software" erstellt. Es ist somit keinerlei Installation auf Clients notwendig, der Excel Client benötigt keine Adminrechte und kann auch von einem Netzlauf etc. gestartet werden. 
Das System kann im Intranet betrieben werden werden oder mit https Absicherung etc. auch im Internet. Auch eine Installation oder Bereitstellung auf Micrsoft Azure als Plattform as a Service Applikation ist möglich.




### Systemvoraussetzungen Server:
		
		
- SQL Server 2012 oder höher. Wir empfehlen: 
  - bis zu 10 Benutzer Microsoft SQL Server Express
  - bis zu 2.000 Benutzer Microsoft SQL Server Standard
  
- Empfehlung bei Lizenzverfügbarkeit: SQL Server 2017 Enterprise
- Windows 2012 R2 Server 
- Admin Rechte auf dem SQL Server für die Nutzung von SQL Agent, SQL Profiler, SQL Debugger
- Empfehlung: SSD Festplatten für Datenlaufwerke des Servers
- Empfehlung: Xeon Prozessor 4 Cores
- Speicherplatz tempdb: 10 GB
- Speicherplatz Datenfiles: 50 GB
- Speicherplatz Logfiles: 20 GB
- Speicherplatz Backups: 200 GB
- Remotezugang auf Server per RDP über VPN, TeamViewer o.ä.
- Internet auf Server verfügbar

### Systemvoraussetzungen Clients:
		
- Aktueller Webbrowser
- Excel 2013 oder höher
- Benutzer dürfen Makros im Excel ausführen 
- Makros können mit Organisationszertifikat digital signiert werden um nur diese in der Organisation zu genehmigen

### Rechtebedarf:
		
- Domänenbenutzer mit lokalen Administratorrechten auf DataFactory Server
- Lesender Zugang auf alle Vorsystemdatenbanken

### Weitere Voraussetzungen:
- Entpackersoftware, z.B. 7zip
- GitHub Desktop (OpenSource Software)

