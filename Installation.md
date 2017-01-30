# DataFactory - Options for Installation 

## Overview
DataFactory uses Microsoft SQL Server 2012 as core component. User access the system over a portable Excel Client or over the Webclient. The portable Excel Client runs from any computer, network drive or USB Disk. In bigger environments you can add the IIS based web components to access the system over the Webclient (Intranet or Internet access posssible)

### Database
As Database we can use any edition of Microsoft SQL Server 2012 or higher. We recommend
* up to 25 User Microsoft SQL Server Express
* up to 2.000 Users Microsoft SQL Server Standard
* above 2.000 User Microsoft SQL Enterprise 2016 (for using In-Memory-OLTP Technology)

### Clients
All Clients are free of installation, User can use:
* a portable Excel Client, running on all Excel Versions from 2010 (but not Excel for Macintosh, macros must be activateable)
* any current Webbrowser 

## Option 1: Cloudversion
Its the easiest way, you can use DataFactory without any database installation, we will provide you with your own database on our cloudserver for single user or multi user access.
* no installation necessary
* you can use DataFactory with Excel (portable client) or the webbrowser from every computer with internet access
* the first time, you must create an online account at www.plannning-factory.com for authentication
* the data are located on our german cloud server, but you can access them easy for backup and local usage
	* you can downlaod your data anytime as CSV file or connect to your database direct with Excel PowerQuery
	* we can provide you daily with an backup of your database
	* you can access data over our public API

## Option 2: Single User Installation
* install Microsoft SQL Server (with Management Studio) on a local PC
* activate TCP/IP for the database
* copy the portable Excel Client on the machine and define a connection

## Option 3a: Local Network with central Server and Excel Clients
* install SQL Server (with Management Studio) on a server in the local network
* activate TCP/IP for the database
* define a ActiveGroup which gets access to DataFactory
* give this AD Group the role "pf_PlanningFactoryUser" in the the DataFactory Database
* put the portable Excel Client on a network drive and define a connection using WindowsAuth
* the portable Excel Client is write protected and can be uses from all users simulataneus

## Option 3b: add the Webclient to 3a
* use a Windows 2012 R2 Server as Webserver
	* activate Rolle IIS
	* active Windows Auth for IIS (if you want to use WindowsAuth) or 
	  ensure internet access, then user can be authenticated using OAuth with User / PW
	* create a Windows User e.g. "FactoryService" to run the Webservice under this account
	* give "FactoryService" access to the database Server (server role only public) with the database role "pf_PlanningFactoryService" or create a SQL User for this

## Option 3c: enhance security using https for the webclient in the internet
* create a SHA-2 256 bit certificate
* check that User "FactoryService" is really only exists for DataFactory (and has NEVER administrator rights)
* check that the dbowner of the database is administrator or somebody else (but NEVER "FactoryService")

## If we shall develop custom solutions for you on your DataFactory, we need:
* possibility to create a RDP connection, using VPN oder Remote Desktop Gateway (please no access running in a webbrowser)
* Visual Studio Code (its open source software)
* GitHub Desktop (its open source software)
* SQL Server Management Studio
* Notepad++ 
* Excel on our Server
* sysadmin rights for SQL Server (only with sysamdin rights we can use SQL Server Agent, Debugger, Profiler etc.)
