Param(
    [Parameter(mandatory=$true)]
    $OSConfig,
    [Parameter(mandatory=$true)]
    $PartitonConfig,
    [Parameter(mandatory=$true)]
    $RepoConfig
)

Write-Host "BEGIN STEP: INSTALL IMAGE" -ForegroundColor Green

Write-Host "`tVerifying Image Details"

$ImageFile = "$($RepoConfig.Path)\$($RepoConfig.Folders.Images)\$($OSConfig.Image)"

# Verify Image Exists
if(!(Test-Path $ImageFile))
{
    return [PSCustomObject]@{
        Success = $false
        Error = "Error occoured Expanding Image: File $ImageFile does not exist."
    }
}

# Get details on the image. 
try {
    $ImageDetails = Get-WindowsImage -ImagePath $ImageFile

    if(!$ImageDetails)
    {
        throw
    }
}
catch {
    return [PSCustomObject]@{
        Success = $false
        Error = "Could not get details on $ImageFile."
    }
}

# Check if there are enough indexes.
if($ImageDetails.Count -lt $OSConfig.Index)
{
    return [PSCustomObject]@{
        Success = $false
        Error = " $ImageFile has $($ImageDetails.Count) Indexes, but index $($OSConfig.Index) was requested."
    }
}

$SelectedIndex = $ImageDetails | Where-Object {$_.ImageIndex -eq $OSConfig.Index}

Write-Host "`tFound Index $($OSConfig.Index):"
Write-Host "`t`tName $($SelectedIndex.ImageName)"
Write-Host "`t`tDescription: $($SelectedIndex.ImageDescription)"
Write-Host "`t`tSize: $([Math]::Round($SelectedIndex.ImageSize/1GB,2))GB"

# Try and Expand Image
try {
    Write-Host "`tExtracting Image"
    $ImageStatus = Expand-WindowsImage -ImagePath $ImageFile -Index $OSConfig.Index -ApplyPath "$($PartitonConfig.DriveLetters.OS):\" -ErrorAction SilentlyContinue

    if(!$ImageStatus)
    {
        throw
    }
}
catch {
    return [PSCustomObject]@{
        Success = $false
        Error = "Error occoured Expanding Image: $ImageFile Index: $($OSConfig.Index) on $($PartitonConfig.DriveLetters.OS):\"
    }
}

return [PSCustomObject]@{
    Success = $true
}