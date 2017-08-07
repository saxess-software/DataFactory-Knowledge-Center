

### Staging
When importing Data into DataFactory, its a good idea to work with staging tables. 
This are tables created in the DataFactory Dabase to store the import Data temporary.
There are some advantages, compared to the option to import them direct with a SELECT on a different DataSource:

* eliminate collation problems
    * if you join a table from one database to a table from a different database with other collation, problems will come soon
* eliminate null problems
    * the target table has NOT NULL Columns
* eliminate ID problems
    * MandantenID is different in all Source Systems
* run check before import 
    * stage data - check for problems - import only when check passed
* you can stage "online" and import "offline"

````SQL
CREATE TABLE staging.Artikel (
   MandantenID NVARCHAR(255) NOT NULL
  ,ArtikelID NVARCHAR(255) NOT NULL
  ,ArtikelName NVARCHAR(255) NOT NULL
  )
  
 INSERT INTO staging.Artikel
    SELECT 
       Firma AS MandantenID
      ,Nummer AS ArtikelID,
      ,Coalesce (Name,'<Bezeichnung fehlt>') AS ArtikelName
    FROM 
      SourceDB.dbo.SourceTable
    WHERE
      Aktiv = TRUE
````
 
#### Formats in Staging
 
##### Dates
Its mostly recommend to stage Dates as Datetime  
  
Advantages
* non valid dates will crash in loading
* dates are easy to filter and to compare
 
Disadvantages
* empty fields will get Date 1900-01-01
 
  
