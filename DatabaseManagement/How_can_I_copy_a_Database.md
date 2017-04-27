
There are different ways to copy a database, you must consider
* do you have physical access to the database server or to a shared folder on it
* the SQL Server target version, if the target version is lower (e.g. from SQL 2014 to SQL 2012) a usual backup will not work
* if you have Express Edition or Standard Edition of SQL Server


# A: Create a Backup (bak) on the Source Server and restore it on the target Server
  * SQL Server can't create a Backup File only on a local disk of the Server, so you must have access to the Server or a shared folder on the server
  * The target Server must be same SQL Server Version or higher - check it on both Server with "SELECT @@version"


# B: Create bacpac export on the Source Server and restore it on the target server
  * bacpac can saved anywhere, not only on the database server - so you can use Management Studio on a different Server
  * the database must not have hard link to other databases (Server.database.schema.table), that's why delete views and stored procedures having those characteristics
  * The target Server must be same SQL Server Version or higher ?

# C: Tasks -> Copy database
  * works only if both servers are standard editon or higher
  * Servers must be in the same network


# D: Generate Scripts - this way works always
  * Tasks -> generate Scripts
  * use option "schema and data"
  * set compatibilty level to target server
  * create a target Database on target server
  * import over Managementstudio if file size is smaller than 300 MB
  * else add a USE Database statement for the target database in the script
  * import the script over "sqlcmd -i script.sql -o log.txt"   (write this command in a .bat file you place beside the script file)
  
  
