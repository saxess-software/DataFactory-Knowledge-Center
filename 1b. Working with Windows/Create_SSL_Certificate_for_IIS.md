### Manual how to install a wildcard SSL certificate on one or more IIS Servers

1. Create on Server a CSR (Certificate Signing Request)
1. dabei als Common Name *.planning-factory.com angeben, nicht die konkrete Subdomain
1. mit diesem CSR ein Zertifikat ausstellen lassen, dabei den privaten Schlüssel sichern (wird aber im Prozess nicht mehr gebraucht)
1. Request der Zertifizierungsstelle bestätigen
1. man erhält eine Zertifikatsdatei, da drin steht -----BEGIN CERTIFICATE----..... bis Ende
1. auf Server 1 im IIS Zertifikatsanforderung abschließen, dabei diese Datei importieren
1. Bindung der Webseite an diese Zertifikat einstellen (443)

### übertragen auf anderen Server
1. Im Zertifikatsspeicher von Windows das Zertifikat als pfx incl. privatem Schlüssel exportieren
2. im IIS von Server 2 das Zertifikat importieren 
3. im IIS von Server 2 die Webseite an das Zertifikat binden
