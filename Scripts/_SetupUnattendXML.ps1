param(
    $Config
)

Write-Host "BEGIN STEP: GENERATE UNATTEND.XML" -ForegroundColor Green

Write-Host "`tGenerating XML Document"

# generate XML Document
$xmlDocument = New-Object System.Xml.XmlDocument

# Adding XML Declaration
$XMLDecleration = $xmlDocument.CreateXmlDeclaration("1.0","UTF-8", $null)
$xmlDocument.InsertBefore($XMLDecleration,$xmlDocument.DocumentElement) | Out-Null

# Add Unattend
$Unattend = $xmlDocument.CreateElement("unattend","urn:schemas-microsoft-com:unattend")
$xmlDocument.AppendChild($Unattend) | Out-Null

# Add Pass:oobeSystem
$oobeSystem = $xmlDocument.CreateElement("settings")
$oobeSystem.SetAttribute("pass","oobeSystem")
$Unattend.AppendChild($oobeSystem) | Out-Null

# componenet:MicrosoftWindowsShellSetup
$oobeSystem_MicrosoftWindowsShellSetup = $xmlDocument.CreateElement("component")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("name","Microsoft-Windows-Shell-Setup")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("processorArchitecture","amd64")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("publicKeyToken","31bf3856ad364e35")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("language","neutral")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("versionScope","nonSxS")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("xmlns:wcm","http://schemas.microsoft.com/WMIConfig/2002/State")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance")
$oobeSystem.AppendChild($oobeSystem_MicrosoftWindowsShellSetup) | Out-Null

# UserAccounts
$UserAccounts = $xmlDocument.CreateElement("UserAccounts")
$oobeSystem_MicrosoftWindowsShellSetup.AppendChild($UserAccounts) | Out-Null

# Administrator Password
$AdministratorPassword = $xmlDocument.CreateElement("AdministratorPassword")
$UserAccounts.AppendChild($AdministratorPassword) | Out-Null
$AdministratorPasswordValue = $xmlDocument.CreateElement("Value")
$PasswordHash = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($Config.Unattend.Administrator.Password.Value))
if($Config.Unattend.Administrator.Password.PlainText -eq $true) 
{ 
    $AdministratorPasswordValue.InnerText = $PasswordHash
}
elseif($Config.Unattend.Administrator.Password.PlainText -eq $false)
{
    $AdministratorPassword.InnerText = $Config.Unattend.Administrator.Password.Value
}
else 
{
    return [PSCustomObject]@{
        Success = $false
        Error = "Error: Incorrect value for PlainText Value of Administrator Password"
    }
}
$AdministratorPassword.AppendChild($AdministratorPasswordValue) | Out-Null
$AdministratorPasswordIsPlaintext = $xmlDocument.CreateElement("PlainText")
$AdministratorPasswordIsPlaintext.InnerText = "false"
$AdministratorPassword.AppendChild($AdministratorPasswordIsPlaintext) | Out-Null

$AutoLogon = $xmlDocument.CreateElement("AutoLogon")
$oobeSystem_MicrosoftWindowsShellSetup.AppendChild($AutoLogon) | Out-Null

$AutoLogonPassword = $xmlDocument.CreateElement("Password")
$AutoLogon.AppendChild($AutoLogonPassword) | Out-Null

$AutoLogonPasswordValue = $xmlDocument.CreateElement("Value")

if($Config.Unattend.Administrator.Password.PlainText -eq $true) 
{ 
    $AutoLogonPasswordValue.InnerText = $PasswordHash
}
elseif($Config.Unattend.Administrator.Password.PlainText -eq $false)
{
    $AutoLogonPasswordValue.InnerText = $Config.Unattend.Administrator.Password.Value
}
else 
{
    return [PSCustomObject]@{
        Success = $false
        Error = "Error: Incorrect value for PlainText Value of Administrator Password"
    }
}
$AutoLogonPassword.AppendChild($AutoLogonPasswordValue) | Out-Null
$AutoLogonAdministratorPasswordIsPlaintext = $xmlDocument.CreateElement("PlainText")
$AutoLogonAdministratorPasswordIsPlaintext.InnerText = "false"
$AutoLogonPassword.AppendChild($AutoLogonAdministratorPasswordIsPlaintext) | Out-Null

$AutoLogonEnabled = $xmlDocument.CreateElement("Enabled")
$AutoLogonEnabled.InnerText = "true"
$AutoLogon.AppendChild($AutoLogonEnabled) | Out-Null

$AutoLogonCount = $xmlDocument.CreateElement("LogonCount")
$AutoLogonCount.InnerText = "999"
$AutoLogon.AppendChild($AutoLogonCount) | Out-Null

$AutoLogonUser = $xmlDocument.CreateElement("Username")
$AutoLogonUser.InnerText = "Administrator"
$AutoLogon.AppendChild($AutoLogonUser) | Out-Null

$OOBE = $xmlDocument.CreateElement("OOBE")
$oobeSystem_MicrosoftWindowsShellSetup.AppendChild($OOBE) | Out-Null

$HideEULAPage = $xmlDocument.CreateElement("HideEULAPage")
$HideEULAPage.InnerText = "true"
$OOBE.AppendChild($HideEULAPage) | Out-Null

$HideLocalAccountScreen = $xmlDocument.CreateElement("HideLocalAccountScreen")
$HideLocalAccountScreen.InnerText = "true"
$OOBE.AppendChild($HideLocalAccountScreen) | Out-Null

$HideOEMRegistrationScreen = $xmlDocument.CreateElement("HideOEMRegistrationScreen")
$HideOEMRegistrationScreen.InnerText = "true"
$OOBE.AppendChild($HideOEMRegistrationScreen) | Out-Null

$HideOnlineAccountScreens = $xmlDocument.CreateElement("HideOnlineAccountScreens")
$HideOnlineAccountScreens.InnerText = "true"
$OOBE.AppendChild($HideOnlineAccountScreens) | Out-Null

$HideWirelessSetupInOOBE = $xmlDocument.CreateElement("HideWirelessSetupInOOBE")
$HideWirelessSetupInOOBE.InnerText = "true"
$OOBE.AppendChild($HideWirelessSetupInOOBE) | Out-Null

$ProtectYourPC = $xmlDocument.CreateElement("ProtectYourPC")
$ProtectYourPC.InnerText = "3"
$OOBE.AppendChild($ProtectYourPC) | Out-Null

$oobeSystem_MicrosoftWindowsInternationalCore = $xmlDocument.CreateElement("component")
$oobeSystem_MicrosoftWindowsInternationalCore.SetAttribute("name","Microsoft-Windows-International-Core")
$oobeSystem_MicrosoftWindowsInternationalCore.SetAttribute("processorArchitecture","amd64")
$oobeSystem_MicrosoftWindowsInternationalCore.SetAttribute("publicKeyToken","31bf3856ad364e35")
$oobeSystem_MicrosoftWindowsInternationalCore.SetAttribute("language","neutral")
$oobeSystem_MicrosoftWindowsInternationalCore.SetAttribute("versionScope","nonSxS")
$oobeSystem_MicrosoftWindowsInternationalCore.SetAttribute("xmlns:wcm","http://schemas.microsoft.com/WMIConfig/2002/State")
$oobeSystem_MicrosoftWindowsInternationalCore.SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance")
$oobeSystem.AppendChild($oobeSystem_MicrosoftWindowsInternationalCore) | Out-Null

$InputLocale = $xmlDocument.CreateElement("InputLocale")
$InputLocale.InnerText = "en-US"
$oobeSystem_MicrosoftWindowsInternationalCore.AppendChild($InputLocale) | Out-Null

$SystemLocale = $xmlDocument.CreateElement("SystemLocale")
$SystemLocale.InnerText = "en-US"
$oobeSystem_MicrosoftWindowsInternationalCore.AppendChild($SystemLocale) | Out-Null

$UILanguage = $xmlDocument.CreateElement("UILanguage")
$UILanguage.InnerText = "en-US"
$oobeSystem_MicrosoftWindowsInternationalCore.AppendChild($UILanguage) | Out-Null

$UserLocale = $xmlDocument.CreateElement("UserLocale")
$UserLocale.InnerText = "en-US"
$oobeSystem_MicrosoftWindowsInternationalCore.AppendChild($UserLocale) | Out-Null

$oobeSystem_MicrosoftWindowsShellSetup = $xmlDocument.CreateElement("component")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("name","Microsoft-Windows-Shell-Setup")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("processorArchitecture","amd64")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("publicKeyToken","31bf3856ad364e35")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("language","neutral")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("versionScope","nonSxS")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("xmlns:wcm","http://schemas.microsoft.com/WMIConfig/2002/State")
$oobeSystem_MicrosoftWindowsShellSetup.SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance")
$oobeSystem.AppendChild($oobeSystem_MicrosoftWindowsShellSetup) | Out-Null

$TimeZone = $xmlDocument.CreateElement("TimeZone")
$TimeZone.InnerText = $Config.Unattend.TimeZone
$oobeSystem_MicrosoftWindowsShellSetup.AppendChild($TimeZone) | Out-Null

$ProductKey = $xmlDocument.CreateElement("ProductKey")
$ProductKey.InnerText = $Config.Unattend.ProductKey
$oobeSystem_MicrosoftWindowsShellSetup.AppendChild($ProductKey) | Out-Null

$OSDrive = $Config.Partition.DriveLetters.OS
$DestinationFolder = "$($OSDrive):\Windows\Panther"
$DestinationFile = "$($DestinationFolder)\Unattend.xml"

if(!(Test-Path $DestinationFolder))
{
    Write-Host "`tCreating Pather Folder."
    New-Item -Path $DestinationFolder -ItemType Directory | Out-Null
}

Write-Host "`tSaving XML Document to Panther Folder"
$xmlDocument.Save($DestinationFile)

return [PSCustomObject]@{
    Success = $true
}