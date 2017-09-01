## Basisinformationen
* Die Lizenz für die Komponente CPCE muss vorhanden sein

* Der Drilldown kann nur in eine Datenbank vom Typ CPCE erfolgen. Es kann aber eine beliebige Datenbank als CPCE Datenbank genutzt werden, solange diese die spezifischen Prozeduren enthält.

* es muss eine Importdefinition vom Typ CPCE angelegt sein, die Werte müssen aber nicht über diese Prozedur importiert worden sein

* Der Drilldown ist nur von einem Feld auf unterster Ebene möglich, nie von einem Summenfeld

* Der Strukturaufbau kann beliebig erfolgen, solange das korrekte Schlüsselsystem erzeugt wird.

* Die Daten können beliebig eingelesen werden, nur der Schlüssel des Feldes entscheidet, ob der Drilldown ausgeführt wird und der Menüpunkt erscheint

* Der Feldschlüssel muss vom Ty CL []... | CC [...]| CT [...] oder CL []... | CU [...]| CT [...] sein 

## Importprozedur

* pCP_SelectValuesKore 
    * @CompanyCode = Buchungskreis
    * @ClientID = Mandantennummer
    * @PeriodFrom / @PeriodTo


## Drilldown Befehlsausführung

* pCP_DrilldownKore
    * @ClientID = Mandantennummer = CL Teil vom Schlüssel
    * @CompanyCode = Buchungskreis
    * @CostTyp = Kostenart = CT Teil vom Schlüssel
    * @CoreTypID = Kostenstelle/Kostenträger = CC oder CU Teil vom Schlüssel
    * @PeriodFrom / @PeriodTo = Zeitschieber
    * @KoreTyp = Kostenstelle oder KostenträgerFlag = 0 > CC Teil / 1 = CU Teil

* Die Werte des Summenzeile des Drilldowns werden über ein zweites Resultset der Prozedur übergeben
 
* Der Drilldown Befehl ruft die erste, für diese Feld oder ein Oberelement existierende Importdefinition vom Typ CPCE auf, dieser wird der Parameter @CompanyCode entnommen

* Die Datenebene wird im Drilldown NICHT als Parameter mit übergeben - kann somit nicht unterschieden werden 

## Best Practice für Drilldown im DataFactory Kontext
* für den Import wird eine Datentabelle mit verschiedenen Datengruppen angelegt (z.B. Actuals, 3MonatsForecast, Orderbook, Pipeline)
* verschiedene (beliebige) Importe importieren diese Daten auf Felder und passende Ebenen (da ein Import nur eine Ebene laden kann)
* eine Importprozedur vom CPCE mit @CompanyCode = "DF" muss angelegt sein
* der Drilldown zeigt alle Datengruppen (aller Ebenen) an, in der Datentabelle sollten nur die Daten vorhanden sein, welche zu den aktuellen Importen passen (keine historischen Forecastdaten etc.)




## Gerüchte

* eine CP Version, welche mehrere Importdefinitionen auswerten kann soll im Bau (erhältlich sein ?)




