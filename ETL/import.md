#### Formats 

Staging Fields in Datetime
* For Globalattributes - change nvarchar with empty if not existing (1900)
```` SQL
IIF(Year([DatatimeColumn]=1900,'',Convert(nvarchar,[DatatimeColumn],104))
````

* to filter Dates, keep handling of empty dates in mind
```` SQL
AND (austrittsdatum >= DATEFROMPARTS(@Jahr, @Monat,1) OR Year(austrittsdatum) = 1900)
````
