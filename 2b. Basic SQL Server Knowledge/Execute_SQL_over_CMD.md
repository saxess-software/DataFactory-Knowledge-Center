## How to execute an SQL Script over CMD

* create a text file and change the extension to .bat
* it just starts wit "sqlcmd"
* i = Path to the sql file (relativ or absolute, if there are spaces in " " - have in mind that a network drive is not mapped if the user is not login in (when the scheduler runs the script)
* o = Path to the output file (for logoutput), file will be created if exists not
* f = Coding -> use 65001 as our files are always UTF 8 without BOM
* S = to tell the Server with Instance if you don't wont to execute on localhost
* open CMD and enter sqlcmd -? for more parameters 
* PAUSE keeps the CMD window open during testing
* the script you excute must have an "USE Database" Statement - to tell the target Database

````
sqlcmd -i Linemanager_WartungsAPI.sql  -o Activate_WartungsAPI.log.txt -f 65001
PAUSE
````
