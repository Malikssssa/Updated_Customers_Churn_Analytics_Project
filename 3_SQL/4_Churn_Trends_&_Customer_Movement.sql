-- churn trends and customer movements


-- create signup_month column
ALTER TABLE customers_base
ADD COLUMN signup_month DATE;


-- populate signup_month
UPDATE customers_base
SET signup_month = DATE_FORMAT(signup_date, '%Y-%m-01');


-- monthly customer acquisition
SELECT
    signup_month,
    COUNT(*) AS total_customers
FROM customers_base
GROUP BY signup_month
ORDER BY signup_month;


-- monthly churned customers
SELECT
    signup_month,
    COUNT(*) AS churned_customers
FROM customers_base
WHERE churn_status = 'Churned'
GROUP BY signup_month
ORDER BY signup_month;


-- monthly active customers
SELECT
    signup_month,
    COUNT(*) AS active_customers
FROM customers_base
WHERE churn_status = 'Active'
GROUP BY signup_month
ORDER BY signup_month;


-- monthly churn rate
SELECT
    signup_month,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS churn_rate
FROM customers_base
GROUP BY signup_month
ORDER BY signup_month;


-- customer movement using LAG
WITH monthly_counts AS (
    SELECT
        signup_month,
        COUNT(*) AS total_customers
    FROM customers_base
    GROUP BY signup_month
)
SELECT
    signup_month,
    total_customers,
    LAG(total_customers) OVER (ORDER BY signup_month) AS prev_month_customers,
    total_customers - LAG(total_customers) OVER (ORDER BY signup_month) AS net_change
FROM monthly_counts
ORDER BY signup_month;


-- churn trend comparison using LAG
WITH churn_summary AS (
    SELECT
        signup_month,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_customers
    FROM customers_base
    GROUP BY signup_month
)
SELECT
    signup_month,
    total_customers,
    churned_customers,
    ROUND(churned_customers / total_customers, 3) AS churn_rate,
    LAG(ROUND(churned_customers / total_customers, 3))
        OVER (ORDER BY signup_month) AS prev_churn_rate
FROM churn_summary
ORDER BY signup_month;