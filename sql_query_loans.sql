 -- 1> Get Approved Loans for a Specific Borrower
 SELECT l.*
FROM loans l
JOIN borrowers b ON l.loan_id = b.borrower_id
WHERE b.name = 'Alice Smith' AND l.status = 'Approved';

-- 2> Calculate Total Loan Amount for Each Borrower
SELECT b.name, SUM(l.loan_amount) AS total_loan_amount
FROM borrowers b
JOIN loans l ON b.borrower_id = l.loan_id
GROUP BY b.name;

-- 3> Get Loan Details with Repayment Status

SELECT l.loan_id, b.name, l.loan_amount, l.status, 
       (SELECT SUM(r.repayment_amount) FROM repayments r WHERE r.loan_id = l.loan_id) AS total_repaid
FROM loans l
JOIN borrowers b ON l.borrower_id = b.borrower_id;

-- 4> Find the Number of Pending Loans

SELECT COUNT(*) AS pending_loans
FROM loans
WHERE status = 'Pending';

-- 5> List Borrowers with Outstanding Loans

SELECT DISTINCT b.name, b.contact_info
FROM borrowers b
JOIN loans l ON b.borrower_id = l.borrower_id
WHERE l.status <> 'Approved';


-- 6> Get the Average Interest Rate of Approved Loans

SELECT AVG(interest_rate) AS average_interest_rate
FROM Loans
WHERE status = 'Approved';


-- 7> Get Repayment History for a Specific Loan

SELECT r.repayment_amount, r.repayment_date
FROM repayments r
WHERE r.loan_id = 1;  -- Replace 1 with the desired loan_id


-- 8> Find Borrowers with Loans Over a Specific Amount

SELECT b.name, l.loan_amount
FROM borrowers b
JOIN Loans l ON b.borrower_id = l.loan_id
WHERE l.amount > 10000;  -- Change this amount as needed


-- 9>  Monthly Repayment Summary

SELECT EXTRACT(YEAR FROM r.repayment_date) AS year,
       EXTRACT(MONTH FROM r.repayment_date) AS month,
       SUM(r.repayment_amount) AS total_repayments
FROM repayments r
GROUP BY year, month
ORDER BY year, month;


-- 11>  Total Loan Amount with Running Total

SELECT loan_id, amount,
       SUM(amount) OVER (ORDER BY loan_id) AS running_total
FROM loans;


-- 12> Categorizing Loans Based on Amount

SELECT loan_id,  amount,
       CASE 
           WHEN amount < 5000 THEN 'Small'
           WHEN amount BETWEEN 5000 AND 15000 THEN 'Medium'
           ELSE 'Large'
       END AS loan_category
FROM loans;

-- 13 > Loan Default Prediction (Hypothetical)

SELECT b.name, l.loan_amount,
       CASE 
           WHEN r.repayment_amount IS NULL THEN 'Potential Default'
           WHEN r.repayment_amount < (l.amount * 0.2) THEN 'At Risk'
           ELSE 'In Good Standing'
       END AS default_risk
FROM borrowers b
JOIN loans l ON b.borrower_id = l.borrower_id
LEFT JOIN Repayments r ON l.loan_id = r.loan_id;


-- 14> Ranking Borrowers by Total Loan Amount

SELECT b.name, 
       SUM(l.loan_amount) AS total_loan_amount,
       RANK() OVER (ORDER BY SUM(l.loan_amount) DESC) AS loan_rank
FROM borrowers b
JOIN loans l ON b.borrower_id = l.loan_id
GROUP BY b.name;

-- 15> Monthly Repayment Summary with Loan Status

SELECT EXTRACT(YEAR FROM r.repayment_date) AS year,
       EXTRACT(MONTH FROM r.repayment_date) AS month,
       SUM(r.repayment_amount) AS total_repayments,
       CASE 
           WHEN SUM(r.repayment_amount) < 10000 THEN 'Low'
           WHEN SUM(r.repayment_amount) BETWEEN 10000 AND 50000 THEN 'Moderate'
           ELSE 'High'
       END AS repayment_category
FROM repayments r
GROUP BY year, month
ORDER BY year, month;


-- 16> Detailed Loan Repayment Analysis with Cumulative Payments

SELECT 
    b.name AS borrower_name,
    l.loan_id,
    l.loan_amount AS loan_amount,
    r.repayment_amount,
    r.repayment_date,
    SUM(r.repayment_amount) OVER (PARTITION BY l.loan_id ORDER BY r.repayment_date) AS cumulative_repayment,
    CASE 
        WHEN SUM(r.repayment_amount) OVER (PARTITION BY l.loan_id ORDER BY r.repayment_date) < (l.loan_amount * 0.5) THEN 'Below 50% Paid'
        WHEN SUM(r.repayment_amount) OVER (PARTITION BY l.loan_id ORDER BY r.repayment_date) < l.loan_amount THEN 'Partially Paid'
        ELSE 'Fully Paid'
    END AS repayment_status
FROM 
    borrowers b
JOIN 
    loans l ON b.borrower_id = l.loan_id
LEFT JOIN 
    repayments r ON l.loan_id = r.loan_id
ORDER BY 
    b.name, l.loan_id, r.repayment_date;



