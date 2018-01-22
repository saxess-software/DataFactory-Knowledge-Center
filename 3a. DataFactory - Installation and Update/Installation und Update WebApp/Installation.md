

## Variante A: Installation als Stand-alone Service
* Domänenuser FactoryService anlegen

* Installationsdatei ausführen
* im schwarzen cmd Dialog User FactoryService MIT DOMÄNDE angeben (Domäne\User) und Passwort
* jetzt muss der Dienst unter http://localhost:5000 erreichbar sein

* Datei appsettings.json anpassen
    * Connection zum SQL Server setzen
      * Server=myServer;Trusted_Connection=True;  (Normalfall, der FactoryService greift per WinAuth auf die DB zu)
      * Server=myServerAddress;User Id=myUsername;Password=myPassword; (Alternativ, der FactoryService greift per SQL Auth auf die DB zu)
    
    * Windows-Auth True/False (das bedeutet für die User)
    * ggf. Farben und Schaltflächen an / aus
    
    

* Dienst DataFactoryService neu starten
* jetzt muss der Dienst unter http://localhost:5000/ClusterName erreichbar sein
* in admin-cmd "netsh http add urlacl url="http://*:5000/" user=..." für den User unter welchem der Serive läuft angeben
* jetzt muss der Dienst unter http://[IP oder Rechnername]:5000/ClusterName erreichbar sein
* eigene Bilder im Ordner wwwroot\content\images ablegen (diesen Pfad ggf. schaffen)
* Logo für Applikation ablegen unter wwwroot\assets\images

### Vor Update

* Kopie von Datei appsettings.json als appsettings.user.json benennen


## Variante B: Installation auf IIS