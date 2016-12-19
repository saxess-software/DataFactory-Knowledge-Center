
# Your have access to the Windows Server where the Database is running
  * create a backup and restore it (customer server must have your version or lower of SQL Server)



# You don't have access to Windows Server with the Database, but you have access over ManagementStudio from another computer

* the way over bacpac export
  * the database must not have hard link to other databases (Server.database.schema.table)

* the way over Tasks -> Copy database
  * works only if both servers are standard editon or higher

* the way over generate scripts
  * use option "schema and data"
  * option USE Database = FALSE
  * import over Managementstudio only if file smaller than 300 MD
  * else import over sqlcmd
  
  
