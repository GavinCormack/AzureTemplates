# AzureTemplates 

This Repository is for the rolling out of New Azure Companies.

It includes, 
* The JSON Template for Azure
* CSVs that should be filled out prior to running the Powershell Commands.
* Powershell commands to be run on each Server.



----
----


## JSON

In the JSON folder you will find a "Company-Temaplate.json" file.
* Open the file.
* Copy the Contents of the file.
* Open [Azure](https://portal.azure.com).
* Sign in.
* Click on  'All Services',  on the top left.
* Search for 'Template'.
* Click on it to open the Template blade.
* Click on the :heavy_plus_sign: to create a new Template.
* Enter 'createcompany' for the name.
* Enter 'CreateCompany' for the description.
* Paste the contents of the 'Company-Template.json' file into the ARM Template section.
* Click OK.
* Click Add.
* Select the Template and Click 'Deploy' at the top.
* Fill out the form as required.
* Tick the Accept License box at the bottom.
* Click the 'Purchase' button at the bottom to begin the roll out.
* It will take roughly 30-45 minutes for the infrastructure to roll out.



----
----


## CSV

In the CSV folder you will find users.csv and domain.csv.

* The Users.csv file can be sent to the Administrator/Liason of the company for them to fill out.
	* Make sure to send the Users.csv out to the company well before hand as the PowerShell Scripts depend upon this.
* The Domain.csv file needs to be filled out by us (Migrations Team) accordingly.



----
----


## PowerShell

In the PowerShell folder you will find the scripts needed to configure the Servers.

* Configure_Primary_DC - (Part 1)
	* Sets the Date and Time to GMT.
	* Sets Location to Ireland.
	* Turns off IE Enhanced Security Configuration in Server Manager.
	* Installs the Roles & Features required for Domain Controllers.
	* Pulls the details from the Domain.csv file to create the Domain.
* Configure_Primary_DC - (Part 2)
	* Sets Admin password to never expire.
	* Creates RDPUsers OU.
	* Creates RDPUsers Group.
	* Pulls users from the Users.csv file.
	* Adds users to the RDPUsers Group.
	* Installs Firefox and Google Chrome.
	* Opens two webpages in Google Chrome for downloads.
		* You need to download files yourself.
	* Extracts the downloaded files.
	* Configure ADMX files and GPO.
	* Moves Desktop Background image Background1.bmp to the C:\<folder_name> folder.

* Configure_Additional_DC - (Part 1)
	* Sets the Date and Time to GMT.
	* Sets the Locations to Ireland.
	* Turns off IE Enhanced Security Configuration in Server Manager.
	* Installs the Roles & Features required for Domain Controllers.
	* Pulls the details from the Domain.csv file to join the Domain as an additional Domain Controller.
* Configure_Additional_DC - (Part 2)
	* Installs Firefox and Google Chrome

* Configure_FileServer_or_SQLServer - (Part 1)
	* Sets the Date and Time to GMT.
	* Sets Location to Ireland.
	* Turns off IE Enhanced Security Configuration in Server Manager.
	* Pulls the details from the Domain.csv file to Join the Domain.
* Configure_FileServer_or_SQLServer - (Part 2)
	* Installs Firefox and Google Chrome

* Configure_RDSServer - (Part 1)
	* Sets the Date and Time to GMT.
	* Sets Location to Ireland.
	* Turns off IE Enhanced Security Configuration in Server Manager.
	* Pulls the details from the Domain.csv file to Join the Domain.
* Configure_RDSServer - (Part 2)
	* Installs the initial Roles & Features needed for a RDS Server.
* Configure_RDSServer - (Part 3)
	* Installs Firefox and Google Chrome




Once the Azure ARM Template has completed & the CSV files have been completed, we can begin running the PowerShell Scripts on the Servers.



#### Primary Domain Controller

* Move the following files onto the Primary Domain Controller:
	* Configure_Primary_DC - (Part 1)
	* Configure_Primary_DC - (Part 2)
	* DC_Config_Template.xml
	* Domain.csv
	* Users.csv

* Create a <folder_name> folder on the C Drive (C:\<folder_name>) and place the files in there.
* Once you have placed all the files in the folder, Run Powershell as Administrator.
	* Please note **NOT PowerShell ISE**, normal PowerShell (the navy/purple one).
* Once PowerShell opens, Change Directory to the <folder_name> folder you created and run the 'Configure_Primary_DC - (Part 1).ps1'.
* This will create the Domain as specified in the Domain.csv.
* It will then reboot the Server.

* Once the Server is back up, logon with the **Domain Admin Credentials**, not local Admin Credentials.
* Run PowerShell as Administrator again.
* Once PowerShell opens, Change Directory to the <folder_name> folder you created and run the 'Configure_Primary_DC - (Part 2).ps1'.
* This Script requires User Intervention.
* In Section 3, two webpages will be opened in Google Chrome.
* Download the ADMX_Template.zip , GPO.zip and Background1.bmp separately.
	* If you do not download them separately, they will not be named correctly (multi downloading the files can give them a different name).
* Once you have the 3 files in the Downloads folder, go back to the PowerShell Windows and continue the Script.
* Once the script finishes it will reboot the Server one last time.


##### TODO:
* Configure changes in GPO
	* Click the 'Start' button, and open 'Administrative Tools' on the right.
	* Click 'Group Policy Management'.
	* Expand down to the RDPUsers GPO.
	* Right click on it and click 'Edit'.
	* You will need to edit the following Policies:
		* Computer Configuration / Policies / Administrative Templates / Printers / Allow printers to be published -> Enabled
		* Computer Configuration / Policies / Administrative Templates / Windows Components / Remote Desktop Services / Remote Desktop Session Host / Licensing / Use the specified Remote Desktop license servers -> Enter the name of the RDS Server
		* User Configuration / Policies / Windows Settings / Folder Redirection -> Change the path of the folders
		* User Configuration / Policies / Administrative Templates / Desktop / Desktop / Desktop Wallpaper -> Change path to Primary DC
* Create a Starter GPO which open the "New Starter.docx" file at login.
* Create Mapped Drives Scripts.
* Share the C:\<folder_name> folder with everyone.


---


#### Additional Domain Controller

* Move the following files onto the Additional Domain Controller:
	* Configure_Additional_DC - (Part 1)
	* Configure_Additional_DC - (Part 2)
	* DC_Config_Template.xml
	* Domain.csv
	* Users.csv

* Create a <folder_name> folder on the C Drive (C:\<folder_name>) and place the files in there.
* Once you have placed all the files in the folder, Run Powershell as Administrator.
	* Please note **NOT PowerShell ISE**, normal PowerShell (the navy/purple one).
* Once PowerShell opens, Change Directory to the <folder_name> folder you created and run the 'Configure_Additional_DC - (Part 1).ps1'.
* This will join the Domain as specified in the Domain.csv.
* It will then reboot the Server.

* Once the Server is back up, logon with the **Domain Admin Credentials**, not local Admin Credentials.
* Run PowerShell as Administrator again.
* Once PowerShell opens, Change Directory to the <folder_name> folder you created and run the 'Configure_Additional_DC - (Part 2).ps1'.
* Once the script finishes it will reboot the Server one last time.


##### TODO:
* Nothing


---


#### File Server or SQL Server

* Move the following files onto the File Server / SQL Server:
	* Configure_FileServer_or_SQLServer - (Part 1)
	* Configure_FileServer_or_SQLServer - (Part 2)
	* FS-SQL_Config_Template.xml
	* Domain.csv
	* Users.csv

* Create a <folder_name> folder on the C Drive (C:\<folder_name>) and place the files in there.
* Once you have placed all the files in the folder, Run Powershell as Administrator.
	* Please note **NOT PowerShell ISE**, normal PowerShell (the navy/purple one).
* Once PowerShell opens, Change Directory to the <folder_name> folder you created and run the 'Configure_FileServer_or_SQLServer - (Part 1).ps1'.
* This will join the Domain as specified in the Domain.csv.
* It will then reboot the Server.

* Once the Server is back up, logon with the **Domain Admin Credentials**, not local Admin Credentials.
* Run PowerShell as Administrator again.
* Once PowerShell opens, Change Directory to the <folder_name> folder you created and run the 'Configure_FileServer_or_SQLServer - (Part 2).ps1'.
* Once the script finishes it will reboot the Server one last time.


##### TODO:
* If it is a File Server:
	* Configure the Data Disk Attached.
	* Create the Data folder, RDPUsers folder, <folder_name> folder etc.
* If it is a SQL Server:
	* Nothing


---


#### RDS Server

* Move the following files onto the Primary Domain Controller:
	* Configure_RDSServer - (Part 1)
	* Configure_RDSServer - (Part 2)
	* Configure_RDSServer - (Part 3)
	* RDS_Config_Template.xml
	* Domain.csv
	* Users.csv

* Create a <folder_name> folder on the C Drive (C:\<folder_name>) and place the files in there.
* Once you have placed all the files in the folder, Run Powershell as Administrator.
	* Please note **NOT PowerShell ISE**, normal PowerShell (the navy/purple one).
* Once PowerShell opens, Change Directory to the <folder_name> folder you created and run the 'Configure_RDSServer - (Part 1).ps1'.
* This will join the Domain as specified in the Domain.csv.
* It will then reboot the Server.

* Once the Server is back up, logon with the **Domain Admin Credentials**, not local Admin Credentials.
* Run PowerShell as Administrator again.
* Once PowerShell opens, Change Directory to the <folder_name> folder you created and run the 'Configure_RDSServer - (Part 2).ps1'.
* This will install the necessary Roles & Features needed.
* It will then reboot the Server.

* Once the Server is back up, logon with the **Domain Admin Credentials**, not local Admin Credentials.
* Run PowerShell as Administrator again.
* Once PowerShell opens, Change Directory to the <folder_name> folder you created and run the 'Configure_RDSServer - (Part 3).ps1'.
* This Script requires User Intervention.
* A webpages will be opened in Google Chrome.
* Download the 'Office 2016 Pro Plus - SW_DVD5_Office_Professional_Plus_2016_W32_English_MLF_X20-41353.ISO' file.
* Microsoft Silverlight will also download.
* You will need to configure the Server further before you can install these programs.


##### TODO:
* Further Configuration of the RDS Server (Session Deployment)
	* Open Server Manager.
	* Click 'Add Roles and Features'.
	* Click 'Remote Desktop Services Installation'.
	* Click 'Standard Deployment'.
	* Click 'Session-Based Desktop Deployment'.
	* Click the arrow on the next screens to move the Servers into the lists.
	* Click 'Restart the destination server automatically if required'.
	* Reboot the Server once it is complete, if it did not reboot itself. **(Make sure it has completed before rebooting)**
* User Collections need to be configured.
* Server needs to be licensed.
* Software needs to be installed.



---



