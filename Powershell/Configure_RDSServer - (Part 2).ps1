
#########################################
###                                   ###
##  Configure  RDSL Server - (Part 2)  ##
###                                   ###
#########################################


# Global Variables
$downloadsPath = $env:UserProfile + "\Downloads\"
$rdsConfigTemplatePath = $env:UserProfile + "\Downloads\RDS_Config_Template.xml"


# Brief Overview of Script Contents
Write-Host "Configure  RDS Server - (Part 2)"
Write-Host ""
Write-Host ""
Write-Host "This file takes care of:"
Write-Host ""
Start-Sleep -s 1
Write-Host "1. Installing Initial Roles & Features"
Write-Host ""
Start-Sleep -s 1
Write-Host "Preparing...."
Start-Sleep -s 4

Write-Host ""
Write-Host ""



####################  1. INSTALLING INITIAL ROLES & FEATURES  ####################

Write-Host "1. Installing Initial Roles & Features"
Write-Host ""
Start-Sleep -s 1


Write-Host "    Installing Roles and Features Required..."
Write-Host ""

# Install Server Roles/Features
Install-WindowsFeature -ConfigurationFilePath $rdsConfigTemplatePath

# Start Windows Search Service
Set-Service -Name "WSearch" -StartupType Automatic
Start-Service -Name "WSearch"



##########  SERVER WILL REBOOT  ##########

Write-Host "Rebooting Server in 10 seconds..."
Start-Sleep -s 10

Restart-Computer
