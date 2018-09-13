# Creates the customer specific API
# The script can't have empty Folders


# Object for Encoding
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)

# Datei löschen
$strScriptName = "Custom_API.sql"

If (Test-Path $strScriptName) {
                                Remove-Item $strScriptName
                               }

cat '9. Header\*.sql',
    '1. Standard API\*.sql',
    '2. API Modifikation\*.sql',
    '3. Kundenerweiterungen\*.sql'  > $strScriptName -Encoding "UTF8"



#Really UTF-8 without BOM
$path = $strScriptName
[System.IO.File]::WriteAllLines($path, (Get-Content $path),$Utf8NoBomEncoding)



