
#### Basic Join of DataFactory Tables
This is the basic way, we join the fact table sx_pf_fValues with the dimensions

Delete the joins you dont need to increase speed and keep statement simple. The View must be wraped in a Procedure, if execution shall be able for usual User accourding to right system.

````SQL
*/
Basic Join of DataFactory Tables
Gerd Tautenhahn for DataFactory 4.0
08/2017

Testcall
SELECT * FROM sx_pf_DemoJoin
/*

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sx_pf_DemoJoin]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sx_pf_DemoJoin]
GO

CREATE Procedure sx_pf_DemoJoin AS 

SELECT 
    fV.FactoryID
  ,dF.NameShort AS FactoryName
  ,fV.ProductLineID
  ,dPL.NameShort AS ProductLineName
  ,fV.ProductID
  ,dP.NameShort AS ProductName
  ,fV.ValueSeriesID
  ,dVS.NameShort AS ValueSeriesName
  ,TimeID
  ,TimeID/10000 AS [Year]
,TimeID/100%100 AS [Month]
,TimeID%100 AS [Day]
,CONVERT(Date,CAST(TimeID AS NVARCHAR)) AS [Date]
  ,CAST(fV.ValueInt AS Money)/dVS.Scale AS Value
  ,fV.ValueText

FROM 
  -- Basic fact table (ValueInt, ValueText, ValueComment)
  sx_pf_fValues fV

  -- for Factory Attributes (Name, RespPerson...)
  LEFT JOIN sx_pf_dFactories dF ON 
    fV.FactoryKey = dF.FactoryKey
  
  -- for Productline Attributes (Name, RespPerson..)
  LEFT JOIN sx_pf_dProductLines dPL ON
    fV.ProductLineKey = dPL.ProductLineKey

  -- for Product Attributes (Name, Status, Globalattributes 1..25)
  LEFT JOIN sx_pf_dProducts dP ON
    fV.ProductKey = dP.ProductKey

  -- for ValueSeries Attributes (Effect, VisibilityLevel, NumericFlag)
  LEFT JOIN sx_pf_dValueSeries dVS ON 
    fV.ValueSeriesKey = dVS.ValueSeriesKey

WHERE
    dF.FactoryID != 'ZT'  -- Filter the Templates
    
GO

GRANT EXECUTE ON OBJECT ::[dbo].[DemoJoin] TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::[dbo].[DemoJoin] TO pf_PlanningFactoryService;

GO

````
