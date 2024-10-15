Loan Management System for Farmers

Project Overview
The Loan Management System for Farmers aims to facilitate the lending process between financial institutions and agricultural borrowers. By providing a comprehensive database that captures details about farmers, loans, and repayments, the project enables better decision-making, risk assessment, and performance tracking. The system is designed to improve the efficiency of loan approvals, monitor repayment behaviors, and ultimately support farmers in accessing the capital they need for their agricultural activities.

Project Objectives
Database Design: Create a normalized database schema that includes tables for farmers, loans, repayments, and relevant metadata.
Data Integrity: Implement constraints and triggers to ensure data integrity across the loan management system.
Data Exploration: Analyze existing data to identify patterns, trends, and insights related to loan applications and repayments.
Performance Monitoring: Develop queries to track loan statuses, repayment histories, and borrower behaviors.
Reporting: Generate summary reports that provide insights into the overall lending performance and borrower demographics.

Project Structure
1. Database Setup
Schema Design:
Create tables for Farmers, Loans, and Repayments.
Define relationships between tables (e.g., foreign keys).


Create tables for loans
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
Create tables for Farmers
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

Create tables for borrowers
CREATE TABLE borrowers (
    borrower_id INT PRIMARY KEY,
    name VARCHAR(255),
    contact_info VARCHAR(255),
    date_of_birth DATE
);

Create tables for repayments
CREATE TABLE repayments (
    repayment_id INT PRIMARY KEY,
    loan_id INT,
    repayment_amount FLOAT,
    repayment_date DATE,
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
);

2. Data Exploration and Cleaning
Data Review: Assess the quality of the data and identify any inconsistencies or missing values.
Data Cleaning: Implement SQL queries to clean data, such as removing duplicates and standardizing formats.

3. Data Analysis and Findings

1>  Description: This query retrieves all approved loans specifically for a borrower named "Alice Smith". It uses a join between the Loans and Borrowers tables.

Insight: Helps in tracking loan history for individual borrowers, useful for personalized communication and support.
SELECT l.*
FROM Loans l
JOIN Borrowers b ON l.borrower_id = b.borrower_id
WHERE b.name = 'Alice Smith' AND l.status = 'Approved';

2>Description: This query calculates the total loan amount taken by each borrower by summing the amounts from the Loans table.

Insight: Identifies high-value borrowers and assesses overall lending risk based on total exposure.
SELECT b.name, SUM(l.amount) AS total_loan_amount
FROM Borrowers b
JOIN Loans l ON b.borrower_id = l.borrower_id
GROUP BY b.name;

3> Description: This query retrieves loan details along with the total amount repaid for each loan. It includes a subquery to sum repayments.

Insight: Provides insight into the repayment behavior of borrowers and the health of the loan portfolio.
SELECT l.loan_id, b.name, l.amount, l.status, 
       (SELECT SUM(r.repayment_amount) FROM Repayments r WHERE r.loan_id = l.loan_id) AS total_repaid
FROM Loans l
JOIN Borrowers b ON l.borrower_id = b.borrower_id;

4> Description: This query counts the total number of loans that are still pending approval.

Insight: Helps in assessing the backlog of loan applications and can inform staffing or process improvement efforts.
SELECT COUNT(*) AS pending_loans
FROM Loans
WHERE status = 'Pending';

5> Description: This query lists borrowers who have loans that are not approved (e.g., pending or rejected).

Insight: Useful for follow-ups with borrowers to assist them in either completing their applications or addressing issues.
SELECT DISTINCT b.name, b.contact_info
FROM Borrowers b
JOIN Loans l ON b.borrower_id = l.borrower_id
WHERE l.status <> 'Approved';

6> Description: This query calculates the average interest rate for all approved loans.

Insight: Provides insights into the lending practices and competitiveness of the interest rates offered by the bank.
SELECT AVG(interest_rate) AS average_interest_rate
FROM Loans
WHERE status = 'Approved';

7> Description: This query retrieves all repayment records for a specific loan identified by its loan ID.

Insight: Useful for monitoring repayment behavior and understanding any issues related to repayment schedules.
SELECT r.repayment_amount, r.repayment_date
FROM Repayments r
WHERE r.loan_id = 1;  -- Replace 1 with the desired loan_id

8> Description: This query identifies borrowers who have taken loans exceeding a specified amount.

Insight: Helps in identifying high-risk loans and assessing exposure for loans above a certain threshold.
SELECT b.name, l.amount
FROM Borrowers b
JOIN Loans l ON b.borrower_id = l.borrower_id
WHERE l.amount > 10000;  -- Change this amount as needed

9>Description: This query summarizes total repayments on a monthly basis, grouping the results by year and month.

Insight: Useful for understanding seasonal trends in repayments and can aid in forecasting future cash flows.
SELECT EXTRACT(YEAR FROM r.repayment_date) AS year,
       EXTRACT(MONTH FROM r.repayment_date) AS month,
       SUM(r.repayment_amount) AS total_repayments
FROM Repayments r
GROUP BY year, month
ORDER BY year, month;

10> Description: This query calculates a running total of the loan amounts ordered by loan_id.

Insight: A running total can help in understanding cumulative lending over time, useful for trend analysis.
SELECT loan_id, borrower_id, amount, 
       SUM(amount) OVER (ORDER BY loan_id) AS running_total
FROM Loans;

11> Description: This query categorizes loans into 'Small', 'Medium', or 'Large' based on their amount.

Insight: Categorizing loans can assist in risk assessment and tailoring communication strategies for different loan sizes.
SELECT loan_id, borrower_id, amount,
       CASE 
           WHEN amount < 5000 THEN 'Small'
           WHEN amount BETWEEN 5000 AND 15000 THEN 'Medium'
           ELSE 'Large'
       END AS loan_category
FROM Loans;

12> Description: This query provides a monthly summary of repayments, categorized as 'Low', 'Moderate', or 'High'.

Insight: This can help in identifying trends in repayment behavior and potential financial health indicators of the borrower base.
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

13> Description: This query calculates the total loan amount for each borrower and ranks them based on the total amount.

Insight: Ranking borrowers by their loan amounts can highlight key clients and assess concentration risk.
SELECT b.name, 
       SUM(l.amount) AS total_loan_amount,
       RANK() OVER (ORDER BY SUM(l.amount) DESC) AS loan_rank
FROM Borrowers b
JOIN Loans l ON b.borrower_id = l.borrower_id
GROUP BY b.name;

14> Description: This query assesses the default risk of borrowers based on their repayment amounts relative to their loan amounts.

Insight: Identifying borrowers at risk of default can help prioritize outreach and support.
SELECT b.name, l.amount,
       CASE 
           WHEN r.repayment_amount IS NULL THEN 'Potential Default'
           WHEN r.repayment_amount < (l.amount * 0.2) THEN 'At Risk'
           ELSE 'In Good Standing'
       END AS default_risk
FROM Borrowers b
JOIN Loans l ON b.borrower_id = l.borrower_id
LEFT JOIN Repayments r ON l.loan_id = r.loan_id;

15> Description: This query retrieves detailed repayment information for each loan, including the borrower's name, loan amount, repayment amount, and repayment date. It calculates the cumulative repayment for each loan using a window function and categorizes the repayment status based on how much of the loan has been repaid.

Insight: This analysis allows you to track how borrowers are repaying their loans over time, identify those who are struggling to make payments, and implement proactive measures to mitigate default risks.
SELECT 
    b.name AS borrower_name,
    l.loan_id,
    l.amount AS loan_amount,
    r.repayment_amount,
    r.repayment_date,
    SUM(r.repayment_amount) OVER (PARTITION BY l.loan_id ORDER BY r.repayment_date) AS cumulative_repayment,
    CASE 
        WHEN SUM(r.repayment_amount) OVER (PARTITION BY l.loan_id ORDER BY r.repayment_date) < (l.amount * 0.5) THEN 'Below 50% Paid'
        WHEN SUM(r.repayment_amount) OVER (PARTITION BY l.loan_id ORDER BY r.repayment_date) < l.amount THEN 'Partially Paid'
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


Overall Findings:
Loan Approval Trends: We found that larger farms in key agricultural areas tend to get approved for loans more easily than smaller farms.

Repayment Behavior: Most farmers are able to pay back their loans on time. However, some are falling behind, indicating they might be facing financial difficulties.

Farm Size Impact: Bigger farms usually receive larger loans and are better at managing them compared to smaller farms.

Regional Differences: Certain areas have higher default rates, suggesting that economic conditions vary by region. These areas may need extra support.

Seasonal Trends: Loans are most often given during planting season, while repayments peak after harvest time. This pattern can help in planning financial support for farmers.

Conclusion:
The Loan Management System for Farmers helps track important data about loans and repayments. We found that while many farmers manage their loans well, some need additional help.

Understanding the links between farm size, loan performance, and repayment can help banks improve their lending practices. This project shows the value of using data to make informed decisions and can guide future efforts to support farmers more effectively. Overall, these insights can lead to better financial outcomes for farmers and smarter lending for banks.



   
