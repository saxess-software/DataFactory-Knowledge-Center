# Rights and User

## The Directory

- the highest object is an "Azure AD tenant" -> this an Active Directory in the cloud -> mostly called a "Directory"
    - subscriptions belong always to one "Azure AD tenant" and trust this
    - there are subscriptions to buy different services, so you can by an "Office 365 subscription" or "Azure subscriptons" or "Dynamics 365" subscriptions
    - User always belong to an "Azure AD tenant"
    - a User can have an Directory Role and be member of groups
        - Directory Roles can be "User", "Global Administrator", "Limited Administrator"
            - Global Adminstrators have access to all directory ressources
            - Limited Administrator have a special role in the Directory (e.g. Billing, User Administration)

- the functions in the directory depend on the Directory Licence -> Free, Basic, Premium ... 
    - with an Office 365 subscription you seam to get an Basic Directory licence

- the only global administrator of an Directory should be an "glass-break account" 
    -> which is only used for very limited task
    -> all work should be done by users with limited roles





### Transfer a local Database to azure
* you can create an bacpac backup and restore it
* but prepare the Database before
    * set the default collation an collation of all columns to the collation of the azure server 
    * otherwise you will have collation conflicts using #tables, as the masterdb is running in server default collation

* collation problems are so mind bubbeling complex, that it often easierer to create a fresh database and export / import the factories

### There are some important features not supported from Azure at the moment

* there is no USE DATABASE on Azure - you can only be connected to one database and cant change this connection
* you can't change the default collation of an Azure Database (create a bacpac Backup, restore local, change local, restore on Azure)