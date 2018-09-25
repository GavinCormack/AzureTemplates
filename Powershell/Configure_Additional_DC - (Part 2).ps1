
#########################################################
###                                                   ###
##  Configure Additional Domain Controller - (Part 1)  ##
###                                                   ###
#########################################################


# Global Variables
$downloadsPath = $env:UserProfile + "\Downloads\"
$dcConfigTemplatePath = $env:UserProfile + "\Downloads\DC_Config_Template.xml"


# Brief Overview of Script Contents
Write-Host "Configure Additional Domain Controller - (Part 2)"
Write-Host ""
Write-Host ""
Write-Host "This file takes care of:"
Write-Host ""
Start-Sleep -s 1
Write-Host "1. Silently Install Web Browsers"
Write-Host ""
Start-Sleep -s 1
Write-Host "Preparing...."
Start-Sleep -s 4

Write-Host ""
Write-Host ""


####################  1. SILENTLY INSTALL WEB BROWSERS  ####################

Write-Host "1. Installing Firefox and Google Chrome"
Write-Host ""
Start-Sleep -s 1


Write-Host "    Setting Firefox & Google Chrome Download Source & Destinations..."
Write-Host ""

# Locations of Firefox and Google Chrome Installers
$firefoxSource = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"
$chromeSource = "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B1602F39F-1858-03E8-7BA6-E448842F3462%7D%26lang%3Den%26browser%3D3%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe"

# Location of Downloaded Installer Files
$firefoxDestination = "$downloadsPath\firefox.exe"
$chromeDestination = "$downloadsPath\ChromeSetup.exe"


Write-Host "    Downloading Firefox & Google Chrome installers..."
Write-Host ""

# Download the Web Browser Installers
# Check if Invoke-Webrequest exists otherwise execute WebClient
if (Get-Command 'Invoke-WebRequest')
{
    # Download the files to specified locations
    Invoke-WebRequest $firefoxSource -OutFile $firefoxDestination
    Invoke-WebRequest $chromeSource -OutFile $chromeDestination
}
else
{
    # Download the files to specified locations
    $webClient = New-Object System.Net.WebClient
    $webclient.DownloadFile($firefoxSource, $firefoxDestination)
    $webClient = New-Object System.Net.WebClient
    $webclient.DownloadFile($chromeSource, $chromeDestination)
}


Write-Host "    Installing Firefox..."
Write-Host ""

# Start the silent installation of Firefox
Start-Process -FilePath "$downloadsPath\firefox.exe" -ArgumentList "/S"

# Wait 40 Seconds to allow the installation to complete
Start-Sleep -s 40


Write-Host "    Installing Google Chrome..."
Write-Host ""

# Start the silent installation of Google Chrome
Start-Process -FilePath "$downloadsPath\ChromeSetup.exe" -ArgumentList "/silent /install"

# Wait 80 Seconds to allow the installation to complete
Start-Sleep -s 80



Write-Host ""
Write-Host "Script Complete!"
Write-Host ""



##########  SERVER WILL REBOOT  ##########

Write-Host "Rebooting Server in 10 seconds..."
Start-Sleep -s 10

Restart-Computer
