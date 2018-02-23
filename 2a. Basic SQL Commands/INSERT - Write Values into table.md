

## Simple Insert with VALUES


````SQL
INSERT INTO dbo.sx_pf_Process_Log VALUES
				 (@MainProcess,@SubProcess,@Step,@StepStatus, CURRENT_TIMESTAMP,@ValueText)
         
````


## Insert based on a SELECT Query

````SQL
INSERT INTO staging.tKostenstellen VALUES
				SELECT 
          Kostenstelle                  AS KostenstellenID
          COALESCE(Name,'<Name fehlt>') AS Kostenstellenname 
        FROM erp.dbo.Kostenstellen
````
