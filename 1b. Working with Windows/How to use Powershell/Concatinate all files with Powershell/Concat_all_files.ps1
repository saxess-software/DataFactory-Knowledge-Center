# Creates one text file, based on many single files
# all Input Files must be UTF8 encoded


#Object for Encoding
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)

# Create the Tables Script on top level folder
$strScriptName = "all.sql"

# Delete old file which may exist
Remove-Item $strScriptName -ErrorAction Ignore

cat *.sql > $strScriptName -Encoding "UTF8"

#Really UTF-8 without BOM
$path = $strScriptName
[System.IO.File]::WriteAllLines($path, (Get-Content $path),$Utf8NoBomEncoding)



