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
#$PasswordHash = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes())
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
$AdministratorPasswordIsPlaintext.InnerText = "true"
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
$AutoLogonAdministratorPasswordIsPlaintext.InnerText = "true"
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

$oobesystem_MicrosoftWindowsInternationalCore = $xmlDocument.CreateElement("component")
$oobesystem_MicrosoftWindowsInternationalCore.SetAttribute("name","Microsoft-Windows-International-Core")
$oobesystem_MicrosoftWindowsInternationalCore.SetAttribute("processorArchitecture","amd64")
$oobesystem_MicrosoftWindowsInternationalCore.SetAttribute("publicKeyToken","31bf3856ad364e35")
$oobesystem_MicrosoftWindowsInternationalCore.SetAttribute("language","neutral")
$oobesystem_MicrosoftWindowsInternationalCore.SetAttribute("versionScope","nonSxS")
$oobesystem_MicrosoftWindowsInternationalCore.SetAttribute("xmlns:wcm","http://schemas.microsoft.com/WMIConfig/2002/State")
$oobesystem_MicrosoftWindowsInternationalCore.SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance")
$oobeSystem.AppendChild($oobesystem_MicrosoftWindowsInternationalCore) | Out-Null

$oobe_InputLocale = $xmlDocument.CreateElement("InputLocale")
$oobe_InputLocale.InnerText = "en-US"
$oobesystem_MicrosoftWindowsInternationalCore.AppendChild($oobe_InputLocale) | Out-Null

$oobe_SystemLocale = $xmlDocument.CreateElement("SystemLocale")
$oobe_SystemLocale.InnerText = "en-US"
$oobesystem_MicrosoftWindowsInternationalCore.AppendChild($oobe_SystemLocale) | Out-Null

$oobe_UILanguage = $xmlDocument.CreateElement("UILanguage")
$oobe_UILanguage.InnerText = "en-US"
$oobesystem_MicrosoftWindowsInternationalCore.AppendChild($oobe_UILanguage) | Out-Null

$oobe_UILanguageFallback = $xmlDocument.CreateElement("UILanguageFallback")
$oobe_UILanguageFallback.InnerText = "en-US"
$oobesystem_MicrosoftWindowsInternationalCore.AppendChild($oobe_UILanguageFallback) | Out-Null

$oobe_UserLocale = $xmlDocument.CreateElement("UserLocale")
$oobe_UserLocale.InnerText = "en-US"
$oobesystem_MicrosoftWindowsInternationalCore.AppendChild($oobe_UserLocale) | Out-Null

# Add Pass:specialize
$specialize = $xmlDocument.CreateElement("settings")
$specialize.SetAttribute("pass","specialize")
$Unattend.AppendChild($specialize) | Out-Null

$specialize_MicrosoftWindowsInternationalCore = $xmlDocument.CreateElement("component")
$specialize_MicrosoftWindowsInternationalCore.SetAttribute("name","Microsoft-Windows-International-Core")
$specialize_MicrosoftWindowsInternationalCore.SetAttribute("processorArchitecture","amd64")
$specialize_MicrosoftWindowsInternationalCore.SetAttribute("publicKeyToken","31bf3856ad364e35")
$specialize_MicrosoftWindowsInternationalCore.SetAttribute("language","neutral")
$specialize_MicrosoftWindowsInternationalCore.SetAttribute("versionScope","nonSxS")
$specialize_MicrosoftWindowsInternationalCore.SetAttribute("xmlns:wcm","http://schemas.microsoft.com/WMIConfig/2002/State")
$specialize_MicrosoftWindowsInternationalCore.SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance")
$specialize.AppendChild($specialize_MicrosoftWindowsInternationalCore) | Out-Null

$specialize_InputLocale = $xmlDocument.CreateElement("InputLocale")
$specialize_InputLocale.InnerText = "en-US"
$specialize_MicrosoftWindowsInternationalCore.AppendChild($specialize_InputLocale) | Out-Null

$specialize_SystemLocale = $xmlDocument.CreateElement("SystemLocale")
$specialize_SystemLocale.InnerText = "en-US"
$specialize_MicrosoftWindowsInternationalCore.AppendChild($specialize_SystemLocale) | Out-Null

$specialize_UILanguage = $xmlDocument.CreateElement("UILanguage")
$specialize_UILanguage.InnerText = "en-US"
$specialize_MicrosoftWindowsInternationalCore.AppendChild($specialize_UILanguage) | Out-Null

$specialize_UILanguageFallback = $xmlDocument.CreateElement("UILanguageFallback")
$specialize_UILanguageFallback.InnerText = "en-US"
$specialize_MicrosoftWindowsInternationalCore.AppendChild($specialize_UILanguageFallback) | Out-Null

$specialize_UserLocale = $xmlDocument.CreateElement("UserLocale")
$specialize_UserLocale.InnerText = "en-US"
$specialize_MicrosoftWindowsInternationalCore.AppendChild($specialize_UserLocale) | Out-Null

# $GeoID = $xmlDocument.CreateElement("GeoID")
# $GeoID.InnerText = "244"
# $specialize_MicrosoftWindowsInternationalCore.AppendChild($GeoID)

$specialize_MicrosoftWindowsShellSetup = $xmlDocument.CreateElement("component")
$specialize_MicrosoftWindowsShellSetup.SetAttribute("name","Microsoft-Windows-Shell-Setup")
$specialize_MicrosoftWindowsShellSetup.SetAttribute("processorArchitecture","amd64")
$specialize_MicrosoftWindowsShellSetup.SetAttribute("publicKeyToken","31bf3856ad364e35")
$specialize_MicrosoftWindowsShellSetup.SetAttribute("language","neutral")
$specialize_MicrosoftWindowsShellSetup.SetAttribute("versionScope","nonSxS")
$specialize_MicrosoftWindowsShellSetup.SetAttribute("xmlns:wcm","http://schemas.microsoft.com/WMIConfig/2002/State")
$specialize_MicrosoftWindowsShellSetup.SetAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance")
$specialize.AppendChild($specialize_MicrosoftWindowsShellSetup) | Out-Null

$TimeZone = $xmlDocument.CreateElement("TimeZone")
$TimeZone.InnerText = $Config.Unattend.TimeZone
$specialize_MicrosoftWindowsShellSetup.AppendChild($TimeZone) | Out-Null

$ProductKey = $xmlDocument.CreateElement("ProductKey")
$ProductKey.InnerText = $Config.Unattend.ProductKey
$specialize_MicrosoftWindowsShellSetup.AppendChild($ProductKey) | Out-Null

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