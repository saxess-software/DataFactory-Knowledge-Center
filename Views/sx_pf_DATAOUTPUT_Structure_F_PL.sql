/*

DATAOUTPUT Procedure for analysing Strucure of Factories and Productlines
Stefan Lindenlaub 02/2017

*/


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sx_pf_DATAOUTPUT_Structure_F_PL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sx_pf_DATAOUTPUT_Structure_F_PL]
GO

CREATE PROCEDURE sx_pf_DATAOUTPUT_Structure_F_PL

AS 

SET NOCOUNT ON 





SELECT 
		  dPL.FactoryID
		 ,dPL.FactoryID + ' ' + dF.NameShort		AS FactoryIDName 
         ,dF.NameShort								AS FactoryName
         ,dF.ResponsiblePerson						AS FResponsiblePerson
         
		 ,dPL.ProductLineID
		 ,dPL.ProductLineID + ' ' + dPL.NameShort	AS ProductLineIDName
         ,dPL.NameShort								AS ProductLineName
         ,dPL.ResponsiblePerson						AS PLResponsiblePerson

         ,dPL.GlobalAttributeAlias1
		 ,dPL.GlobalAttributeSource1
         ,dPL.GlobalAttributeAlias2
		 ,dPL.GlobalAttributeSource2
         ,dPL.GlobalAttributeAlias3
		 ,dPL.GlobalAttributeSource3
         ,dPL.GlobalAttributeAlias4
		 ,dPL.GlobalAttributeSource4
         ,dPL.GlobalAttributeAlias5
		 ,dPL.GlobalAttributeSource5
         ,dPL.GlobalAttributeAlias6
		 ,dPL.GlobalAttributeSource6
         ,dPL.GlobalAttributeAlias7
		 ,dPL.GlobalAttributeSource7
         ,dPL.GlobalAttributeAlias8
		 ,dPL.GlobalAttributeSource8
         ,dPL.GlobalAttributeAlias9
		 ,dPL.GlobalAttributeSource9
         ,dPL.GlobalAttributeAlias10
		 ,dPL.GlobalAttributeSource10
         ,dPL.GlobalAttributeAlias11
		 ,dPL.GlobalAttributeSource11
         ,dPL.GlobalAttributeAlias12
		 ,dPL.GlobalAttributeSource12
         ,dPL.GlobalAttributeAlias13
		 ,dPL.GlobalAttributeSource13
         ,dPL.GlobalAttributeAlias14
		 ,dPL.GlobalAttributeSource14
         ,dPL.GlobalAttributeAlias15
		 ,dPL.GlobalAttributeSource15
         ,dPL.GlobalAttributeAlias16
		 ,dPL.GlobalAttributeSource16
         ,dPL.GlobalAttributeAlias17
		 ,dPL.GlobalAttributeSource17
         ,dPL.GlobalAttributeAlias18
		 ,dPL.GlobalAttributeSource18
         ,dPL.GlobalAttributeAlias19
		 ,dPL.GlobalAttributeSource19
         ,dPL.GlobalAttributeAlias20
		 ,dPL.GlobalAttributeSource20
         ,dPL.GlobalAttributeAlias21
		 ,dPL.GlobalAttributeSource21
         ,dPL.GlobalAttributeAlias22
		 ,dPL.GlobalAttributeSource22
         ,dPL.GlobalAttributeAlias23
		 ,dPL.GlobalAttributeSource23
         ,dPL.GlobalAttributeAlias24
		 ,dPL.GlobalAttributeSource24
         ,dPL.GlobalAttributeAlias25
		 ,dPL.GlobalAttributeSource25

  FROM   sx_pf_dProductLines dPL
      
         LEFT JOIN sx_pf_dFactories dF
                ON dPL.FactoryKey = dF.FactoryKey

GO

GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_Structure_F_PL TO pf_PlanningFactoryUser;
GRANT EXECUTE ON OBJECT ::sx_pf_DATAOUTPUT_Structure_F_PL TO pf_PlanningFactoryService;