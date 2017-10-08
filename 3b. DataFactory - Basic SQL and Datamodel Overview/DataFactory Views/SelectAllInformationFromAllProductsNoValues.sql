SELECT 
		  dP.FactoryID
         ,dP.ProductLineID
         ,dP.ProductID

		 ,dP.FactoryID + ' ' + dF.NameShort			AS FactoryIDName 
         ,dF.NameShort								AS FactoryName
         ,dF.ResponsiblePerson						AS FResponsiblePerson

		 ,dP.ProductLineID + ' ' + dPL.NameShort	AS ProductLineIDName
         ,dPL.NameShort								AS ProductLineName
         ,dPL.ResponsiblePerson						AS PLResponsiblePerson

		 ,dP.ProductID + ' ' + dP.NameShort		AS ProductIDName
         ,dP.NameShort								AS ProductName
		 ,dP.ResponsiblePerson						AS PResponsiblePerson

         ,dP.[Status]
         ,dP.GlobalAttribute1
         ,dP.GlobalAttribute2
         ,dP.GlobalAttribute3
         ,dP.GlobalAttribute4
         ,dP.GlobalAttribute5
         ,dP.GlobalAttribute6
         ,dP.GlobalAttribute7
         ,dP.GlobalAttribute8
         ,dP.GlobalAttribute9
         ,dP.GlobalAttribute10
         ,dP.GlobalAttribute11
         ,dP.GlobalAttribute12
         ,dP.GlobalAttribute13
         ,dP.GlobalAttribute14
         ,dP.GlobalAttribute15
         ,dP.GlobalAttribute16
         ,dP.GlobalAttribute17
         ,dP.GlobalAttribute18
         ,dP.GlobalAttribute19
         ,dP.GlobalAttribute20
         ,dP.GlobalAttribute21
         ,dP.GlobalAttribute22
         ,dP.GlobalAttribute23
         ,dP.GlobalAttribute24
         ,dP.GlobalAttribute25

  FROM   sx_pf_dProducts dP
         LEFT JOIN sx_pf_dProductLines dPL
                ON dP.ProductLineKey = dPL.ProductLineKey
         LEFT JOIN sx_pf_dFactories dF
                ON dP.FactoryKey = dF.FactoryKey