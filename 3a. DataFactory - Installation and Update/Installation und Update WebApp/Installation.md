

### Vorbereitungen
* Windows User "FactoryService" anlegen und Passwort dokumentieren - als lokaler User auf TestPCs, als Domänenuser bei Multiuserbetrieb
* DataFactory Cluster auf API 4.0.74+ updaten
* Windows User "FactoryService" auf dem SQL Server als User anlegen und in den DataFactory Datenbanken die Rolle "pf_PlanningFactoryService" geben
* Login als Admin auf dem Server, welcher als DF Webserver dient

* Kompatibilätsmodus für IE im Intranet deaktivieren (auf jedem User PC)
* Windows Auth im Firefox freischalten (auf jedem User PC, sonst Dialogbox)


### Installation
* Installationsdatei ausführen
* im schwarzen cmd Dialog User FactoryService MIT DOMÄNDE angeben (Domäne\User) und Passwort
* jetzt muss der Dienst unter http://localhost:5000 erreichbar sein

### Test auf Installationsserver 
*  zunächst muss der Dienst unter http://localhost:5000 erreichbar sein 
** im IE müsste das sofort gehen
** im Firefox muss das (mit Login Dialog) auch möglich sein (WinAuth im Firefox muss erst freigeschalten werden)

* jetzt muss das Cluster unter http://localhost:5000/ClusterName erreichbar sein
* jetzt muss das Cluster unter http://[IP oder Servername]:5000/ClusterName erreichbar sein 
** von diesem Server
** von den PCs 

### Bei manueller Configuration

* die Detailanleitung im WebApp Repo lesen

* Datei appsettings.json anpassen
    * Connection zum SQL Server setzen
      * Server=myServer;Trusted_Connection=True;  (Normalfall, der FactoryService greift per WinAuth auf die DB zu)
      * Server=myServerAddress;User Id=myUsername;Password=myPassword; (Alternativ, der FactoryService greift per SQL Auth auf die DB zu)
    
    * Windows-Auth True/False (das bedeutet für die User)
    * ggf. Farben und Schaltflächen an / aus

* eigene Bilder im Ordner wwwroot\content\images ablegen (diesen Pfad ggf. schaffen)
* Logo für Applikation ablegen unter wwwroot\assets\images
* Internetexplorer darf nicht in den Kompatibilitätsmodus gehen für Intranet etc. (Option deaktivieren)
* damit Firefox mit WindowsAuth SSO arbeitet -> about:config -> Suche nach "Trusted" -> URL des Server bei *.trusted-uris hinterlegen (mehrere Einträge mit Komma trennen, z.B. "http:localhost, http://DR74"

* Dienst DataFactoryService neu starten

### falls das Dienstkonto des DataFactoryService geändert wird, muss die URL wieder freigegben werden

* in admin-cmd "netsh http add urlacl url="http://*:5000/" user=..." für den User unter welchem der Serive läuft angeben

* netsh http delete urlacl url=http://*:5000/
* netsh http add urlacl url=https://*:5000/ user=MALTA1350\FactoryService


### Powerloader konfigurieren

* URLs um zweite URL für Powerloader erweitern: "Urls": "https://*:443;http://*:4000"

* Festen User für Powerloader zuweisen    "PowerLoaderUser": "AD-ONE\\slindenl"
    
* mit netsh http show urlacl prüfen ob Powerloader URL registriert ist (muss für richtigen User = FactoryService registriert sein)

* ggf. löschen: netsh http delete urlacl url="http://*:4000/"

* anlegen: netsh http add urlacl url="http://*:4000/" user="MyDomain\MyUsername"


### Bindung an SSL Zertifikat
* Liste der exitierenden Zertifikate anzeigen (Powershell): dir cert:\localmachine\my

* eine GUID generieren https://www.guidgen.com/
* in CMD mit GUID und Cert Thumbprint registieren

* netsh http add sslcert hostnameport=Hostname:Port certhash=CertHash_Here appid={f4eb66b6-c8ac-4b71-aa9c-5dbd310c27c6} certstore=my

* netsh http add sslcert hostnameport=saxess1.planning-factory.com:5000 certhash=0B14B6E3A23E0B717970724734E4224F182BAA02 appid={f4eb66b6-c8ac-4b71-aa9c-5dbd310c27c6} certstore=my

* ggf. vorher vorhandene Bindung lösen: netsh http delete sslcert hostnameport=saxess1.planning-factory.com:5000

### SSL Sicherheitskonfiguration vornehmen

* URL scannen mit http://ssl-checker.online-domain-tools.com/
* schwache ssl Protokolle und ciphers auschalten https://www.nartac.com/Products/IISCrypto


