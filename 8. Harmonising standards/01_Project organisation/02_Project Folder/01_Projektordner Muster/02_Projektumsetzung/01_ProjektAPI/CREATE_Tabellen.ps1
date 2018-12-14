# Creates custom tables for database(s)
# The script can have empty Folders

    #Object for Encoding
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)

    #File Name
    $strScriptName = "Tabellen_DataFactory.sql"

    #Deletion old file and creation new file
    If (Test-Path $strScriptName) {
                                    Remove-Item $strScriptName
                                   }

								   
         #Permanente Erweiterungstabellen
    cat '.\01_Permanente Erweiterungstabellen\01_Staging\*.sql',
        '.\01_Permanente Erweiterungstabellen\02_Param\*.sql',
        '.\01_Permanente Erweiterungstabellen\03_Calc\*.sql',
        '.\01_Permanente Erweiterungstabellen\04_Control\*.sql',
        '.\01_Permanente Erweiterungstabellen\05_Result\*.sql'        > $strScriptName -Encoding "UTF8"

		
    #Really UTF-8 without BOM
    $path = $strScriptName
    [System.IO.File]::WriteAllLines($path, (Get-Content $path),$Utf8NoBomEncoding)




