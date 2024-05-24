[CmdletBinding()]
param (
    $Config,
    $OSDrive
)

Write-Host "BEGIN STEP: INJECT DRIVERS" -ForegroundColor Green

Write-Host "`tGetting List of Drivers"
$Drivers = & "$PSScriptRoot\_GenerateDriverList.ps1" -DriverPath "$($Config.Path)\$($Config.Folders.Drivers)" -DiscoveredOnly:$false

Write-Host "`t`tFound $($Drivers.Count) Drivers to Install"
Write-Host "`tInstalling Drivers"

for ($i = 0; $i -lt $Drivers.Count; $i++ ) {
    $Driver = $Drivers[$i]
    $Percent = [Math]::Truncate(($i/$Drivers.Count) * 100)
    if(($i % [math]::ceiling($Drivers.Count/4)) -eq 0) {Write-Host "`t`t$($percent)% Complete"}
    Write-Progress -Activity "Installing: $Driver" -PercentComplete $Percent -Status "$($Percent)% Completed. [$i/$($Drivers.Count)]"
    Add-WIndowsDriver -Driver $Driver -ForceUnsigned -Path "$($OSDrive):\" | Out-Null
}

return [PSCustomObject]@{
    Success = $true
}