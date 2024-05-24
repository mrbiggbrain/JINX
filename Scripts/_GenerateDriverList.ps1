using namespace System.Collections.Generic

Param(
    [String]$DriverPath,
    [Switch]$DiscoveredOnly
)

if(!(Test-Path $DriverPath))
{
    Write-Error "Driver Directory Missing. Returning Empty Array."
    return @()
}

# Get all the driver (INF) files in the provided directory. 
$Drivers = Get-ChildItem -Recurse -Path $DriverPath -Filter *.inf

# Are we only getting required drivers. 
if($DiscoveredOnly)
{
    # Get a listing of all of the device InstanceIDs on our system. Truncate them for better matching. 
    $Devices = Get-PnpDevice | Select-Object -ExpandProperty InstanceID | foreach-Object {
        $Parts = $_ -Split "&"

        if($Parts.Count -gt 1)
        {
            Write-Output "$($Parts[0])&$($Parts[1])"
        }
        else
        {
            Write-Output $Parts[0]
        }
    } | Select-Object -Unique

    # Check all of the driver files to see if we have matches within. 
    $Results = foreach($driver in $Drivers)
    {
        $INFDetails = Get-Content -Path $Driver.FullName -Raw

        foreach($device in $Devices)
        {
            if($INFDetails.Contains($device))
            {
                #$Results.Add($Driver.FullName)
                Write-Output $driver.FullName
            }
        }
    }

    # Return the discovered matches. 
    return $Results
}
else
{
    # If we don't need to perform logic, just return all drivers. 
    return $Drivers | Select-Object -ExpandProperty FullName -Unique
}