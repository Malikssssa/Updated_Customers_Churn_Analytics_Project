-- create cohort month column
ALTER TABLE customers_base
ADD COLUMN cohort_month DATE;

UPDATE customers_base
SET cohort_month = DATE_FORMAT(signup_date, '%Y-%m-01');

ALTER TABLE customers_base
ADD COLUMN tenure_bucket VARCHAR(20);

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

CREATE OR REPLACE VIEW cohort_sizes_fixed AS
SELECT
    cohort_month,
    COUNT(*) AS cohort_size
FROM customers_base
GROUP BY cohort_month;

CREATE OR REPLACE VIEW cohort_retention_fixed AS
SELECT
    cohort_month,
    tenure_bucket,
    COUNT(*) AS users,
    SUM(CASE WHEN churn_status != 'Churned' THEN 1 ELSE 0 END) AS retained_users
FROM customers_base
GROUP BY cohort_month, tenure_bucket;

CREATE OR REPLACE VIEW cohort_retention_final AS
SELECT
    cr.cohort_month,
    cr.tenure_bucket,
    cr.retained_users,
    cs.cohort_size,
    ROUND(cr.retained_users / cs.cohort_size, 3) AS retention_rate
FROM cohort_retention_fixed cr
JOIN cohort_sizes_fixed cs
ON cr.cohort_month = cs.cohort_month;

SELECT *
FROM cohort_retention_final
WHERE retention_rate > 1;