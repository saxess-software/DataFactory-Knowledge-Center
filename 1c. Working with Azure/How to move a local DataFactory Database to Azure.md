This manual shows how to move a local DataFactory Database to azure if you want transfer the whole Database.
The easier way is to export / import the Factories (bring them to same API version first !)


### On Azure
1. Create a new Database on Azure with Pool Alocation (don't move the existing database, it gets on Azure a different collation)
2. Executing only the DataFactory Tablescript (without API..)

## On your local System

1. Update the Cluster the same API as you created on Azure
2. Prepare the DB, by limiting API Log and deleting Tables which may be historic fragments
        DELETE FROM sx_pf_API_Log WHERE LogKey NOT IN 
                        (
                            SELECT TOP 100 Logkey FROM sx_pf_API_Log ORDER BY LogKey DESC
                        )

        DROP TABLE sx_pf_dAttributes
        DROP TABLE sx_pf_dTimeMonth
        DROP TABLE sx_pf_pExchangeRates
4. Download and install Microsoft Data Migration Assistent https://www.microsoft.com/en-us/download/details.aspx?id=53595
5. Use Mode "Only Data" and transfer the table content


## On Azure

1. Execute the API Script
2. create the User FactoryService by Script from publish
3. create the User support@planning-factory.com by Script from publish
4. you can connect now, delete old users which may exist















