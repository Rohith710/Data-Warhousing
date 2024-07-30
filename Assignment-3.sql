/*Assignment - 3*/

/*1st Question */
-- A. Create the Customer database
CREATE DATABASE Customer;

-- B. Check if the database was created and use it
USE Customer;

/*2nd Question*/

-- A. Create staging table CustomerChurn_Stage
CREATE TABLE Customer.CustomerChurn_Stage (
    CustomerId INT,
    Surname VARCHAR(255),
    CreditScore INT,
    Geography VARCHAR(255),
    Gender VARCHAR(50),
    Age INT,
    Balance DECIMAL(10, 2),
    Exited INT
);

-- B. Create persistent table CustomerChurn with additional columns
CREATE TABLE Customer.CustomerChurn (
    CustomerId INT PRIMARY KEY,
    Surname VARCHAR(255),
    CreditScore INT,
    Geography VARCHAR(255),
    Gender VARCHAR(50),
    Age INT,
    Balance DECIMAL(10, 2),
    Exited INT,
    SourceSystemNm NVARCHAR(20) NOT NULL,
    CreateAgentId NVARCHAR(20) NOT NULL,
    CreateDtm DATETIME NOT NULL,
    ChangeAgentId NVARCHAR(20) NOT NULL,
    ChangeDtm DATETIME NOT NULL
);



/*Question 3 */

-- A. Load data into CustomerChurn_Stage from CustomerChurn1.csv
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CustomerChurn1.csv'
INTO TABLE Customer.CustomerChurn_Stage
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(CustomerId, Surname, CreditScore, Geography, Gender, Age, Balance, Exited);

-- B. Verify data
SELECT * FROM Customer.CustomerChurn_Stage ORDER BY CustomerId;


/*Question 4*/


SET SQL_SAFE_UPDATES = 0;

DELIMITER //

CREATE PROCEDURE Customer.PrCustomerChurn()
BEGIN

    DECLARE VarCurrentTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
    DECLARE VarSourceRowCount, VarTargetRowCount, VarThresholdNbr INTEGER DEFAULT 0;
    DECLARE VarTinyIntVal TINYINT;

    -- Get Source and Target Row Counts
    SELECT COUNT(*)
    INTO VarSourceRowCount
    FROM Customer.CustomerChurn_Stage;

    SELECT COUNT(*)
    INTO VarTargetRowCount
    FROM Customer.CustomerChurn;

    -- Calculate Threshold (20% of Target Row Count)
    SELECT CAST((VarTargetRowCount * 0.2) AS UNSIGNED)
    INTO VarThresholdNbr;

    -- Check if Source Row Count is less than Threshold
    IF VarSourceRowCount < VarThresholdNbr THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Source row count is less than 20% of target row count.';
    END IF;

    -- Delete rows in Target that are not in Source
    DELETE FROM Customer.CustomerChurn
    WHERE CustomerId NOT IN (SELECT CustomerId FROM Customer.CustomerChurn_Stage);

    -- Update rows that have changed
    UPDATE Customer.CustomerChurn AS TrgtTbl
    INNER JOIN Customer.CustomerChurn_Stage AS SrcTbl
    ON TrgtTbl.CustomerId = SrcTbl.CustomerId
    SET TrgtTbl.Surname = SrcTbl.Surname,
        TrgtTbl.CreditScore = SrcTbl.CreditScore,
        TrgtTbl.Geography = SrcTbl.Geography,
        TrgtTbl.Gender = SrcTbl.Gender,
        TrgtTbl.Age = SrcTbl.Age,
        TrgtTbl.Balance = SrcTbl.Balance,
        TrgtTbl.Exited = SrcTbl.Exited,
        TrgtTbl.ChangeAgentId = CURRENT_USER(),
        TrgtTbl.ChangeDtm = VarCurrentTimestamp
    WHERE TrgtTbl.CustomerId = SrcTbl.CustomerId AND (
        COALESCE(TrgtTbl.Surname, '*') <> COALESCE(SrcTbl.Surname, '*') OR
        COALESCE(TrgtTbl.CreditScore, '*') <> COALESCE(SrcTbl.CreditScore, '*') OR
        COALESCE(TrgtTbl.Geography, '*') <> COALESCE(SrcTbl.Geography, '*') OR
        COALESCE(TrgtTbl.Gender, '*') <> COALESCE(SrcTbl.Gender, '*') OR
        COALESCE(TrgtTbl.Age, '*') <> COALESCE(SrcTbl.Age, '*') OR
        COALESCE(TrgtTbl.Balance, '*') <> COALESCE(SrcTbl.Balance, '*') OR
        COALESCE(TrgtTbl.Exited, '*') <> COALESCE(SrcTbl.Exited, '*')
    );

    -- Insert new rows
    INSERT INTO Customer.CustomerChurn (
        CustomerId, Surname, CreditScore, Geography, Gender, Age, Balance, Exited,
        SourceSystemNm, CreateAgentId, CreateDtm, ChangeAgentId, ChangeDtm
    )
    SELECT 
        SrcTbl.CustomerId, SrcTbl.Surname, SrcTbl.CreditScore, SrcTbl.Geography,
        SrcTbl.Gender, SrcTbl.Age, SrcTbl.Balance, SrcTbl.Exited,
        'Kaggle-CSV', CURRENT_USER(), VarCurrentTimestamp, CURRENT_USER(), VarCurrentTimestamp
    FROM Customer.CustomerChurn_Stage AS SrcTbl
    LEFT JOIN Customer.CustomerChurn AS TrgtTbl
    ON SrcTbl.CustomerId = TrgtTbl.CustomerId
    WHERE TrgtTbl.CustomerId IS NULL;

END //

DELIMITER ;

SET SQL_SAFE_UPDATES = 1;

/*Question 5*/

CALL Customer.PrCustomerChurn();

-- Verify row counts
SELECT COUNT(*) FROM Customer.CustomerChurn_Stage;
SELECT COUNT(*) FROM Customer.CustomerChurn;

-- Show last few rows of the target table
SELECT * FROM Customer.CustomerChurn ORDER BY CustomerId DESC LIMIT 10;


 /*Question 6 */
 
 CREATE TABLE Customer.CustomerChurn_Version1 AS
SELECT * FROM Customer.CustomerChurn;

-- Show table definition
SHOW CREATE TABLE Customer.CustomerChurn_Version1;

-- Show row count of the versioned table
SELECT COUNT(*) FROM Customer.CustomerChurn_Version1;

-- Show last few rows of the versioned table
SELECT * FROM Customer.CustomerChurn_Version1 ORDER BY CustomerId DESC LIMIT 10;

-- Empty the staging table
TRUNCATE TABLE Customer.CustomerChurn_Stage;

-- Load new data from CustomerChurn2.csv
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CustomerChurn2.csv'
INTO TABLE Customer.CustomerChurn_Stage
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(CustomerId, Surname, CreditScore, Geography, Gender, Age, Balance, Exited);
 
 -- Verify new data row count
SELECT COUNT(*) FROM Customer.CustomerChurn_Stage;

-- Show last few rows of the new data in the staging table
SELECT * FROM Customer.CustomerChurn_Stage ORDER BY CustomerId DESC LIMIT 10;

 
 /*Question 7 */
 
 CALL Customer.PrCustomerChurn();
 
 -- Compare row counts
SELECT COUNT(*) AS RowCount FROM Customer.CustomerChurn;
SELECT COUNT(*) AS RowCount FROM Customer.CustomerChurn_Version1;

-- Show rows in Version1 but not in CustomerChurn
SELECT * FROM Customer.CustomerChurn_Version1 AS V1
LEFT JOIN Customer.CustomerChurn AS V2
ON V1.CustomerId = V2.CustomerId
WHERE V2.CustomerId IS NULL;


/*8th question */

SELECT *
FROM Customer.CustomerChurn AS V2
INNER JOIN Customer.CustomerChurn_Version1 AS V1
ON V2.CustomerId = V1.CustomerId
WHERE V2.Surname <> V1.Surname
   OR V2.CreditScore <> V1.CreditScore
   OR V2.Geography <> V1.Geography
   OR V2.Gender <> V1.Gender
   OR V2.Age <> V1.Age
   OR V2.Balance <> V1.Balance
   OR V2.Exited <> V1.Exited
ORDER BY V2.CustomerId;


/*9th Question*/

SELECT *
FROM Customer.CustomerChurn AS V2
LEFT JOIN Customer.CustomerChurn_Version1 AS V1
ON V2.CustomerId = V1.CustomerId
WHERE V1.CustomerId IS NULL
ORDER BY V2.CustomerId;


 
 
 
 
 



