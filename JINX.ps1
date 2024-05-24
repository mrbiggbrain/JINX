Write-Host "#----------------------------------------------#"
Write-Host "| JINX (Just Install Native Experience)        |"
Write-Host "| Version: 0.0.1                               |"
Write-Host "| (C) Copyright $(Get-Date -Format yyyy) Nicholas Young            |"
Write-Host "#----------------------------------------------#"

# Gather Facts
$Config = & "$PSScriptRoot\Scripts\_GatherConfig.ps1" -Phase WINPE

#Partition Disks
$PartitionResults = & "$PSScriptRoot\Scripts\_PartitionDisks.ps1" -Config $Config.Partition

# Check for Failure and display errors if found
if(!$PartitionResults.Success) 
{ 
    Write-Host "Error! Partitioning Disk Failed" -ForegroundColor Red
    Write-Host "$($PartitionResults.Error)"
    Write-Host "Provisioning has Failed, check $($Config.Logging.LogFile) for more details"
    [void]$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); 
    exit
}

# Format and Setup Filesystem
$FormatResults = & "$PSScriptRoot\Scripts\_FormatDisks.ps1" -Config $Config.Partition

# Check for Failure and Display Error
if(!$FormatResults.Success)
{
    Write-Host "Error! Formatting Partitions Failed" -ForegroundColor Red
    Write-Host "Provisioning has Failed, check $($Config.Logging.LogFile) for more details"
    [void]$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); 
    exit
}

# Install OS
$InstallResults = & "$PSScriptRoot\Scripts\_InstallOS.ps1" -OSConfig $Config.Install -PartitonConfig $Config.Partition -RepoConfig $Config.Repo

if(!$InstallResults.Success)
{
    Write-Host "Error! OS Install Failed" -ForegroundColor Red
    Write-Host "$($InstallResults.Error)"
    Write-Host "Provisioning has Failed, check $($Config.Logging.LogFile) for more details"
    [void]$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); 
    exit
}

# Install Boot Loader
$BCDResults = & "$PSScriptRoot\Scripts\_ApplyBCD.ps1" -Config $Config.Partition

if(!$BCDResults.Success)
{
    Write-Host "Error! BCD Setup Failed" -ForegroundColor Red
    Write-Host "$($BCDResults.Error)"
    Write-Host "Provisioning has Failed, check $($Config.Logging.LogFile) for more details"
    [void]$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); 
    exit
}

# Inject Drivers
$DriverResults = & "$PSScriptRoot\Scripts\_InjectDrivers.ps1" -Config $Config.Repo -OSDrive $Config.Partition.DriveLetters.OS

if(!$DriverResults.Success)
{
    Write-Host "Error! Driver Injection Failed" -ForegroundColor Red
    Write-Host "$($DriverResults.Error)"
    Write-Host "Provisioning has Failed, check $($Config.Logging.LogFile) for more details"
    [void]$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); 
    exit
}

# Configure Unattend.xml
$UnattendXMLResults = & "$PSScriptRoot\Scripts\_SetupUnattendXML.ps1" -Config $Config

if(!$UnattendXMLResults.Success)
{
    Write-Host "Error! Driver Injection Failed" -ForegroundColor Red
    Write-Host "$($UnattendXMLResults.Error)"
    Write-Host "Provisioning has Failed, check $($Config.Logging.LogFile) for more details"
    [void]$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); 
    exit
}