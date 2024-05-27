param(
    $Config
)

Write-Host "BEGIN STEP: PARTITION DISKS" -ForegroundColor Green
Write-Host "`tPartitioning Disk $($Config.Disk) using $($Config.PartType)"

Write-Host "`t`tGetting Details on Disk $($Config.Disk)"
try{
     # Grab some disk details
    $disk = Get-Disk -Number $Config.Disk

    if(!$disk)
    {
        throw
    }
}
catch {
    return [PSCustomObject]@{
        Success = $false
        Error = "An error occoured getting details on disk #$($config.Disk)"
    }
}


 # Determine size of OS drive
 $osDiskSize = $disk.Size - 1024MB

 # Clear the disk if the partition style is not raw.
 if($disk.PartitionStyle -ne "RAW")
 {
    Write-Host "`t`tClearing Disk (Erasing Content)."
    try {
        # Clear the Disk
        Clear-Disk -Number $Config.Disk -Removedata -Confirm:$false -ErrorAction SilentlyContinue -RemoveOEM
    }
    catch {
        return [PSCustomObject]@{
            Success = $false
            Error = "Error occoured clearing disk #$($config.Disk)"
        }
    }
     
 }
 

# Refresh the disk object.
try{  
    $disk = Get-Disk -Number $Config.Disk -ErrorAction SilentlyContinue
}
catch {
   return [PSCustomObject]@{
       Success = $false
       Error = "An error occoured getting details on disk #$($config.Disk)"
   }
}

 # Initilize disk if it's now RAW after clearing.
 if($disk.PartitionStyle -eq "RAW")
 {
    Write-Host "`t`tInitilizing Disk $($Config.Disk)"
    try {
        Initialize-Disk -Number $Config.Disk -PartitionStyle GPT -ErrorAction SilentlyContinue
    }
    catch {
        return [PSCustomObject]@{
            Success = $false
            Error = "An error occoured initilizing disk #$($config.Disk)"
        }
    }
    
 }

try {
    Write-Host "`t`tCreating Partitions"

    try {
        # Generate EFI partition
        Write-Host "`t`t`tGenerate EFI Partition on $($Config.DriveLetters.System):"
        $Part_System = New-Partition -DiskNumber $Config.Disk -Size 499MB -DriveLetter $Config.DriveLetters.System -GptType "{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}" -ErrorAction SilentlyContinue

        if(!$Part_System)
        {
            throw
        }
    }
    catch {
        return [PSCustomObject]@{
            Success = $false
            Error = "Could not create System partition."
        }
    }

    try {
        # Generate OS Partition
        Write-Host "`t`t`tGenerate OS Partition on $($Config.DriveLetters.OS):"
        $Part_OS = New-Partition -DiskNumber $Config.Disk -DriveLetter $Config.DriveLetters.OS -Size $osDiskSize -ErrorAction SilentlyContinue

        if(!$Part_OS)
        {
            throw
        }
    }
    catch {
        return [PSCustomObject]@{
            Success = $false
            Error = "Could not create OS partition."
        }
    }
    
    try {
        # Generate recovery partition
        Write-Host "`t`t`tGenerate Recovery Partition on $($Config.DriveLetters.Recovery):"
        $Part_Recovery = New-Partition -DiskNumber $Config.Disk -UseMaximumSize -DriveLetter $Config.DriveLetters.Recovery -GptType "{de94bba4-06d1-4d40-a16a-bfd50179d6ac}" -ErrorAction SilentlyContinue

        if(!$Part_Recovery)
        {
            throw
        }
    }
    catch {
        return [PSCustomObject]@{
            Success = $false
            Error = "Could not create Recovery partition."
        }
    }
    
}
catch {
    return [PSCustomObject]@{
        Success = $false
        Error = "An Error Has Occoured Creating Partitions"
    }
}

return [PSCustomObject]@{
    Success = $true
}