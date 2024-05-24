param(
    $Config
)

Write-Host "BEGIN STEP: FORMAT DISKS" -ForegroundColor Green

# Format Recovery Partition
try {
    Write-Host "`tFormatting Recovery Partition on $($Config.DriveLetters.Recovery):"
    Get-Partition -DriveLetter $Config.DriveLetters.Recovery | Format-Volume -FileSystem NTFS
}
catch {
    return [PSCustomObject]@{
        Success = $false
        Error = "An error occoured when formatting the Recovery partition on #$($Config.DriveLetters.Recovery):"
    }
}

# Format System Partition
try {
    Write-Host "`tFormatting System Partition on $($Config.DriveLetters.System):"
    Get-Partition -DriveLetter $Config.DriveLetters.System | Format-Volume -FileSystem FAT32
}
catch {
    return [PSCustomObject]@{
        Success = $false
        Error = "An error occoured when formatting the System partition on #$($Config.DriveLetters.System):"
    }
}


# Format OD Partition
try {
    Write-Host "`tFormatting OS Partition on $($Config.DriveLetters.OS):"
    Get-Partition -DriveLetter $Config.DriveLetters.OS | Format-Volume -FileSystem NTFS
}
catch {
    return [PSCustomObject]@{
        Success = $false
        Error = "An error occoured when formatting the OS partition on #$($Config.DriveLetters.OS):"
    }
}


return [PSCustomObject]@{
    Success = $true
}