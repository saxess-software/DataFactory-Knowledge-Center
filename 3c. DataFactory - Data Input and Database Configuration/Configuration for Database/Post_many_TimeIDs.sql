/*
Script to POST new TimeIDs as stupid list
Gerd Tautenhahn for saxess-software gmbh
12/2017 DataFactory 4.0
*/

DECLARE @Counter INT = 1;

DECLARE @FactoryID		NVARCHAR(255) = 'ZT'; -- CONFIG: Set Targets
DECLARE @ProductLineID	NVARCHAR(255) = 'EKB';
DECLARE @ProductID		NVARCHAR(255) = '1';
DECLARE @TimeID			BIGINT = 0;

WHILE @Counter < 10000
    BEGIN
        -- Create TimeID
        SET @TimeID = 10000100 + @Counter;
        EXEC sx_pf_POST_TimeID 'SQL'
                              ,@ProductID
                              ,@ProductLineID
                              ,@FactoryID
                              ,@TimeID;
        SET @Counter = @Counter + 1;

    END;