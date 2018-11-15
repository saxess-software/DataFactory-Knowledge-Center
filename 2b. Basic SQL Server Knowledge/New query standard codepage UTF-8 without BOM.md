- new queries opened by "new query" in SSMS are not UTF-8 without BOM by default 
- it is possible to save the template for the new query with the correct encoding: C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\SqlWorkbenchProjectItems\Sql\SQLFile.sql
(C:\Program Files (x86)\Microsoft SQL Server\120\Tools\Binn\ManagementStudio\SqlWorkbenchProjectItems\Sql\SQLFile.sql  for SQLServer 12)
- open the SQLFile.sql with Notepad (as admin) and change the encoding

- in some cases it is also necessary to change the settings of SSMS (Extras --> Optionen --> Text-Editor --> Allgemein): remove check mark from "UTF-8-Codierung ohne Signatur automatisch erkennen"

![this](UTF-8 ohne BOM.png)