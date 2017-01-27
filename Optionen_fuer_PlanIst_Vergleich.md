# Optionen für die Abbildung von Plan-Ist Vergleichen in DataFactory

Ist Werte des Rechnungswesens liegen meist in der Gliederung als Wert pro:
* Mandant
* Sachkonto
* Kostenstelle
* Kostenträger
* Jahr
* Monat

vor, sie passen daher meist nicht direkt zur DataFactory Struktur

# Im Product
* Spalte(n) für Plan Werte
* Spalte für Ist Wert

# Als eigene Productline / Factory 
* ein Product Kontenplan mit allen Sachkonten und den Ist Werten
* ein Product pro Sachkonto
* Kostenstellen als Productlines
  * eine Product pro Sachkonto in dieser Kostenstelle etc.
  
# Nur in Abfrage
* Abfrage liest DataFactory Werte als Datenart Plan
* Abfrage liest Integrator Werte als Datenart Ist
* beides wird per Union verbunden
 
 
