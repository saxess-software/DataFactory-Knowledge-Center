

DELETE FROM sx_pf_API_Log 

UPDATE sx_pf_dFactories SET NameShort = 'Demofactory' WHERE FactoryID != 'ZT'

UPDATE sx_pf_dProductlines SET NameShort = 'Demoproductline'  WHERE FactoryID != 'ZT'

UPDATE sx_pf_dProducts SET 
	 NameShort = 'Demoproduct'
	,ResponsiblePerson = ''
	,GlobalAttribute1 = '' 
	,GlobalAttribute2 = ''
	,GlobalAttribute3 = ''
	,GlobalAttribute4 = ''
	,GlobalAttribute5 = ''
	,GlobalAttribute6 = ''
	,GlobalAttribute7 = ''
	,GlobalAttribute8 = ''
	,GlobalAttribute9 = ''
	,GlobalAttribute11 = ''
	,GlobalAttribute12 = ''
	,GlobalAttribute13 = ''
	,GlobalAttribute14 = ''
	,GlobalAttribute15 = ''
	,GlobalAttribute16 = ''
	,GlobalAttribute17 = ''
	,GlobalAttribute18 = ''
	,GlobalAttribute19 = ''
	,GlobalAttribute20 = ''
	,GlobalAttribute21 = ''
	,GlobalAttribute22 = ''
	,GlobalAttribute23 = ''
	,GlobalAttribute24 = ''


WHERE FactoryID != 'ZT'