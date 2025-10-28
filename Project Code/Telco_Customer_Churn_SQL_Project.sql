-- Step 1: Create a new database (if not already done)
CREATE DATABASE Telecom_DB;

-- Step 2: Switch to the database
USE Telecom_DB;

-- Step 3: Create the table
CREATE TABLE telco_churn (
    customerID VARCHAR(50) PRIMARY KEY,
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    tenure INT,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(40),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges DECIMAL(10,2),
    Churn VARCHAR(10)
);

-- Total number of customers
SELECT COUNT(*) AS total_customers FROM telco_churn;

-- Check for missing or blank TotalCharges
SELECT COUNT(*) AS missing_totalcharges 
FROM telco_churn 
WHERE TotalCharges IS NULL OR TotalCharges = '';

-- Gender distribution
SELECT gender, COUNT(*) AS count 
FROM telco_churn 
GROUP BY gender;

-- Overall Churn Distribution
SELECT Churn, COUNT(*) AS count 
FROM telco_churn 
GROUP BY Churn;

-- Churn by Contract Type

SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM telco_churn
GROUP BY Contract
ORDER BY churn_rate_percent DESC;

-- Churn by Payment Method

SELECT 
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM telco_churn
GROUP BY PaymentMethod
ORDER BY churn_rate_percent DESC;

-- Average Charges and Tenure by Churn

SELECT 
    Churn,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    ROUND(AVG(TotalCharges), 2) AS avg_total_charges,
    ROUND(AVG(tenure), 1) AS avg_tenure
FROM telco_churn
GROUP BY Churn;

-- Senior Citizen Churn Analysis

SELECT 
    SeniorCitizen,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM telco_churn
GROUP BY SeniorCitizen;

-- Churn by Internet Service Type

SELECT 
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM telco_churn
GROUP BY InternetService
ORDER BY churn_rate_percent DESC;

-- Service Adoption Impact on Churn

SELECT 
    CASE 
        WHEN OnlineSecurity = 'Yes' AND OnlineBackup = 'Yes' AND TechSupport = 'Yes' THEN '3+ Services'
        WHEN OnlineSecurity = 'Yes' OR OnlineBackup = 'Yes' OR TechSupport = 'Yes' THEN '1-2 Services'
        ELSE 'No Add-on Services'
    END AS service_adoption,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM telco_churn
GROUP BY service_adoption
ORDER BY churn_rate_percent DESC;

-- Tenure-Based Churn Analysis

SELECT 
    CASE 
        WHEN tenure <= 6 THEN '0-6 months'
        WHEN tenure <= 12 THEN '6-12 months'
        WHEN tenure <= 24 THEN '12-24 months'
        ELSE '24+ months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM telco_churn
GROUP BY tenure_group
ORDER BY tenure_group;

-- High-Risk Customer Segments

SELECT 
    Contract,
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM telco_churn
WHERE Contract = 'Month-to-month' OR PaymentMethod = 'Electronic check'
GROUP BY Contract, PaymentMethod
ORDER BY churn_rate_percent DESC;

-- Gender and Partnership ImpactGender and Partnership Impact

SELECT 
    gender,
    Partner,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM telco_churn
GROUP BY gender, Partner
ORDER BY churn_rate_percent DESC;
