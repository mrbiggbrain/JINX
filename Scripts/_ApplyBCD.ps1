param(
    $Config
)

Write-Host "BEGIN STEP: CONFIGURE BOOT" -ForegroundColor Green
Write-Host "`tWriting Boot Information To Disk"

# -----------------------------------------------------------
# Determine a few paths
# -----------------------------------------------------------
$OSDrive = $Config.DriveLetters.OS
$SystemDrive = $Config.DriveLetters.System
$OfflineWinDir = "$($OSDrive):\Windows"
$SystemRoot = "$($SystemDrive):"

# -----------------------------------------------------------
# Apply BCD Settings
# -----------------------------------------------------------
bcdboot.exe "$OfflineWinDir" /s "$SystemRoot"

return [PSCustomObject]@{
    Success = $true
}