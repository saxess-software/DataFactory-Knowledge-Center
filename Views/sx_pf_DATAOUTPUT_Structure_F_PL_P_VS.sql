/*

DATAOUTPUT Procedure for analysing Factories, Productlines and Products and ValueSeries
Stefan Lindenlaub 02/2017

*/


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sx_pf_DATAOUTPUT_Structure_F_PL_P_VS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sx_pf_DATAOUTPUT_Structure_F_PL_P_VS]
GO

CREATE PROCEDURE sx_pf_DATAOUTPUT_Structure_F_PL_P_VS

AS 

SET NOCOUNT ON 



SELECT    dP.FactoryID + ' ' + dF.NameShort			AS FactoryIDName 
         ,dP.ProductLineID + ' ' + dPL.NameShort	AS ProductLineIDName
         ,dP.ProductID + ' ' + dP.NameShort			AS ProductIDName
         ,dVS.ValueSeriesID + ' ' + dVS.NameShort	AS ValueSeriesIDName
		 ,dVS.Effect								AS Effect
		 ,dVS.IsNumeric								AS IsNumeric
		 ,dVS.Unit									AS Unit
		 ,dVS.Scale									AS Scale

        

  FROM   dbo.sx_pf_dValueSeries dVS
	LEFT JOIN dbo.sx_pf_dProducts dP
		ON dVS.ProductKey = dP.ProductKey
    LEFT JOIN sx_pf_dProductLines dPL
        ON dVS.ProductLineKey = dPL.ProductLineKey
    LEFT JOIN sx_pf_dFactories dF
        ON dVS.FactoryKey = dF.FactoryKey


GO

GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_Structure_F_PL_P_VS TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_Structure_F_PL_P_VS TO pf_PlanningFactoryService;