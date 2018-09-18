# Create the basic folder structure for a german project
# unfortunately you can't publish empty folders in Github, thats why you see Dummy files in empty folders

# CONFIGURATION ######################################################################

# Nothing to do, there folder structure is created in the folder where the script is executed - just copy the script to the folder
# where you want to create the structure

# if you cant execute this script, open PowerShell as Admin and execute command "Set-ExecutionPolicy RemoteSigned"

#########################################################################


# Folder for Customer Documents
New-Item -ItemType directory -Name '1. Kundenunterlagen'

New-Item -ItemType File -Name '1. Kundenunterlagen\dummy.txt'

# Folder for customer API
New-Item -ItemType directory -Name '2. Projektumsetzung\API'
New-Item -ItemType directory -Name '2. Projektumsetzung\API\0. permanente Erweiterungstabellen'
New-Item -ItemType directory -Name '2. Projektumsetzung\API\1. Standard API'
New-Item -ItemType directory -Name '2. Projektumsetzung\API\2. API Modifikation'
New-Item -ItemType directory -Name '2. Projektumsetzung\API\3. Kundenerweiterungen'
New-Item -ItemType directory -Name '2. Projektumsetzung\API\9. Header'

New-Item -ItemType File -Name '2. Projektumsetzung\API\0. permanente Erweiterungstabellen\dummy.sql'
New-Item -ItemType File -Name '2. Projektumsetzung\API\1. Standard API\dummy.sql'
New-Item -ItemType File -Name '2. Projektumsetzung\API\2. API Modifikation\dummy.sql'
New-Item -ItemType File -Name '2. Projektumsetzung\API\3. Kundenerweiterungen\dummy.sql'
New-Item -ItemType File -Name '2. Projektumsetzung\API\9. Header\dummy.sql'

# Folder for Templates
New-Item -ItemType directory -Name '2. Projektumsetzung\Templates\'

New-Item -ItemType File -Name '2. Projektumsetzung\Templates\dummy.txt'