-- NEW CLEAN COHORT DATASET

UPDATE customers_base
SET tenure_bucket =
CASE
    WHEN tenure_months = 0 THEN 'M0'
    WHEN tenure_months BETWEEN 1 AND 3 THEN 'M1-3'
    WHEN tenure_months BETWEEN 4 AND 6 THEN 'M4-6'
    WHEN tenure_months BETWEEN 7 AND 9 THEN 'M7-9'
    WHEN tenure_months BETWEEN 10 AND 12 THEN 'M10-12'
    ELSE 'M12+'
END;

CREATE OR REPLACE VIEW tableau_cohort_dataset_v2 AS
SELECT
    cohort_month,
    tenure_bucket,
    COUNT(*) AS total_users,
    
    SUM(CASE WHEN churn_status != 'Churned' THEN 1 ELSE 0 END) AS retained_users,

    ROUND(
        SUM(CASE WHEN churn_status != 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS retention_rate

FROM customers_base
GROUP BY cohort_month, tenure_bucket;

SELECT *
FROM tableau_cohort_dataset_v2
LIMIT 20;

SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';

SELECT tenure_bucket, COUNT(*)
FROM customers_base
GROUP BY tenure_bucket;