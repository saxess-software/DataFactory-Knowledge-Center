## How to create a local (and refreshable) Pivot Table from the DataFactory Webservice

### Precondition, you have:
* the CSV Download URL for your cluster, it looks like https://saxess2.planning-factory.com/csv-v3/Solution_Immobilien_PROD/Immobilien/
* which means https://saxess2.planning-factory.com/csv-v3/[Cluster]/[DATAOUTPUT_Type]/[FactoryID]/[ProductlineID]
* login credentials
* the Name of the DATAOUTPUT Type you need (e.g. Profit, Balance, Cash) 

This manual is written for Excel 2016, in Excel 2010/2013 the process is similar, but you must have installed the addin PowerQuery on your machine.

### Create a new Query

![Query](images/1.PNG)

### Enter your URL and credentials

![Query](images/2.PNG)
![Query](images/2b.PNG)


### Check the column delimiter

If the query has not been loaded correctly/ has not been loaded at all, please use the "refresh"-button. 

In order to move to the next step, please use the "process"-button.

![Query](images/Bild1.png)

### Delete the automaticly create step for Typ Definition
![Query](images/3b.PNG)

### Set all ID Columns to Type text and Year Month to type integer
![Query](images/4a.PNG)

### Set Value Columns to Decimal-US with country coding !
![Query](images/4b.PNG)
![Query](images/4c.PNG)
### Load to Datamodel, not into the sheet
![Query](images/5.PNG)

![Query](images/6.PNG)
### Create a PivotTable

![Query](images/7.PNG)

### Select Fields for the PivotTable
![Query](images/8.PNG)

### Refresh the Data any time you like
![Query](images/9.PNG)
