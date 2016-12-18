## Optional Paramters
Are Procedure Parameter which can passed, but don't need to be passend. You need it, if you want to use the same Procedure as Pivot 
View for Webclient (which passes a FactoryID to get one Factory) and for a XLS Pivot
(which passes no FactoryID to get all Factories, to filter over slicer)

* the Procedure Paramter gets a default Value in it declaration
* when you filter the output, filter over a OR Clause for default Value (= NO Filter, never happens when value passed) or passed Value

````SQL
CREATE PROCEDURE Demo (@FactoryID NVARCHAR(255) = '') 

AS

SELECT 
  *
FROM sx_pf_dFactories  
WHERE  
    (@Factory = '' OR FactoryID = @FactoryID) AND 
    Factory != 'ZT'
````
