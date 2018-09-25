
######################################################
###                                                ###
##  Configure Primary Domain Controller - (Part 1)  ##
###                                                ###
######################################################


# Global Variables
$downloadsPath = $env:UserProfile + "\Downloads\"
$domainCSVPath = $env:UserProfile + "\Downloads\domain.csv"
$dcConfigTemplatePath = $env:UserProfile + "\Downloads\DC_Config_Template.xml"


# Brief Overview of Script Contents
Write-Host "Configure Primary Domain Controller - (Part 1)"
Write-Host ""
Write-Host ""
Write-Host "This file takes care of:"
Write-Host ""
Start-Sleep -s 1
Write-Host "1. Changes to the Registry"
Write-Host ""
Start-Sleep -s 1
Write-Host "2. Configure Domain & Configure Server to be Primary Domain Controller"
Write-Host ""
Start-Sleep -s 1
Write-Host "Preparing...."
Start-Sleep -s 4

Write-Host ""
Write-Host ""



####################  1. CHANGES TO THE REGISTRY  ####################

Write-Host "1. Changes to the Registry"
Write-Host ""
Start-Sleep -s 1


Write-Host "    Setting Registry Format Values..."
Write-Host ""

# Set the Formats to be Irish, eg. Date, Time
$registryPath = "HKCU:\Control Panel\International"
New-ItemProperty -Path $registryPath -Name "LocaleName" -Value "en-IE" -Force
New-ItemProperty -Path $registryPath -Name "sCountry" -Value "Ireland" -Force
New-ItemProperty -Path $registryPath -Name "sCurrency" -Value "€" -Force
New-ItemProperty -Path $registryPath -Name "sDate" -Value "/" -Force
New-ItemProperty -Path $registryPath -Name "sLanguage" -Value "ENI" -Force
New-ItemProperty -Path $registryPath -Name "sLongDate" -Value "dddd d MMMM yyyy" -Force
New-ItemProperty -Path $registryPath -Name "sShortDate" -Value "dd/MM/yyyy" -Force
New-ItemProperty -Path $registryPath -Name "sTime" -Value ":" -Force
New-ItemProperty -Path $registryPath -Name "sTimeFormat" -Value "HH:mm:ss" -Force
New-ItemProperty -Path $registryPath -Name "sShortTime" -Value "HH:mm" -Force
New-ItemProperty -Path $registryPath -Name "sYearMonth" -Value "MMMM yyyy" -Force


Write-Host "    Setting location to Ireland..."
Write-Host ""

# Set location to be Ireland
$registryPath = $registryPath + "\Geo"
New-ItemProperty -Path $registryPath -Name "Nation" -Value "68" -Force


Write-Host "    Turning Off IE Enhanced Security Configuration..."
Write-Host ""

# Turn Off IE Enchanced Security Configuration
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0


Write-Host "    Restarting Explorer.exe to Allow Changes to Take Effect..."
Write-Host ""

# Restart Explorer.exe Process to allow Registry Changes to take effect
Stop-Process -Name Explorer -Force
Start-Process -FilePath "explorer.exe"




####################  2. CONFIGURE DOMAIN & CONFIGURE SERVER TO BE PRIMARY DOMAIN CONTROLLER  ####################

Write-Host "1. Changes to the Registry"
Write-Host ""
Start-Sleep -s 1


Write-Host "    Installing Roles and Features Required..."
Write-Host ""

# Install Roles and Features for Domain Controller
Install-WindowsFeature -ConfigurationFilePath $dcConfigTemplatePath


Write-Host "    Starting Windows search Service..."
Write-Host ""

# Start Windows Search Service
Set-Service -Name "WSearch" -StartupType Automatic
Start-Service -Name "WSearch"


Write-Host "    Getting Details from Domain.csv..."
Write-Host ""

# Get Domain Information from CSV
$csv = Import-Csv $domainCSVPath -Delimiter ','
$csv | ForEach-Object {
    $fullDomain = $_.domain
    $username = $_.username
    $password = $_.password
    $primaryDC = $_.primaryDC
}
# Convert Password to Secure-String
$password = ConvertTo-SecureString $password -AsPlainText -Force


Write-Host "    Importing AD Domain Services Deployment..."
Write-Host ""

# Setup Active Directory Domain Services Deployment
Import-Module ADDSDeployment


Write-Host "    Creating the AD Forest..."
Write-Host "    Please Note the Server Will Reboot After This Step..."
Write-Host ""

# Set up Domain and Forest
$domain = $fullDomain.Substring( 0, $fullDomain.IndexOf( "." ) )

# Create the AD Forest
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode WinThreshold -DomainName $fullDomain -DomainNetbiosName $domain -ForestMode WinThreshold -InstallDns:$true -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -SafeModeAdministratorPassword $password -Force:$true



##########  SERVER WILL REBOOT  ##########

