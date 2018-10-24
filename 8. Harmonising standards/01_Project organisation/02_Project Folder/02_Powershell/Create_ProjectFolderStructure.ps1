# Create the basic folder structure for a german project
# unfortunately you can't publish empty folders in Github, thats why you see Dummy files in empty folders

# CONFIGURATION ######################################################################

# Nothing to do, there folder structure is created in the folder where the script is executed - just copy the script to the folder
# where you want to create the structure

# if you cant execute this script, open PowerShell as Admin and execute command "Set-ExecutionPolicy RemoteSigned"

#########################################################################

# Project folder sample
New-Item -ItemType directory -Name '01_Projektordner Muster'

# Folder for documentation and customer files
New-Item -ItemType directory -Name '01_Projektordner Muster\01_Projektunterlagen'
New-Item -ItemType directory -Name '01_Projektordner Muster\01_Projektunterlagen\01_Projektdokumentation'
New-Item -ItemType File -Name '01_Projektordner Muster\01_Projektunterlagen\01_Projektdokumentation\dummy.txt'

New-Item -ItemType directory -Name '01_Projektordner Muster\01_Projektunterlagen\02_Kundenunterlagen'
New-Item -ItemType File -Name '01_Projektordner Muster\01_Projektunterlagen\02_Kundenunterlagen\dummy.txt'

# Folder development
## Folder for all SQL files
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung'

New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\01_Permanente Erweiterungstabellen'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\01_Permanente Erweiterungstabellen\01_Staging'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\01_Permanente Erweiterungstabellen\01_Staging\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\01_Permanente Erweiterungstabellen\02_Param'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\01_Permanente Erweiterungstabellen\02_Param\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\01_Permanente Erweiterungstabellen\03_Calc'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\01_Permanente Erweiterungstabellen\03_Calc\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\01_Permanente Erweiterungstabellen\04_Control'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\01_Permanente Erweiterungstabellen\04_Control\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\01_Permanente Erweiterungstabellen\05_Result'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\01_Permanente Erweiterungstabellen\05_Result\dummy.sql'

New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\01_Header, CleanUp'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\01_Header, CleanUp\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\02_StandardAPI'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\02_StandardAPI\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\03_API-Modifikationen'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\03_API-Modifikationen\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\04_Staging'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\04_Staging\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\05_Load'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\05_Load\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\06_Param'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\06_Param\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\07_Calc'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\07_Calc\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\08_Control'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\08_Control\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\09_Result'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\02_ProjektAPI\09_Result\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\03_Templates und Struktur'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\03_Templates und Struktur\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\04_Kleine Helfer'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\01_SQL-Dateien\04_Kleine Helfer\dummy.sql'

New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\02_XLS-Dateien'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\02_XLS-Dateien\01_ReportingMappen'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\02_XLS-Dateien\01_ReportingMappen\dummy.xls'

New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\03_PFE-Dateien'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\03_PFE-Dateien\01_Templates,Parameter,Mapping'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\03_PFE-Dateien\01_Templates,Parameter,Mapping\dummy.pfe'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\03_PFE-Dateien\02_Factories,ProductLines,Products'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\03_PFE-Dateien\02_Factories,ProductLines,Products\dummy.pfe'


New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektentwicklung\04_PS-Dateien'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektentwicklung\04_PS-Dateien\dummy.ps1'
