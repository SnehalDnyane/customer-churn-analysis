USE churn_project;
SET SQL_SAFE_UPDATES = 0;

-- FIX 1: TotalCharges has 11 blank/space rows
-- These are new customers with tenure = 0
-- Must clean BEFORE converting to decimal type
-- ------------------------------------------------------------
 
-- See the 11 problem rows
SELECT customerID, tenure, MonthlyCharges, TotalCharges
FROM customers
WHERE TotalCharges IS NULL
   OR TRIM(TotalCharges) = ''
   OR LENGTH(TRIM(TotalCharges)) = 0;
   
   
-- Replace all blank/space/null with '0'
UPDATE customers
SET TotalCharges = '0'
WHERE TotalCharges IS NULL
   OR TRIM(TotalCharges) = ''
   OR LENGTH(TRIM(TotalCharges)) = 0;
   
-- Verify blanks are fixed - must return 0
SELECT COUNT(*) AS still_blank
FROM customers
WHERE TotalCharges IS NULL
   OR TRIM(TotalCharges) = '';
   
-- Now safely convert VARCHAR to DECIMAL
ALTER TABLE customers
MODIFY COLUMN TotalCharges DECIMAL(10,2);
 
-- Verify conversion worked
SELECT 
  MIN(TotalCharges) AS min_value,
  MAX(TotalCharges) AS max_value
FROM customers;

-- ------------------------------------------------------------
-- FIX 2: Add ChurnFlag column (1 = churned, 0 = retained)
-- Makes churn rate calculations much easier
-- ------------------------------------------------------------
 
ALTER TABLE customers
ADD COLUMN ChurnFlag INT;
 
UPDATE customers
SET ChurnFlag = CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END;

-- SELECT Churn, COUNT(*) as total
-- FROM customers
-- GROUP BY Churn;

 
-- Verify - must show 1869
SELECT SUM(ChurnFlag) AS total_churned FROM customers;

-- ------------------------------------------------------------
-- FIX 3: Add TenureBucket column
-- Groups customers by how long they stayed
-- ------------------------------------------------------------
 
ALTER TABLE customers
ADD COLUMN TenureBucket VARCHAR(20);
 
UPDATE customers SET TenureBucket =
  CASE
    WHEN tenure BETWEEN 0  AND 12 THEN '0-12 months'
    WHEN tenure BETWEEN 13 AND 24 THEN '13-24 months'
    WHEN tenure BETWEEN 25 AND 48 THEN '25-48 months'
    WHEN tenure BETWEEN 49 AND 60 THEN '49-60 months'
    ELSE '61+ months'
  END;
 
-- Verify all 7043 rows got a bucket
SELECT TenureBucket, COUNT(*) AS total
FROM customers
GROUP BY TenureBucket
ORDER BY FIELD(TenureBucket,
  '0-12 months','13-24 months',
  '25-48 months','49-60 months','61+ months');
  
-- FIX 4: Add SeniorCitizenLabel column (Yes/No)
-- Original uses 0/1 which is inconsistent with other columns
-- ------------------------------------------------------------
 
ALTER TABLE customers
ADD COLUMN SeniorCitizenLabel VARCHAR(5);
 
UPDATE customers
SET SeniorCitizenLabel =
  CASE WHEN SeniorCitizen = 1 THEN 'Yes' ELSE 'No' END;
 
-- Verify
SELECT SeniorCitizenLabel, COUNT(*) AS total
FROM customers
GROUP BY SeniorCitizenLabel;
 
 
SET SQL_SAFE_UPDATES = 1;
 
SELECT
  COUNT(*)                    AS total_rows,        -- expected: 7043
  SUM(ChurnFlag)              AS total_churned,      -- expected: 1869
  COUNT(TenureBucket)         AS buckets_filled,     -- expected: 7043
  COUNT(SeniorCitizenLabel)   AS senior_filled       -- expected: 7043
FROM customers;


SELECT Churn, LENGTH(Churn), COUNT(*) 
FROM customers 
GROUP BY Churn, LENGTH(Churn);

SET SQL_SAFE_UPDATES = 0;

-- Remove carriage return, newline, tab and spaces
UPDATE customers
SET Churn = REPLACE(REPLACE(REPLACE(REPLACE(Churn, '\r', ''), '\n', ''), '\t', ''), ' ', '');

-- Check lengths now
SELECT Churn, LENGTH(Churn), COUNT(*) 
FROM customers 
GROUP BY Churn;

-- Update ChurnFlag
UPDATE customers
SET ChurnFlag = CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END;

SET SQL_SAFE_UPDATES = 1;

-- Final check
SELECT SUM(ChurnFlag) AS total_churned FROM customers;

SELECT
  COUNT(*)                    AS total_rows,        -- expected: 7043
  SUM(ChurnFlag)              AS total_churned,      -- expected: 1869
  COUNT(TenureBucket)         AS buckets_filled,     -- expected: 7043
  COUNT(SeniorCitizenLabel)   AS senior_filled       -- expected: 7043
FROM customers;