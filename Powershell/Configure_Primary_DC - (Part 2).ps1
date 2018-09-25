
######################################################
###                                                ###
##  Configure Primary Domain Controller - (Part 2)  ##
###                                                ###
######################################################


# Global Variables
$scriptsPath = (Get-Item -Path ".\").FullName
$domainCSVPath = $scriptsPath + "\Domain.csv"
$usersCSVPath = $scriptsPath + "\Users.csv"
$downloadsPath = $env:UserProfile + "\Downloads\"
$gpoZipPath = $env:UserProfile + "\Downloads\GPO.zip"
$gpoPath = $env:UserProfile + "\Downloads\GPO"
$admxZipPath = $env:UserProfile + "\Downloads\ADMX_Templates.zip"
$admxPath = $env:UserProfile + "\Downloads\ADMX_Templates"
$backgroundPath = $env:UserProfile + "\Downloads\background1.bmp"


# Brief Overview of Script Contents
Write-Host "Configure Primary Domain Controller - (Part 2)"
Write-Host ""
Write-Host ""
Write-Host "This file takes care of:"
Write-Host ""
Start-Sleep -s 1
Write-Host "1. Changes to Active Directory"
Write-Host ""
Start-Sleep -s 1
Write-Host "2. Installing Firefox and Google Chrome"
Write-Host ""
Start-Sleep -s 1
Write-Host "3. Configuring ADMX & GPO"
Write-Host ""
Start-Sleep -s 1
Write-Host "User Intervention Needed:"
Write-Host "You will be prompted to download files in section 3"
Write-Host ""
Start-Sleep -s 4
Write-Host "Preparing...."
Start-Sleep -s 4

Write-Host ""
Write-Host ""



####################  1. CHANGES TO ACTIVE DIRECTORY  ####################

Write-Host "1. Changes to Active Directory"
Write-Host ""
Start-Sleep -s 1


Write-Host "    Setting Zadmin Password to Never Expire..."
Write-Host ""

# Set Zadmin Password to Never Expire
Set-ADUser -Identity "zadmin" -PasswordNeverExpires:$true


Write-Host "    Creating RDPUsers OU..."
Write-Host ""

# Create RDPUsers Organisational Unit
New-ADOrganizationalUnit -Name "RDPUsers"


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
$domain = $fullDomain.Substring( 0, $fullDomain.IndexOf( "." ) )
$ouPath = "OU=RDPUsers,DC=" + $domain + ",DC=local"


Write-Host "    Creating RDPUsers Group..."
Write-Host ""

# Create RDPUsers Group inside RDPUsers Organizational Unit
New-ADGroup –Name "RDPUsers" -GroupScope Global –Path $ouPath


Write-Host "    Gettings Users from Users.csv..."
Write-Host ""

$users = Import-Csv $usersCSVPath -Delimiter ","      
foreach ($user in $users) {            
    $displayname = $user.'Firstname' + " " + $user.'Lastname'            
    $userFirstname = $user.'Firstname'            
    $userLastname = $user.'Lastname'          
    $username = $user.'Username'            
    $upn = $user.'SAM' + $fullDomain               
    $password = $user.'Password'      
    
    Write-Host "        Creating User - " + $displayname + "..."
          
    New-ADUser -Name $displayname -DisplayName $displayname -SamAccountName $username -UserPrincipalName $upn -GivenName $userFirstname -Surname $userLastname -Description "" -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled $true -Path $ouPath -ChangePasswordAtLogon $false –PasswordNeverExpires $true -server $fullDomain           
    Add-ADGroupMember -Identity RDPUsers -Members $username
}




####################  2. SILENTLY INSTALL WEB BROWSERS  ####################

Write-Host "2. Installing Firefox and Google Chrome"
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




####################  3. DOWNLOAD & CONFIGURE GPO & ADMX  ####################

Write-Host "3. Configuring ADMX & GPO"
Write-Host ""
Start-Sleep -s 1


Write-Host "    Once Google Chrome Opens, Download Both Zip Files to Downloads Folder and Background1.bmp, Then Resume This Script..."
Write-Host ""
Start-Sleep -s 5
Write-Host "    Opening Google Chrome..."
Write-Host ""

# Open Webpage in Chrome
Start-Process -FilePath Chrome -ArgumentList "https://zinon-my.sharepoint.com/personal/gavin_zinon_ie/Documents/Forms/All.aspx?slrid=f7da919e-50f3-7000-546c-9979fd0f5fba&FolderCTID=0x01200016F9DDF3A879F443A5B37FBCCDFC302F&id=%2Fpersonal%2Fgavin_zinon_ie%2FDocuments%2FAzure_Setup%2FAzure_GPO"
Start-Process -FilePath Chrome -ArgumentList "https://zinon-my.sharepoint.com/personal/gavin_zinon_ie/Documents/Forms/All.aspx?slrid=822a929e-80cd-7000-546c-9799abfb2f71&FolderCTID=0x01200016F9DDF3A879F443A5B37FBCCDFC302F&id=%2Fpersonal%2Fgavin_zinon_ie%2FDocuments%2FAzure_Setup%2FDesktop%20Backgrounds"



Read-Host "    Press Enter Button to Resume Script..."
Write-Host ""




Write-Host "    Unzipping ADMX & GPO Zip Files..."
Write-Host ""

# Extract Zip files to Folders
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

Unzip $gpoZipPath $gpoPath
Unzip $admxZipPath $admxPath


Write-Host "    Changing Current Working Directory to Downloads..."
Write-Host ""

# Change Current Directory to User Downloads
Set-Location -Path $downloadsPath


Write-Host "    Transferring ADMX & ADML files into C:\Windows\PolicyDefinitions..."
Write-Host ""

# Move all ADMX files in current directory to C:\Windows\PolicyDefinistions folder
Get-ChildItem -Path ".\*.admx" -Recurse | Move-Item -Destination "C:\Windows\PolicyDefinitions\"

# Move all ADML files in current directory to C:\Windows\PolicyDefinistions\en-US folder
Get-ChildItem -Path ".\*.adml" -Recurse | Move-Item -Destination "C:\Windows\PolicyDefinitions\en-us\"


Write-Host "    Creating GPO For RDPUsers..."
Write-Host ""

# Create Group Policy Object & Links it tot the RDPUsers Organizational Unit
New-Gpo -Name "RDPUsers" | New-GpLink -Target $ouPath


Write-Host "    Importing GPO Settings..."
Write-Host ""

# Import GPO Settings into RDPUser GPO
Import-GPO -BackupGpoName RDPUsers -Path $gpoPath -TargetName RDPUsers


Write-Host "    Moving Desktop Background..."
Write-Host ""

# Move Desktop Background to C:\Zinon
Move-Item -Source $backgroundPath -Destination $scriptsPath




Write-Host ""
Write-Host "Script Complete!"
Write-Host ""



##########  SERVER WILL REBOOT  ##########

Write-Host "Rebooting Server in 10 seconds..."
Start-Sleep -s 10

Restart-Computer


