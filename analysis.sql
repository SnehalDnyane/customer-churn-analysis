USE churn_project;

-- QUERY 1: Overall Churn Rate (Headline KPI)
-- ============================================================
-- This is your most important number - mention it in interviews
SELECT
  COUNT(*)                                          AS total_customers,
  SUM(ChurnFlag)                                    AS churned_customers,
  COUNT(*) - SUM(ChurnFlag)                         AS retained_customers,
  ROUND(SUM(ChurnFlag) * 100.0 / COUNT(*), 2)       AS churn_rate_pct
FROM customers;

-- ============================================================
-- QUERY 2: Churn by Contract Type
-- ============================================================
-- Key insight: Month-to-month churns 3x more than annual
SELECT
  Contract,
  COUNT(*)                              AS total_customers,
  SUM(ChurnFlag)                        AS churned,
  ROUND(AVG(ChurnFlag) * 100, 2)        AS churn_rate_pct
FROM customers
GROUP BY Contract
ORDER BY churn_rate_pct DESC;

-- ============================================================
-- QUERY 3: Churn by Internet Service
-- ============================================================
SELECT
  InternetService,
  COUNT(*)                              AS total_customers,
  SUM(ChurnFlag)                        AS churned,
  ROUND(AVG(ChurnFlag) * 100, 2)        AS churn_rate_pct
FROM customers
GROUP BY InternetService
ORDER BY churn_rate_pct DESC;
 
-- ============================================================
-- QUERY 4: Revenue Impact - Churned vs Retained
-- ============================================================
-- Shows financial impact of churn
SELECT
  Churn,
  COUNT(*)                              AS total_customers,
  ROUND(AVG(MonthlyCharges), 2)         AS avg_monthly_charges,
  ROUND(AVG(TotalCharges), 2)           AS avg_total_charges,
  ROUND(AVG(tenure), 1)                 AS avg_tenure_months,
  ROUND(SUM(MonthlyCharges), 2)         AS total_monthly_revenue
FROM customers
GROUP BY Churn;

-- ============================================================
-- QUERY 5: Churn by Tenure Bucket
-- ============================================================
-- Shows churn is highest in first year - key business insight
SELECT
  TenureBucket,
  COUNT(*)                              AS total_customers,
  SUM(ChurnFlag)                        AS churned,
  ROUND(AVG(ChurnFlag) * 100, 2)        AS churn_rate_pct
FROM customers
GROUP BY TenureBucket
ORDER BY FIELD(TenureBucket,
  '0-12 months','13-24 months',
  '25-48 months','49-60 months','61+ months');
  
-- ============================================================
-- QUERY 6: Churn by Payment Method
-- ============================================================
SELECT
  PaymentMethod,
  COUNT(*)                              AS total_customers,
  SUM(ChurnFlag)                        AS churned,
  ROUND(AVG(ChurnFlag) * 100, 2)        AS churn_rate_pct
FROM customers
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;

-- ============================================================
-- QUERY 7: Churn by Gender and Senior Citizen
-- ============================================================
SELECT
  gender,
  SeniorCitizenLabel,
  COUNT(*)                              AS total_customers,
  SUM(ChurnFlag)                        AS churned,
  ROUND(AVG(ChurnFlag) * 100, 2)        AS churn_rate_pct
FROM customers
GROUP BY gender, SeniorCitizenLabel
ORDER BY churn_rate_pct DESC;

 
-- ============================================================
-- QUERY 8: Monthly Revenue Lost Due to Churn
-- ============================================================
-- Use this number in your resume bullet points!
SELECT
  SUM(ChurnFlag)                        AS churned_customers,
  ROUND(SUM(MonthlyCharges), 2)         AS monthly_revenue_lost,
  ROUND(AVG(MonthlyCharges), 2)         AS avg_lost_per_customer,
  ROUND(SUM(TotalCharges), 2)           AS total_revenue_lost
FROM customers
WHERE Churn = 'Yes';

-- ============================================================
-- QUERY 9: Top 10 Highest Value Churned Customers
-- ============================================================
-- These are the most expensive customers to lose
SELECT
  customerID,
  tenure                                AS months_stayed,
  MonthlyCharges                        AS monthly_bill,
  TotalCharges                          AS total_paid,
  Contract,
  PaymentMethod,
  InternetService
FROM customers
WHERE Churn = 'Yes'
ORDER BY TotalCharges DESC
LIMIT 10;

-- ============================================================
-- QUERY 10: Churn by Multiple Services (Advanced)
-- ============================================================
-- Shows which service combinations lead to more churn
SELECT
  InternetService,
  Contract,
  COUNT(*)                              AS total_customers,
  SUM(ChurnFlag)                        AS churned,
  ROUND(AVG(ChurnFlag) * 100, 2)        AS churn_rate_pct,
  ROUND(AVG(MonthlyCharges), 2)         AS avg_monthly_charges
FROM customers
GROUP BY InternetService, Contract
ORDER BY churn_rate_pct DESC;

-- ============================================================
-- QUERY 11: Customer Risk Segmentation (ADVANCED)
-- Highlight this query in your resume and interviews!
-- ============================================================
SELECT
  customerID,
  tenure,
  MonthlyCharges,
  Contract,
  InternetService,
  PaymentMethod,
  CASE
    WHEN tenure <= 12
     AND Contract  = 'Month-to-month'
     AND MonthlyCharges > 65            THEN 'High Risk'
    WHEN tenure <= 24
     AND Contract  = 'Month-to-month'   THEN 'Medium Risk'
    WHEN Contract  = 'Two year'         THEN 'Low Risk'
    ELSE                                     'Medium Risk'
  END AS ChurnRiskLevel
FROM customers
WHERE Churn = 'No'
ORDER BY MonthlyCharges DESC;

-- ============================================================
-- QUERY 12: Risk Level Summary (use in Power BI)
-- ============================================================
SELECT
  CASE
    WHEN tenure <= 12
     AND Contract  = 'Month-to-month'
     AND MonthlyCharges > 65            THEN 'High Risk'
    WHEN tenure <= 24
     AND Contract  = 'Month-to-month'   THEN 'Medium Risk'
    WHEN Contract  = 'Two year'         THEN 'Low Risk'
    ELSE                                     'Medium Risk'
  END                                   AS ChurnRiskLevel,
  COUNT(*)                              AS total_customers,
  ROUND(AVG(MonthlyCharges), 2)         AS avg_monthly_charges,
  ROUND(AVG(tenure), 1)                 AS avg_tenure_months
FROM customers
WHERE Churn = 'No'
GROUP BY ChurnRiskLevel
ORDER BY total_customers DESC;

-- ============================================================
-- QUERY 13: Paperless Billing Impact on Churn
-- ============================================================
SELECT
  PaperlessBilling,
  COUNT(*)                              AS total_customers,
  SUM(ChurnFlag)                        AS churned,
  ROUND(AVG(ChurnFlag) * 100, 2)        AS churn_rate_pct
FROM customers
GROUP BY PaperlessBilling;

-- ============================================================
-- QUERY 14: Partner and Dependents Impact
-- ============================================================
SELECT
  Partner,
  Dependents,
  COUNT(*)                              AS total_customers,
  SUM(ChurnFlag)                        AS churned,
  ROUND(AVG(ChurnFlag) * 100, 2)        AS churn_rate_pct
FROM customers
GROUP BY Partner, Dependents
ORDER BY churn_rate_pct DESC;
 
SELECT
  COUNT(*)                                          AS total_customers,
  SUM(ChurnFlag)                                    AS total_churned,
  ROUND(SUM(ChurnFlag) * 100.0 / COUNT(*), 2)       AS overall_churn_rate_pct,
  ROUND(SUM(MonthlyCharges), 2)                     AS total_monthly_revenue,
  ROUND(SUM(CASE WHEN Churn='Yes'
    THEN MonthlyCharges END), 2)                    AS monthly_revenue_at_risk,
  ROUND(AVG(CASE WHEN Churn='Yes'
    THEN tenure END), 1)                            AS avg_tenure_before_churn,
  ROUND(AVG(CASE WHEN Churn='Yes'
    THEN MonthlyCharges END), 2)                    AS avg_charges_churned_customer
FROM customers;

SELECT customerID, gender, SeniorCitizen, Partner, Dependents,
       tenure, PhoneService, MultipleLines, InternetService,
       OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport,
       StreamingTV, StreamingMovies, Contract, PaperlessBilling,
       PaymentMethod, MonthlyCharges, TotalCharges, Churn,
       SeniorCitizenLabel, ChurnFlag, TenureBucket
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers_cleaned_v2.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM customers;