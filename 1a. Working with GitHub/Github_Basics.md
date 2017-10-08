
### Repository
* a Repository can't be bigger than 1 GB (its counted without space for releases)
* we use Repositories for
    * development the software
    * save project specific code per customer in a customer repository
    * publish informations via GitHub Pages
* be very careful with encoding. All plain text files must be encoded in UTF 8 (without BOM)
* ANSI Coding lead to crashed special characters, **UTF 16 coding makes the files looking for GitHub as Binary**
* Folders are  not sorted correct, if they are numbered. They must be numbered with leading zeros to be orderd correctly like 
    * 01. Start
    * 02. Next 
    * .. else 10 comes after 1, before 2
* Folders without files can not be commited to github
* Folders without files and only one subfolder are shown as path to the last folder with a file
* Deleting a branch in the local repository dont deletes this branch in the remote repository
* commit often, every atomic useful change - as the commit is easy to understand and you can roll this quantum back

### Editor and Configuration
* there are three places for configurations like gitignore
   * for the user
   * in the working tree
   * (a third one I forgot)
````
Edit the gitignore to ignore temporary xls files
~$*.*    #temporäre Excel Dateien
````
### Issues
Issues belong to the repository. Not to a branch or a project.
Show all today closed issues - for time booking.
  * closed:2016-12-08 one day  
  * closed:2016-12-08..2016-12-10 some days

### Projects
* are a collection of cards 
* a card can be a plain card or an issue
* cards have very limited space for text as long as they are not issues, the text it not mouse selectable
* plan cards can be converted to issues
* Projects can be used to  
  * collect ideas which are not ready to be a ticket
  * order the tickets, which are to do next and to move them line by line trough the steps they should go

### Github pages
* can be created for any repo from one choosen branch
* they are always public, even when the repository is private
* will be autocread for a repo with the name of the organization
* to be rendered, a page must have two lines with --- in the head as jekyll marker
* the sites will be linked without extension, so e.g. content\site if there is a file site.md
* jekyll is parsing the markdown code to html - but never adds any body / head etc. this must come from somewhere else (include files etc.)
* if jekyll shall include files, they must be placed in a folder _includes and are referenced without path
* layout definitions must be placed in a folder _layouts

### Best practices coming from Github side
* the master branch should always be deployable
* you can't write colored text with markdown
* you can use (partly colored) unicode symbols http://apps.timwhitlock.info/emoji/tables/unicode with &#x[Code]; e.g. &#x1F534;
* you can create links to files inside github (just copy browser url) and even to lines of code https://help.github.com/articles/getting-permanent-links-to-files/

### Wiki
* Github Wiki is at the moment not useful for us
    * it can't be viewed in nice way from users, always running in Github frame

### Abbreviations used in this GitHub Organization

CRUD - short for Create, Update, Delete - the basic things you can do with nearly everything in life

DF - DataFactory - the cool tool for planning and organizing things and life 

PDT - ProductDataTable - the most complexe part of DF, where you enter the values

    
    

    
    
