If your Windows Admin is not an SQL Server Admin, do the following steps to get SQL Admin rights

1. Stop SQL Server, close Managementstudio and all other connected tools
2. Go to SQL Server Configuration Manager -> Properties of the Service -> Add Startparameter "-m"
3. Start SQL Management Studio and login as Windows User -> now you should be Admin
4. Give yourself sysadmin rights
5. Remove Parameter -m in Konfiguration Manager
6. Restart SQL Server Service