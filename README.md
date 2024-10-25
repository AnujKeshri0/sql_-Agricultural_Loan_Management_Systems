# 🌾 Loan Management System for Farmers
![Loan Management](https://img.shields.io/badge/Project-LoanManagement-orange) 
![Status](https://img.shields.io/badge/Status-Active-brightgreen) 
![License](https://img.shields.io/badge/License-MIT-blue)

---

## 📖 Project Overview

The **Loan Management System for Farmers** aims to streamline the lending process between financial institutions and agricultural borrowers. By creating a comprehensive database that captures essential details about farmers, loans, and repayments, this project enables improved decision-making, risk assessment, and performance tracking. Our goal is to enhance the efficiency of loan approvals and support farmers in accessing the necessary capital for their agricultural activities.

---

## 🎯 Project Objectives

- **Database Design:** Develop a normalized database schema with tables for farmers, loans, repayments, and relevant metadata.
- **Data Integrity:** Implement constraints and triggers to ensure robust data integrity.
- **Data Exploration:** Analyze existing data to identify patterns, trends, and insights related to loan applications and repayments.
- **Performance Monitoring:** Create queries to track loan statuses, repayment histories, and borrower behaviors.
- **Reporting:** Generate summary reports offering insights into lending performance and borrower demographics.

---

## 🗂️ Project Structure

### 1. Database Setup

#### Schema Design
Create the foundational tables for the system:

**Farmers Table**
CREATE TABLE farmers (
    farmer_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    contact_number VARCHAR(15),
    address VARCHAR(255),
    farm_size FLOAT,
    crop_type VARCHAR(100)
);


**Loans Table**
CREATE TABLE loans (
    loan_id INT PRIMARY KEY,
    farmer_id INT,
    loan_amount FLOAT,
    interest_rate FLOAT,
    loan_term INT,
    status VARCHAR(20),
    application_date DATE,
    disbursement_date DATE,
    FOREIGN KEY (farmer_id) REFERENCES Farmers(farmer_id)
);

**Repayments Table**
CREATE TABLE repayments (
    repayment_id INT PRIMARY KEY,
    loan_id INT,
    repayment_amount FLOAT,
    repayment_date DATE,
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

**borrowers Table**
Create tables for borrowers
CREATE TABLE borrowers (
    borrower_id INT PRIMARY KEY,
    name VARCHAR(255),
    contact_info VARCHAR(255),
    date_of_birth DATE
);

**2. Data Exploration and Cleaning**
Data Review: Assess the quality of the data and identify any inconsistencies or missing values.
Data Cleaning: Implement SQL queries to clean data, such as removing duplicates and standardizing formats.

**3. Data Analysis and Findings**
-- 1. Loan History for Borrower "Alice Smith"
SELECT l.*
FROM Loans l
JOIN Borrowers b ON l.borrower_id = b.borrower_id
WHERE b.name = 'Alice Smith' AND l.status = 'Approved';
-- **Description:** Retrieves all approved loans for a borrower named "Alice Smith".
-- **Insight:** This helps in tracking loan history for individual borrowers, allowing for personalized communication and support.

-- 2. Total Loan Amount by Borrower
SELECT b.name, SUM(l.loan_amount) AS total_loan_amount
FROM Borrowers b
JOIN Loans l ON b.borrower_id = l.borrower_id
GROUP BY b.name;
-- **Description:** Calculates the total loan amount taken by each borrower.
-- **Insight:** Identifies high-value borrowers and assesses overall lending risk based on total exposure.

-- 3. Loan Details with Total Repaid
SELECT l.loan_id, b.name, l.loan_amount, l.status, 
       (SELECT SUM(r.repayment_amount) FROM Repayments r WHERE r.loan_id = l.loan_id) AS total_repaid
FROM Loans l
JOIN Borrowers b ON l.borrower_id = b.borrower_id;
-- **Description:** Retrieves loan details along with the total amount repaid for each loan.
-- **Insight:** Provides insight into the repayment behavior of borrowers and the health of the loan portfolio.

-- 4. Count of Pending Loans
SELECT COUNT(*) AS pending_loans
FROM Loans
WHERE status = 'Pending';
-- **Description:** Counts the total number of loans that are still pending approval.
-- **Insight:** Helps in assessing the backlog of loan applications, informing staffing or process improvement efforts.

-- 5. Borrowers with Non-Approved Loans
SELECT DISTINCT b.name, b.contact_info
FROM Borrowers b
JOIN Loans l ON b.borrower_id = l.borrower_id
WHERE l.status <> 'Approved';
-- **Description:** Lists borrowers who have loans that are not approved (e.g., pending or rejected).
-- **Insight:** Useful for follow-ups with borrowers to assist them in completing applications or addressing issues.

-- 6. Average Interest Rate for Approved Loans
SELECT AVG(interest_rate) AS average_interest_rate
FROM Loans
WHERE status = 'Approved';
-- **Description:** Calculates the average interest rate for all approved loans.
-- **Insight:** Provides insights into lending practices and the competitiveness of interest rates offered by the bank.

-- 7. Repayment Records for a Specific Loan
SELECT r.repayment_amount, r.repayment_date
FROM Repayments r
WHERE r.loan_id = 1;  -- Replace 1 with the desired loan_id
-- **Description:** Retrieves all repayment records for a specific loan identified by its loan ID.
-- **Insight:** Useful for monitoring repayment behavior and understanding issues related to repayment schedules.

-- 8. Borrowers with Loans Exceeding a Specified Amount
SELECT b.name, l.loan_amount
FROM Borrowers b
JOIN Loans l ON b.borrower_id = l.borrower_id
WHERE l.loan_amount > 10000;  -- Change this amount as needed
-- **Description:** Identifies borrowers who have taken loans exceeding a specified amount.
-- **Insight:** Helps in identifying high-risk loans and assessing exposure for loans above a certain threshold.

-- 9. Monthly Summary of Total Repayments
SELECT EXTRACT(YEAR FROM r.repayment_date) AS year,
       EXTRACT(MONTH FROM r.repayment_date) AS month,
       SUM(r.repayment_amount) AS total_repayments
FROM Repayments r
GROUP BY year, month
ORDER BY year, month;
-- **Description:** Summarizes total repayments on a monthly basis, grouping results by year and month.
-- **Insight:** Useful for understanding seasonal trends in repayments and can aid in forecasting future cash flows.

-- 10. Running Total of Loan Amounts
SELECT loan_id, borrower_id, loan_amount, 
       SUM(loan_amount) OVER (ORDER BY loan_id) AS running_total
FROM Loans;
-- **Description:** Calculates a running total of the loan amounts ordered by loan ID.
-- **Insight:** Helps in understanding cumulative lending over time, useful for trend analysis.

-- 11. Categorizing Loans into 'Small', 'Medium', or 'Large'
SELECT loan_id, borrower_id, loan_amount,
       CASE 
           WHEN loan_amount < 5000 THEN 'Small'
           WHEN loan_amount BETWEEN 5000 AND 15000 THEN 'Medium'
           ELSE 'Large'
       END AS loan_category
FROM Loans;
-- **Description:** Categorizes loans based on their amount.
-- **Insight:** Assists in risk assessment and tailoring communication strategies for different loan sizes.

-- 12. Monthly Summary of Repayments Categorized
SELECT EXTRACT(YEAR FROM r.repayment_date) AS year,
       EXTRACT(MONTH FROM r.repayment_date) AS month,
       SUM(r.repayment_amount) AS total_repayments,
       CASE 
           WHEN SUM(r.repayment_amount) < 10000 THEN 'Low'
           WHEN SUM(r.repayment_amount) BETWEEN 10000 AND 50000 THEN 'Moderate'
           ELSE 'High'
       END AS repayment_category
FROM Repayments r
GROUP BY year, month
ORDER BY year, month;
-- **Description:** Provides a monthly summary of repayments, categorized as 'Low', 'Moderate', or 'High'.
-- **Insight:** Identifies trends in repayment behavior and potential financial health indicators of the borrower base.

-- 13. Total Loan Amount for Each Borrower with Ranking
SELECT b.name, 
       SUM(l.loan_amount) AS total_loan_amount,
       RANK() OVER (ORDER BY SUM(l.loan_amount) DESC) AS loan_rank
FROM Borrowers b
JOIN Loans l ON b.borrower_id = l.borrower_id
GROUP BY b.name;
-- **Description:** Calculates the total loan amount for each borrower and ranks them based on the total amount.
-- **Insight:** Highlights key clients and assesses concentration risk in the loan portfolio.

-- 14. Assessing Default Risk of Borrowers
SELECT b.name, l.loan_amount,
       CASE 
           WHEN r.repayment_amount IS NULL THEN 'Potential Default'
           WHEN r.repayment_amount < (l.loan_amount * 0.2) THEN 'At Risk'
           ELSE 'In Good Standing'
       END AS default_risk
FROM Borrowers b
JOIN Loans l ON b.borrower_id = l.borrower_id
LEFT JOIN Repayments r ON l.loan_id = r.loan_id;
-- **Description:** Assesses the default risk of borrowers based on their repayment amounts relative to their loan amounts.
-- **Insight:** Identifying borrowers at risk of default can help prioritize outreach and support efforts.

-- 15. Detailed Repayment Information for Each Loan
SELECT 
    b.name AS borrower_name,
    l.loan_id,
    l.loan_amount,
    r.repayment_amount,
    r.repayment_date,
    SUM(r.repayment_amount) OVER (PARTITION BY l.loan_id ORDER BY r.repayment_date) AS cumulative_repayment,
    CASE 
        WHEN SUM(r.repayment_amount) OVER (PARTITION BY l.loan_id ORDER BY r.repayment_date) < (l.loan_amount * 0.5) THEN 'Below 50% Paid'
        WHEN SUM(r.repayment_amount) OVER (PARTITION BY l.loan_id ORDER BY r.repayment_date) < l.loan_amount THEN 'Partially Paid'
        ELSE 'Fully Paid'
    END AS repayment_status
FROM 
    Borrowers b
JOIN 
    Loans l ON b.borrower_id = l.borrower_id
LEFT JOIN 
    Repayments r ON l.loan_id = r.loan_id
ORDER BY 
    b.name, l.loan_id, r.repayment_date;
-- **Description:** Retrieves detailed repayment information for each loan, including cumulative repayments and repayment status.
-- **Insight:** Allows tracking of how borrowers are repaying their loans over time and identifying those who are struggling to make payments.


📊 Overall Findings
Loan Approval Trends: Larger farms in key agricultural areas tend to get approved for loans more easily than smaller farms.
Repayment Behavior: Most farmers are able to pay back their loans on time, but some are falling behind, indicating financial difficulties.
Farm Size Impact: Bigger farms usually receive larger loans and manage them better.
Regional Differences: Certain areas have higher default rates, suggesting economic conditions vary by region.
Seasonal Trends: Loans peak during planting season, while repayments peak after harvest time.

🚀 Conclusion
The Loan Management System for Farmers helps track important data about loans and repayments. While many farmers manage their loans well, some need additional help. Understanding the links between farm size, loan performance, and repayment can help banks improve their lending practices. This project shows the value of using data to make informed decisions and can guide future efforts to support farmers more effectively.
