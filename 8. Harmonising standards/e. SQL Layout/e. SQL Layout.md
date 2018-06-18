## SQL Layout

* SELECT, FROM, WHERE on on level
* AS in the SELECT-clause on one level
* JOINs with one tab, ON with another
* AND/OR in the WHERE-clause: one tab

* all SQL-commands are written in capital letters
* above the JOINs belongs a comment with the purpose of the JOINs

* in front of the complete script and after belongs a blank line
* in the header belongs author, date, content, test call --> a fixed header should be determined
* the last line in a procedure/view script is a GO
* the footer should be a blank line, GO, blank line, GRANT EXECUTE ..., blank line, GO, blank line

* a procedure should start with DROP IF EXISTS, GO, CREATE PROCEDURE, AS, SET NOCOUNT ON --> then follows the declartion of parameters, general checks, determination of transaction user
* each topic is visualised via on row -------- and a second row --## topic #### ....
* an API log entry and/or process log entry should be included in each procedure

--> basic script layouts for procedures, views and tables are in the folder 8. Harmonising standards - e. SQL Layout
--> snippets in SQL management studio will be created
