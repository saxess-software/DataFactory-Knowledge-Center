

## Variante A: Installation als Stand-alone Service
* Domänenuser FactoryService anlegen

* Installationsdatei ausführen
* im schwarzen cmd Dialog User FactoryService angeben (Domäne\User) und Passwort

* Datei appsettings.json anpassen
    * Connection zum SQL Server setzen
      * Server=myServer;Trusted_Connection=True;  (Normalfall, der FactoryService greift per WinAuth auf die DB zu)
      * Server=myServerAddress;User Id=myUsername;Password=myPassword; (Alternativ, der FactoryService greift per SQL Auth auf die DB zu)
    * Windows-Auth True/False (das bedeutet für die User)
    * ggf. Farben und Schaltflächen an / aus

* Dienst DataFactoryService neu starten

### Vor Update

* Kopie von Datei appsettings.json als appsettings.user.json benennen


## Variante B: Installation auf IIS
