-- NHS Prescribing Insights — Project 2: SQL Practice Queries
-- Database: Data/nhs_prescriptions.db
-- Table: prescriptions
-- Covers: SELECT, WHERE, ORDER BY, GROUP BY, COUNT/SUM/AVG, HAVING, LIKE

-- 1. Basic SELECT — view specific columns
SELECT YEAR_MONTH, REGION_NAME, BNF_PRESENTATION_NAME, ITEMS, NIC
FROM prescriptions
LIMIT 10;

-- 2. WHERE — filter by region
SELECT REGION_NAME, BNF_PRESENTATION_NAME, NIC
FROM prescriptions
WHERE REGION_NAME = 'LONDON'
LIMIT 10;

-- 3. WHERE — filter by month
SELECT *
FROM prescriptions
WHERE YEAR_MONTH = '2025-05'
LIMIT 10;

-- 4. WHERE with AND — combine conditions
SELECT REGION_NAME, BNF_PRESENTATION_NAME, NIC
FROM prescriptions
WHERE REGION_NAME = 'LONDON' AND YEAR_MONTH = '2025-05'
LIMIT 10;

-- 5. ORDER BY — highest single-line spending first
SELECT BNF_PRESENTATION_NAME, NIC
FROM prescriptions
ORDER BY NIC DESC
LIMIT 10;

-- 6. COUNT — number of prescription records per region
SELECT REGION_NAME, COUNT(*) AS record_count
FROM prescriptions
GROUP BY REGION_NAME
ORDER BY record_count DESC;

-- 7. SUM — total spending by region
SELECT REGION_NAME, SUM(NIC) AS total_spending
FROM prescriptions
GROUP BY REGION_NAME
ORDER BY total_spending DESC;

-- 8. AVG — average items per prescription by dispenser type
SELECT DISPENSER_ACCOUNT_TYPE, AVG(ITEMS) AS avg_items
FROM prescriptions
GROUP BY DISPENSER_ACCOUNT_TYPE;

-- 9. GROUP BY + HAVING — filter aggregated results
SELECT BNF_PRESENTATION_NAME, SUM(TOTAL_QUANTITY) AS total_qty
FROM prescriptions
GROUP BY BNF_PRESENTATION_NAME
HAVING total_qty > 1000000
ORDER BY total_qty DESC;

-- 10. GROUP BY two columns — spending by region per month
SELECT YEAR_MONTH, REGION_NAME, SUM(NIC) AS monthly_spending
FROM prescriptions
GROUP BY YEAR_MONTH, REGION_NAME
ORDER BY YEAR_MONTH, monthly_spending DESC;

-- 11. Top 10 medicines by total spending
SELECT BNF_PRESENTATION_NAME, SUM(NIC) AS total_spend
FROM prescriptions
GROUP BY BNF_PRESENTATION_NAME
ORDER BY total_spend DESC
LIMIT 10;

-- 12. LIKE — pattern matching (e.g. all Mounjaro dose strengths)
SELECT BNF_PRESENTATION_NAME, SUM(NIC) AS total_spend
FROM prescriptions
WHERE BNF_PRESENTATION_NAME LIKE '%Mounjaro%'
GROUP BY BNF_PRESENTATION_NAME
ORDER BY total_spend DESC;