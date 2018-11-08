# Creates procedure [control].[spCustomFailureReport] from various sql-files
# Procedures supplies data for user failure report
# All Input Files must be UTF8 encoded


#Object for Encoding
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)

# Create the Tables Script on top level folder
$strScriptName = "control.spCustomFailureReport.sql"
$strFolderName = "..\\"
$strPathName = $strFolderName + $strScriptName

# Delete old files which may exist
Remove-Item $strPathName -ErrorAction Ignore
Remove-Item $strScriptName -ErrorAction Ignore
Remove-Item tmp.sql -ErrorAction Ignore

# build tmp script which concats all *.sql
#Get-ChildItem  -recurse |?{ ! $_.PSIsContainer } |?{($_.name).contains(".sql")} | % { Out-File tmp.sql -inputobject ([System.IO.File]::ReadAllText($_.fullname)) -Append}

# add Header and Footer
cat '.\01_Header.sql',
    '.\Snippets\*.sql',
    '.\02_Footer.sql'  > $strScriptName -Encoding "UTF8"

#Really UTF-8 without BOM
$path = $strScriptName
[System.IO.File]::WriteAllLines($path, (Get-Content $path),$Utf8NoBomEncoding)

Move-Item -Path .\control.spCustomFailureReport.sql -Destination ..\\

#Remove tmp script
#Remove-Item tmp.sql -ErrorAction Ignore