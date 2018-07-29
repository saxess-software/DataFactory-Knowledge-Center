This manual shows how to move a local DataFactory Database to azure if you want transfer the whole Database.
The easier way is to export / import the Factories (bring them to same API version first !)


### On Azure
1. Create a new Database on Azure with Pool Alocation (don't move the existing database, it gets on Azure a different collation)
2. Create a Standard Cluster with API 4.0.74+ 
3. Connect to the cluster 
4. Delete the Factory "ZT" inside this Cluster
5. 
	TRUNCATE sx_pf_hLists
	TRUNCATE sx_pf_hFormats
	TRUNCATE sx_pf_hListValues





## On your local System

1. Update the Cluster to API 4.0.74+
2. Delete the API and all other logic using https://github.com/saxess-software/DataFactory-Knowledge-Center/blob/master/8.%20Harmonising%20standards/Create%20a%20project/Files%20for%20project%20folder/3%20DELETE_All_Views_Procedures_Functions.sql
3. TRUNCATE or decrease RowNumbers of sx_pf_API_Log  (as this can be very big)
4. Download and install Microsoft Data Migration Assistent https://www.microsoft.com/en-us/download/details.aspx?id=53595
5. Use Mode "Only Data" and transfer the table content




## On Azure

1. create the stuff of you customer API if there is any
2. create new user and give them rights
3. excecute "materialize_vUserRights"



