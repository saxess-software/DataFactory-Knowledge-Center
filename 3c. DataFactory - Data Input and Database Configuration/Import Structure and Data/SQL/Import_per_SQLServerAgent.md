

The SQL Server Agent can execute SQL Script or procedures regualary. This agent is very useful, but you have to consider some special points

### General
* it is not avaiable in SQL Express installations
* it must be configured to start as service with the computer, this must be done in service configuration
* You can do SQL Server Agent configuration only as sysadmin

### Right Configuration of Tasks
* Set the owner of the Task to a special user (after following step)  
![task_user](images/task_user.PNG "task_user")  
* this user you must give in system database "msdb" the roles SQLAgent*, otherwise you can't select  
![msdb_roles](images/msdb_roles.PNG "msdb_roles")  
* you must give rights in the DataFactory Usermanagement to the SQL Server Agent User **SX\SXMDB$** -> [Domain]\[Machinename] (maybe to be extended with instance), this user will be logged as executing user
![DFuser](images/DFuser.png) 

To check if a task is working, let it be executed from the agent by a taskplan - THAT's DIFFERENT from starting the task manually
You can create "one time" task to check it on demand
![](images/manuell.PNG)





