###
# PowerShell Compressor
# Script needs one mandatory parameter - $backupDir. $backupDir need to have ending slash, for example C:\TMP\TEST\ 
# So the command example is .\Task2.ps1 -backupDir C:\TMP\TEST\ 
# Also log file location can be changed. 
###

Param(
  [Parameter(
  Mandatory = $true,
  ValueFromPipeline = $true)]
  [string]$backupDir
  )


$logname="C:\TMP\PowerShell_Compressor$(get-date -f yyyy-MM-dd-HH-mm-ss).log"

Write-Output "PowerShell Compressor" | Out-File $logname -Append
Write-Output "" | Out-File $logname -Append
Write-Output "Backup Directory is $backupDir" | Out-File $logname -Append
Write-Output "" | Out-File $logname -Append

function Add-Zip
{
     param([string]$zipfilename) 
     if (Test-Path($zipfilename))
     {
     Write-Output "Archive file $zipfilename exists, skipping..." | Out-File $logname -Append
     }
     else
     {
     if(-not (test-path($zipfilename)))
     {
          set-content $zipfilename (“PK” + [char]5 + [char]6 + (“$([char]0)” * 18))
          (dir $zipfilename).IsReadOnly = $false   

     }

     $shellApplication = new-object -com shell.application
     $zipPackage = $shellApplication.NameSpace($zipfilename)
    

     foreach($file in $input) 
     { 
          $zipPackage.CopyHere($file.FullName)
          Start-sleep -milliseconds 500
     }
     }
}

Write-Output "Checking backup directory $backupDir..." | Out-File $logname -Append

Get-ChildItem -Path $backupDir -Directory | ForEach-Object {
    Write-Output "Checking backups for DB:"$_.Name | Out-File $logname -Append
    Get-ChildItem -Path $backupDir$_ | ForEach-Object {
        $tmpVar= $_.FullName
        if ($tmpVar -match(".zip"))
        {
            Write-Output "Archive file $tmpVar exists, skipping..." | Out-File $logname -Append
        }
        else {
            Write-Output "Archiving file $tmpVar..." | Out-File $logname -Append
            dir $tmpVar | Add-Zip "$tmpVar.zip"
            Write-Output "File $tmpVar archieved, ok" | Out-File $logname -Append
            Write-Output "Removing original $tmpVar file..." | Out-File $logname -Append
            Remove-Item $tmpVar
            Write-Output "Original $tmpVar file removed, ok" | Out-File $logname -Append
        }


    }

}


