### Trigger task scheduler event via SQL stored procedure

- uses system extended stored procedure 'xp_logevent'  --> xp_logevent { error_number , 'message' } [ , 'severity' ] 
- membership in database role db_owner in master database or membership in server role sysadmin required
- writes message in SQL Server log file and Windows event viewer

- execution of scheduled task is triggered on event
- event = specific event-id, source and log 

