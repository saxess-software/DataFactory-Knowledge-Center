/*

DATAOUTPUT Procedure for analysing Factories, Productlines and Products
Stefan Lindenlaub 02/2017

*/


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sx_pf_DATAOUTPUT_Structure_F_PL_P]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sx_pf_DATAOUTPUT_Structure_F_PL_P]
GO

CREATE PROCEDURE sx_pf_DATAOUTPUT_Structure_F_PL_P

AS 

SET NOCOUNT ON 



SELECT 
		  dP.FactoryID
		 ,dP.FactoryID + ' ' + dF.NameShort			AS FactoryIDName 
         ,dF.NameShort								AS FactoryName
         ,dF.ResponsiblePerson						AS FResponsiblePerson
         
		 ,dP.ProductLineID
		 ,dP.ProductLineID + ' ' + dPL.NameShort	AS ProductLineIDName
         ,dPL.NameShort								AS ProductLineName
         ,dPL.ResponsiblePerson						AS PLResponsiblePerson

         ,dP.ProductID
		 ,dP.ProductID + ' ' + dP.NameShort			AS ProductIDName
         ,dP.NameShort								AS ProductName
		 ,dP.ResponsiblePerson						AS PResponsiblePerson

         ,dP.[Status]
		 ,dPL.GlobalAttributeAlias1
         ,dP.GlobalAttribute1
		 ,dPL.GlobalAttributeAlias2
         ,dP.GlobalAttribute2
		 ,dPL.GlobalAttributeAlias3
         ,dP.GlobalAttribute3
		 ,dPL.GlobalAttributeAlias4
         ,dP.GlobalAttribute4
		 ,dPL.GlobalAttributeAlias5
         ,dP.GlobalAttribute5
		 ,dPL.GlobalAttributeAlias6
         ,dP.GlobalAttribute6
		 ,dPL.GlobalAttributeAlias7
         ,dP.GlobalAttribute7
		 ,dPL.GlobalAttributeAlias8
         ,dP.GlobalAttribute8
		 ,dPL.GlobalAttributeAlias9
         ,dP.GlobalAttribute9
		 ,dPL.GlobalAttributeAlias10
         ,dP.GlobalAttribute10
		 ,dPL.GlobalAttributeAlias11
         ,dP.GlobalAttribute11
		 ,dPL.GlobalAttributeAlias12
         ,dP.GlobalAttribute12
		 ,dPL.GlobalAttributeAlias13
         ,dP.GlobalAttribute13
		 ,dPL.GlobalAttributeAlias14
         ,dP.GlobalAttribute14
		 ,dPL.GlobalAttributeAlias15
         ,dP.GlobalAttribute15
		 ,dPL.GlobalAttributeAlias16
         ,dP.GlobalAttribute16
		 ,dPL.GlobalAttributeAlias17
         ,dP.GlobalAttribute17
		 ,dPL.GlobalAttributeAlias18
         ,dP.GlobalAttribute18
		 ,dPL.GlobalAttributeAlias19
         ,dP.GlobalAttribute19
		 ,dPL.GlobalAttributeAlias20
         ,dP.GlobalAttribute20
		 ,dPL.GlobalAttributeAlias21
         ,dP.GlobalAttribute21
		 ,dPL.GlobalAttributeAlias22
         ,dP.GlobalAttribute22
		 ,dPL.GlobalAttributeAlias23
         ,dP.GlobalAttribute23
		 ,dPL.GlobalAttributeAlias24
         ,dP.GlobalAttribute24
		 ,dPL.GlobalAttributeAlias25
         ,dP.GlobalAttribute25

  FROM   sx_pf_dProducts dP
    LEFT JOIN sx_pf_dProductLines dPL
        ON dP.ProductLineKey = dPL.ProductLineKey
    LEFT JOIN sx_pf_dFactories dF
        ON dP.FactoryKey = dF.FactoryKey


GO

GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_Structure_F_PL_P TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_Structure_F_PL_P TO pf_PlanningFactoryService;