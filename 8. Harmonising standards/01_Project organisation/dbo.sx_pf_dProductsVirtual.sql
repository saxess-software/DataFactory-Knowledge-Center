/*
Table for Dimension Product
Gerd Tautenhahn for saxess-software gmbh 
02/2018 for DataFactory 4.0

-- Sample to create a Virtual Product for one Productline of every Factory

DELETE FROM dbo.sx_pf_dProductsVirtual WHERE ProductlineID = '1';

INSERT INTO dbo.sx_pf_dProductsVirtual
	SELECT 
	     ProductlineKey
		,FactoryKey
		,'1' AS ProductID
		,ProductlineID
		,FactoryID
		,''			AS TimeType
		,'virtueller anonymer Mitarbeiter'
		,''			AS NameLong
		,''			AS CommentUser
		,''			AS CommentDev
		,''			AS ResponsiblePerson
		,''			AS ImageName
		,'Aktiv'	AS Status
		,''			AS Template
		,''			AS TemplateVersion
		,'','','','','','','','','',''
		,'','','','','','','','','',''
		,'','','','',''
	FROM 
		dbo.sx_pf_dProductlines
	WHERE 
		ProductlineID = '1';


SELECT * FROM dbo.sx_pf_dProductsVirtual;

*/


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.sx_pf_dProductsVirtual') AND type in (N'U'))
	DROP TABLE dbo.sx_pf_dProductsVirtual;

GO

CREATE TABLE dbo.sx_pf_dProductsVirtual

	(
		 ProductKey			INT				NOT NULL IDENTITY (-1,-1)
		,ProductLineKey		INT				NOT NULL
		,FactoryKey			INT				NOT NULL
		,ProductID			NVARCHAR(255)	NOT NULL
		,ProductLineID		NVARCHAR(255)	NOT NULL
		,FactoryID			NVARCHAR(255)	NOT NULL
		,TimeType			NVARCHAR(255)	NOT NULL
		,NameShort			NVARCHAR(255)	NOT NULL
		,NameLong			NVARCHAR(255)	NOT NULL
		,CommentUser		NVARCHAR(MAX)	NOT NULL
		,CommentDev			NVARCHAR(MAX)	NOT NULL
		,ResponsiblePerson	NVARCHAR(255)	NOT NULL
		,ImageName			NVARCHAR(255)	NOT NULL
		,[Status]			NVARCHAR(255)	NOT NULL
		,Template			NVARCHAR(255)	NOT NULL
		,TemplateVersion	NVARCHAR(255)	NOT NULL
		,GlobalAttribute1	NVARCHAR(255)	NOT NULL
		,GlobalAttribute2	NVARCHAR(255)	NOT NULL
		,GlobalAttribute3	NVARCHAR(255)	NOT NULL
		,GlobalAttribute4	NVARCHAR(255)	NOT NULL
		,GlobalAttribute5	NVARCHAR(255)	NOT NULL
		,GlobalAttribute6	NVARCHAR(255)	NOT NULL
		,GlobalAttribute7	NVARCHAR(255)	NOT NULL
		,GlobalAttribute8	NVARCHAR(255)	NOT NULL
		,GlobalAttribute9	NVARCHAR(255)	NOT NULL
		,GlobalAttribute10	NVARCHAR(255)	NOT NULL
		,GlobalAttribute11	NVARCHAR(255)	NOT NULL
		,GlobalAttribute12	NVARCHAR(255)	NOT NULL
		,GlobalAttribute13	NVARCHAR(255)	NOT NULL
		,GlobalAttribute14	NVARCHAR(255)	NOT NULL
		,GlobalAttribute15	NVARCHAR(255)	NOT NULL
		,GlobalAttribute16	NVARCHAR(255)	NOT NULL
		,GlobalAttribute17	NVARCHAR(255)	NOT NULL
		,GlobalAttribute18	NVARCHAR(255)	NOT NULL
		,GlobalAttribute19	NVARCHAR(255)	NOT NULL
		,GlobalAttribute20	NVARCHAR(255)	NOT NULL
		,GlobalAttribute21	NVARCHAR(255)	NOT NULL
		,GlobalAttribute22	NVARCHAR(255)	NOT NULL
		,GlobalAttribute23	NVARCHAR(255)	NOT NULL
		,GlobalAttribute24	NVARCHAR(255)	NOT NULL
		,GlobalAttribute25	NVARCHAR(255)	NOT NULL

		CONSTRAINT PK_sx_pf_dProductsVirtual PRIMARY KEY CLUSTERED (ProductKey)
	);
GO
