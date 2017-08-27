

REM: Stellt die Datenbanken mit WindowsAuth wieder her
REM: Change .bak Filename after Version was changed and new backup created
SqlCmd -E -Q "RESTORE DATABASE PlanningFactory4k_DailyRestore FROM  DISK = 'E:\Daten\PlanningFactoryTesting\TestDatabasesBackups\PlanningFactory4k_4.0.28.bak' WITH MOVE 'PlanningFactory4k' TO 'E:\Daten\PlanningFactoryTesting\TestDatabasesData\PlanningFactory4k.mdf',MOVE 'PlanningFactory4k_log' TO 'E:\Daten\PlanningFactoryTesting\TestDatabasesData\PlanningFactory4k.log', NOUNLOAD, REPLACE, STATS = 10"


REM: Legt in der Datenbank einen User an und vergibt dbowner Rechte
SqlCmd -E -Q "USE PlanningFactory4k_DailyRestore CREATE USER [SX] FOR LOGIN [SX]"
SqlCmd -E -Q "USE PlanningFactory4k_DailyRestore EXEC sp_addrolemember N'db_owner', N'SX'"

REM pause

