* new queries opened by "new query" in SSMS are not UTF-8 without BOM by default 

* it is possible to save the template for the new query with the correct encoding:
  * SQL Server 14: "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\SqlWorkbenchProjectItems\Sql\SQLFile.sql"
  * SQL Server 12: "C:\Program Files (x86)\Microsoft SQL Server\120\Tools\Binn\ManagementStudio\SqlWorkbenchProjectItems\Sql\SQLFile.sql"
  
  &nbsp;
  
* open the SQLFile.sql with Notepad and change the encoding to UTF-8 without BOM (admin rights needed)





