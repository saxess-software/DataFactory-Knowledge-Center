
## How to create a new Cluster on Azure

1. Connect the Azure Database Server with your * @saxess.onmicrosoft.com Login
2. Create the Database using the Azure DB create Script "Create Database with pool allocation' from API Deployment folder (AD0XXX_Name_Usage)
3. Execute API Create Script from API Deployment folder 
4. Execute script 'sx_pf_Create_DF_User_ClusterAdmin' to add you as user with role admin

-> now you can connect the cluster using the support@planning-factory.com identity and work with DataFactory as usual
-> in Azure only FactoryService exists as SQL Server User 


## How to transfer an existing cluster 



## How to connect an azure Cluster as User for Reporting with Excel pivot

### Http way over DATAOUTPUT Procedures
* as usual - nothing changed to other webclusters

### Direct Database Connection for User
(coming soon, needs creation of an database User and an Firewall rule)
