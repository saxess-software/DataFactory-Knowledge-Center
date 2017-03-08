

Every Product should have a correct Template - check existing Templates with 
````SQL
SELECT DISTINCT dP.Template FROM dbo.sx_pf_dProducts dP WHERE dP.FactoryID <> 'ZT'
````
