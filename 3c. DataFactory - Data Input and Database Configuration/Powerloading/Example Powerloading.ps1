
# PowerShell Invoke-WebRequest -Uri $url -Method GET -UseDefaultCredential

Write-Output "Powerloading started at $(Get-Date)"

$url = "http://CoPlan:5000/PowerLoader/DataFactory_BFW_2018/ABQ_S/"; PowerShell Invoke-WebRequest -Uri $url -Method GET -UseDefaultCredential
$url = "http://CoPlan:5000/PowerLoader/DataFactory_BFW_2018/AK_S/"; PowerShell Invoke-WebRequest -Uri $url -Method GET -UseDefaultCredential
$url = "http://CoPlan:5000/PowerLoader/DataFactory_BFW_2018/AK_SB/"; PowerShell Invoke-WebRequest -Uri $url -Method GET -UseDefaultCredential
$url = "http://CoPlan:5000/PowerLoader/DataFactory_BFW_2018/WV_S/"; PowerShell Invoke-WebRequest -Uri $url -Method GET -UseDefaultCredential
$url = "http://CoPlan:5000/PowerLoader/DataFactory_BFW_2018/WV_SB/"; PowerShell Invoke-WebRequest -Uri $url -Method GET -UseDefaultCredential

Write-Output "Powerloading finished at $(Get-Date)"





