CREATE DATABASE IF NOT EXISTS churn_project;
USE churn_project;

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  customerID       VARCHAR(20)   PRIMARY KEY,
  gender           VARCHAR(10),
  SeniorCitizen    INT,
  Partner          VARCHAR(5),
  Dependents       VARCHAR(5),
  tenure           INT,
  PhoneService     VARCHAR(5),
  MultipleLines    VARCHAR(25),
  InternetService  VARCHAR(20),
  OnlineSecurity   VARCHAR(25),
  OnlineBackup     VARCHAR(25),
  DeviceProtection VARCHAR(25),
  TechSupport      VARCHAR(25),
  StreamingTV      VARCHAR(25),
  StreamingMovies  VARCHAR(25),
  Contract         VARCHAR(20),
  PaperlessBilling VARCHAR(5),
  PaymentMethod    VARCHAR(35),
  MonthlyCharges   DECIMAL(8,2),
  TotalCharges     VARCHAR(20),
  Churn            VARCHAR(5)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/WA_Fn-UseC_-Telco-Customer-Churn.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_imported FROM customers;

SELECT * FROM customers LIMIT 5;