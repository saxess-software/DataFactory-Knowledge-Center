Direktes DELETE auf einzelner Tabelle

````SQL
DELETE 
FROM Mitarbeiter
WHERE Nachname = 'Beyer'
````

DELETE mit JOIN zweier Tabellen

````SQL
DELETE fV 
FROM dbo.sx_pf_fValues fV
	LEFT JOIN sx_pf_dValueSeries dVS
		ON fV.ValueSeriesKey = dVS.ValueSeriesKey
WHERE dVS.ValueSource = 'XLS-Strict'

````

Wenn man alle Zeilen einer Tabelle löschen möchte ist TRUNCATE TABLE die bessere Wahl. Dafür braucht man aber ALTER Berechtigungen auf der Tabelle, 
DELETE Rechte reichen nicht.
