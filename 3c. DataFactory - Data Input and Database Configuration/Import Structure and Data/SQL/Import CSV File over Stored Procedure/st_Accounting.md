Table to stage accounting data

````SQL
CREATE TABLE st_Accounting 
  (
    CompanyCode NVARCHAR (255),
    AccountNumber NVARCHAR (255),
    AccountName NVARCHAR (255),
    [Month] INT,
    [Year] INT,
    Value MONEY
  )
 ````
