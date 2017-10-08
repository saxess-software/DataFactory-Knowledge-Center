Um den Webclient mit Zugriff über das Internet zu nutzen müssen Sie den WebServer, welchen DataFactory nutzt im Internet verfügbar machen.
Es gibt folgende Optionen hierfür:

### Sie machen einer Ihrer eigenen Server im Internet erreichbar
Sie können einer Ihrer Server im Internet erreichbar machen. Sie benötigen hierfür einen erfahrenen Administrator, welcher 
Einrichtung und Monitoring übernimmt. Diesen Weg gehen eher größere Firmen mit einer IT Abteilung, die auch andere Applikationen im Web bereitstellen.
Es wird dann meist
* die Firewall konfiguriert
* ggf. ein separater virtueller Server dafür aufgesetzt
* Vulnerability Scans durchgeführt
* eigenes https Zertifikat eingesetzt

#### Sie lassen die Anwendung von uns in der Cloud hosten
Wir können die Anwendung auf einem unsere Cloudserver laufen lassen. 
* das ist schnell eingerichtet
* Sie können auch in unserer Cloud die Applikation in der Testphase laufen lassen und später intern installieren
* Sie können weiter auf Ihre Daten direkt per Datenbankabfragen zugreifen
* https Zertifikate sind immer schon vorhanden
* Sie können sich NICHT auf unseren Server einloggen, oder auf die Daten per SQL Managementstudio zugreifen

#### Sie mieten einen eigenen Cloudserver / Service
Sie können jederzeit einen eigenen Cloudserver mieten, wir geben Ihnen gern Empfehlungen hierzu. Insbesondere auf Mircosoft Azure können Sie sehr schnell
Serverkapazitäten mieten und sehr leistungsfähige und skalierbare Umgebungen nutzen. 
Azure Einrichtungen nehmen wir auch für Sie vor, die Skalierung etc. kann leicht ein Administrator aus Ihrem Haus übernehmen


