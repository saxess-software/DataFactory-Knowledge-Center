# Installation of the DataFactory WebComponents

## Preparations

### Add Roles and Features to you Win 2012 R2 Server

Start the Servermanager and edit Roles and Features  
![Servermanager](images/WebComponents/1.PNG)


Add Windows Auth to IIS  
![WindowsAuth](images/WebComponents/2.PNG)

Add ISAPI and ASP.NET 4.5  
![ISAPI](images/WebComponents/3.PNG)

### Create a DOMAIN User "Domain\FactoryService" - a Standard User, NO Admin Rights anywhere
(at the screenshot the domain is missing, we learnt it a bit later the hard way..)
![FactoryService](images/WebComponents/3b.PNG)

Add this user to SQL Server  
![FactoryService](images/WebComponents/3c.PNG)

Keep only public rights on server level  
![FactoryService](images/WebComponents/3d.PNG)

Give role pf_PlanningFactoryService in the DataFactory Database  
![FactoryService](images/WebComponents/3e.PNG)

## Do Configuration of IIS Server

Start IIS Manager  
![IIS](images/WebComponents/4.PNG)

Enter Authentication of Default Website  
![IIS](images/WebComponents/5.PNG)

Activate Windows Auth  
![IIS](images/WebComponents/6.PNG)

Deactivate Anonymous Auth  
![IIS](images/WebComponents/7.PNG)

Delete default Website content  
![IIS](images/WebComponents/8.PNG)

Unzip the DataFactory Application here  
![IIS](images/WebComponents/9.PNG)

Without Subdirectory on unzip  
![IIS](images/WebComponents/10.PNG)

Delete zip file after that, to have this directory structure  
![IIS](images/WebComponents/11.PNG)

Copy config.ini.example and rename to Config.ini  
![IIS](images/WebComponents/12.PNG)

Open config.ini from a Admin Notepad  
![IIS](images/WebComponents/12b.PNG)

Delete SQL based connection string and use Windows Auth  
![IIS](images/WebComponents/13.PNG)

Do configuration of connection string to the DataFactory Database  
WindowsAuth = true/false means here if the Users will be identified by Windows or sxIDServer.
![IIS](images/WebComponents/14.PNG)

Set Identity of Application Pool to FactoryService   
![IIS](images/WebComponents/17.PNG)

Set Timeout   
![IIS](images/WebComponents/18.PNG)

Set Always running  
![IIS](images/WebComponents/19.PNG)

Restart Webserver (not only site) - as Site is "AlwaysRunning"
![IIS](images/WebComponents/22.PNG)

You should see this in any browser on localhost  
![IIS](images/WebComponents/23.PNG)

You should see your Factory on localhost/[DataBaseName]  
![IIS](images/WebComponents/24.PNG)

Give AppData Write Rights to FactoryService  
![IIS](images/WebComponents/25.PNG)

Tell the users the URL http://[Servername].Domain\[DataBaseName]  This should be FQDN e.g. http://web1.sx.intern/DataFactory
![IIS](images/WebComponents/27.PNG)

Other things to think on:  
* Maybe you must add this URL to the trusted Website for Internet Explorer
* Firefox don't support WindowsAuth in default - there is always a Pop-Up for credentials
* IE and Edge support WindowsAuth with Single SignOn


Enjoy for 5 minutes - and go on.
