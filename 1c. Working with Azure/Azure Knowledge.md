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

- a global administrator can not manage automaticly azure subscriptions, he must be given this right explicit in properties of the Directory

## Users an roles

- Azure is a collection of resource providers, which each over specific actions with URLs like an REST Service
- a role is the ability to perform a set of actions on a scope 
    - scope = a resource -> a resource group -> the subscription
    - role = reader -> specific set of rights -> contributer -> owner

    - owner 
        - actions {*}
        - not actions {}
        - owners should usually be glass break accounts
    - contributer
        - actions {*}
        - not actions 
            - {Authorization\*\Delete}
            - {Authorization\*\Write}
    - reader
        - actions {*\read} (sensitive actions never end in read)

    - robots should usually have rights only on resource level

    - resource specific roles like "Virtual machine contributer"

    - only roles have "not actions" - the user is calculated and has only grants "There is no deny - there is only grant !"

    - PIM = Privileged Identity Managment -> Just in time access on privileged level -> expires automaticly -> good to work as user and take owner role etc. only for one hour

- There is only one FTP User/PW per Subscription for Deployment of Application over FTP

- For SQL Server there must be ONE SQL-Auth based Servermanager, an can be one Azure AD based User or Usergroup as Serveradmin, rights of all other users must be granted on database level



### Transfer a local Database to azure
* you can create an bacpac backup and restore it
* but prepare the Database before
    * set the default collation an collation of all columns to the collation of the azure server 
    * otherwise you will have collation conflicts using #tables, as the masterdb is running in server default collation

* collation problems are so mind bubbeling complex, that it often easierer to create a fresh database and export / import the factories

### There are some important features not supported from Azure at the moment

* there is no USE DATABASE on Azure - you can only be connected to one database and cant change this connection
* you can't change the default collation of an Azure Database (create a bacpac Backup, restore local, change local, restore on Azure)