#### Formats 

Staging Fields in Datetime
* For Globalattributes - change nvarchar with empty if not existing (1900)
```` SQL
IIF(Year([DatatimeColumn],'',Convert(nvarchar,[DatatimeColumn],104))
````
