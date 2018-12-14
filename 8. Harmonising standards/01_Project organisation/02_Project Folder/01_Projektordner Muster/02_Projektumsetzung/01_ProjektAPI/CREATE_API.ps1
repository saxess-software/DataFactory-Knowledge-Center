# Creates API for database(s)
# The script can have empty Folders

    #Object for Encoding
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)

    #File Name
    $strScriptName = "API_DataFactory.sql"

    #Deletion old file and creation new file
    If (Test-Path $strScriptName) {
                                    Remove-Item $strScriptName
                                   }

								   
        #CustomAPI
    cat '.\02_CustomAPI\01_Header, CleanUp\*.sql',
        '.\02_CustomAPI\02_StandardAPI\*.sql',
        '.\02_CustomAPI\03_API-Modifikationen\*.sql',
        '.\02_CustomAPI\04_Staging\*.sql',
        '.\02_CustomAPI\05_Load\*.sql',
        '.\02_CustomAPI\06_Param\*.sql',
        '.\02_CustomAPI\07_Calc\*.sql',
        '.\02_CustomAPI\08_Control\*.sql',          
        '.\02_CustomAPI\09_Result\*.sql'        > $strScriptName -Encoding "UTF8"


    #Really UTF-8 without BOM
    $path = $strScriptName
    [System.IO.File]::WriteAllLines($path, (Get-Content $path),$Utf8NoBomEncoding)




