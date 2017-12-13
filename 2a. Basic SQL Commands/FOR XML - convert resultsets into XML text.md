
## The resultset of an Query can be put into an XML text
This is useful, even you don't want XML, but a text oriented output

````SQL
-- Put the query result into an XML Text
DECLARE @xmlQuery XML

SET @xmlQuery = (	
					 SELECT * FROM dbo.sx_pf_dFactories dF FOR XML PATH ('')  -- '' stands for the row delimitier - which is here nothing
					 , TYPE														-- just for good style, without the TYPE word the result is always nvarchar(max) 
				)

-- to print the result if you are interested
PRINT CONVERT(NVARCHAR(MAX),@xmlQuery)

-- Get all Values as navarchar(max) -  without XML Tags - with the value Method of the DataType XML
SELECT @xmlQuery.value('.[1]','nvarchar(max)')
```` 
 


