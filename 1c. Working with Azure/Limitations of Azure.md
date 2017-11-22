### Transfer a local Database to azure
* you can create an bacpac backup and restore it
* but prepare the Database before
    * set the default collation an collation of all columns to the collation of the azure server 
    * otherwise you will have collation conflicts using #tables, as the masterdb is running in server default collation

* collation problems are so mind bubbeling complex, that it often easierer to create a fresh database and export / import the factories

### There are some important features not supported from Azure at the moment

* there is no USE DATABASE on Azure - you can only be connected to one database and cant change this connection
* you can't change the default collation of an Azure Database (create a bacpac Backup, restore local, change local, restore on Azure)