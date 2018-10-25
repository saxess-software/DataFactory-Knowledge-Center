# Create the basic folder structure for a german project
# unfortunately you can't publish empty folders in Github, thats why you see Dummy files in empty folders

# CONFIGURATION ######################################################################

# Nothing to do, there folder structure is created in the folder where the script is executed - just copy the script to the folder
# where you want to create the structure

# if you cant execute this script, open PowerShell as Admin and execute command "Set-ExecutionPolicy RemoteSigned"

#########################################################################

# Project folder sample
New-Item -ItemType directory -Name '01_Projektordner Muster'

# Folder for customer files
New-Item -ItemType directory -Name '01_Projektordner Muster\01_Kundenunterlagen'
New-Item -ItemType directory -Name '01_Projektordner Muster\01_Kundenunterlagen\01_Archiv'
New-Item -ItemType File -Name '01_Projektordner Muster\01_Kundenunterlagen\01_Archiv\dummy.txt'


# Folder implementation
## Folder for all files related to project API
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung'

New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\01_Permanente Erweiterungstabellen'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\01_Permanente Erweiterungstabellen\01_Staging'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\01_Permanente Erweiterungstabellen\01_Staging\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\01_Permanente Erweiterungstabellen\02_Param'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\01_Permanente Erweiterungstabellen\02_Param\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\01_Permanente Erweiterungstabellen\03_Calc'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\01_Permanente Erweiterungstabellen\03_Calc\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\01_Permanente Erweiterungstabellen\04_Control'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\01_Permanente Erweiterungstabellen\04_Control\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\01_Permanente Erweiterungstabellen\05_Result'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\01_Permanente Erweiterungstabellen\05_Result\dummy.sql'

New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\01_Header, CleanUp'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\01_Header, CleanUp\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\02_StandardAPI'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\02_StandardAPI\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\03_API-Modifikationen'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\03_API-Modifikationen\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\04_Staging'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\04_Staging\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\05_Load'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\05_Load\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\06_Param'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\06_Param\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\07_Calc'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\07_Calc\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\08_Control'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\08_Control\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\09_Result'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\02_CustomAPI\09_Result\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\03_Templates und Struktur'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\03_Templates und Struktur\dummy.sql'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\04_Kleine Helfer'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\01_ProjektAPI\04_Kleine Helfer\dummy.sql'

## Folder for all files related to reporting
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\02_Reporting'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\02_Reporting\01_Auslieferung'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\02_Reporting\01_Auslieferung\dummy.xls'
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\02_Reporting\02_Monitoring'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\02_Reporting\02_Monitoring\dummy.xls'

## Folder for all templates
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\03_Templates'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\03_Templates\dummy.pfe'

## Folder for all automation related topics
New-Item -ItemType directory -Name '01_Projektordner Muster\02_Projektumsetzung\04_Automatisierung'
New-Item -ItemType File -Name '01_Projektordner Muster\02_Projektumsetzung\04_Automatisierung\dummy.ps1'
