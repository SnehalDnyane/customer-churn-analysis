Customer Churn Analysis — SQL + Power BI
Overview
Analyzed telecom customer churn for 7,043 customers using MySQL for data cleaning and analysis, and Power BI for an interactive 3-page dashboard. The goal was to identify key churn drivers and provide business recommendations to reduce monthly revenue loss.
Tools Used

MySQL 8.0 + MySQL Workbench
Power BI Desktop
Dataset — IBM Telco Customer Churn (Kaggle)

Project Files

01_setup.sql — Database creation and CSV import
02_clean.sql — Data cleaning and new column additions
03_analysis.sql — 14 SQL analysis queries
customers_cleaned_final.csv — Cleaned dataset (24 columns)
Churn_Analysis.pbix — 3-page Power BI dashboard

Data Cleaning
The raw dataset had the following issues fixed using SQL:

TotalCharges column had 11 blank whitespace values — replaced with 0 and converted from VARCHAR to DECIMAL
Churn column had hidden carriage return characters — removed using REPLACE function
SeniorCitizen stored as 0/1 — added SeniorCitizenLabel column with Yes/No
Added ChurnFlag column (1 = churned, 0 = retained) for easier calculations
Added TenureBucket column grouping customers into 5 tenure ranges

Key Findings
Overall Numbers

Total Customers — 7,043
Churned Customers — 1,869
Overall Churn Rate — 26.54%
Monthly Revenue Lost — $139,130
Average Tenure Before Churn — 18 months

Contract Type is the biggest churn driver

Month-to-month customers churn at 42.71%
One year contract customers churn at 11.27%
Two year contract customers churn at only 2.83%
Month-to-month customers churn 15x more than two-year customers

Internet Service

Fiber optic customers churn at 41.89%
DSL customers churn at 18.96%
Customers with no internet churn at only 7.40%

Payment Method

Electronic check users churn at 45.29%
Automatic payment users (bank transfer/credit card) churn at ~16%
Electronic check users churn nearly 3x more than automatic payment users

Tenure

55% of all churn happens within the first 12 months
Customers who stay beyond 2 years rarely churn

Business Recommendations

Offer loyalty discounts to convert month-to-month customers to annual contracts within first 6 months
Encourage electronic check users to switch to automatic payments with incentives
Launch an onboarding retention program for new customers in their first year
Review Fiber optic pricing — these customers pay more and churn more

Power BI Dashboard
3 interactive pages built with 8 DAX measures and 4 slicers:
Page 1 — Customer Churn Analysis
Overview of all 7,043 customers with KPI cards, churn by tenure, internet service, contract type, payment method, paperless billing and gender charts
Page 2 — Customer Churn Risk Analysis
Deep dive into 1,869 churned customers with churn rate by internet service, contract, payment method, combo chart and orange heatmap matrix
Page 3 — Customer Churn Services
Service usage analysis showing churn split across streaming, backup, device protection, phone and multiple lines
DAX Measures Created

Churn Rate %
Total Churned
Revenue Lost
Avg Monthly Charges
Senior Citizens Count
Tech Support %
Partner %
Churned Customers

Resume Bullet Points

Analyzed 7,043 customer records using MySQL to identify churn drivers — found month-to-month customers churn at 42% vs 3% for two-year contracts
Identified $139,130 monthly revenue at risk from 1,869 churned customers using SQL aggregate analysis across payment methods and contract types
Developed SQL-based 3-tier customer risk segmentation model (High/Medium/Low) using tenure, contract type, and billing behavior
Built 3-page interactive Power BI dashboard with 8 DAX measures and 4 slicers enabling dynamic churn analysis by contract, internet service, and tenure
Resolved data quality issues including hidden carriage return characters in VARCHAR columns using advanced SQL string functions

Author
Snehal Dnyane
snehaldnyane2005@gmail.com
https://github.com/SnehalDnyane

Dataset: IBM Telco Customer Churn — Kaggle
