-- TABLEAU DATASETS

-- KPI DATASET

CREATE OR REPLACE VIEW tableau_kpi_dataset AS
SELECT
    signup_month,

    COUNT(*) AS total_users,

    SUM(CASE WHEN churn_status = 'Active' THEN 1 ELSE 0 END) AS active_users,
    SUM(CASE WHEN churn_status = 'At Risk' THEN 1 ELSE 0 END) AS at_risk_users,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_users,

    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS churn_rate,

    ROUND(AVG(monthly_revenue),2) AS arpu,

    ROUND(SUM(monthly_revenue),2) AS total_revenue,

    ROUND(
        SUM(CASE WHEN churn_status='Churned' THEN monthly_revenue ELSE 0 END),
        2
    ) AS revenue_lost,

    ROUND(
        SUM(CASE WHEN churn_status='At Risk' THEN monthly_revenue ELSE 0 END),
        2
    ) AS revenue_at_risk

FROM customers_base
GROUP BY signup_month;

-- MONTHLY CUSTOMER TRENDS

CREATE OR REPLACE VIEW tableau_customer_trends AS
SELECT
    signup_month,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN churn_status='Active' THEN 1 ELSE 0 END) AS active_users,

    SUM(CASE WHEN churn_status='At Risk' THEN 1 ELSE 0 END) AS at_risk_users,

    SUM(CASE WHEN churn_status='Churned' THEN 1 ELSE 0 END) AS churned_users,

    ROUND(
        SUM(CASE WHEN churn_status='Churned' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS churn_rate

FROM customers_base
GROUP BY signup_month
ORDER BY signup_month;

-- REVENUE DATASET

CREATE OR REPLACE VIEW tableau_revenue_dataset AS
SELECT
    signup_month,
    plan_type,
    churn_status,

    COUNT(*) AS users,

    ROUND(SUM(monthly_revenue),2) AS total_revenue,

    ROUND(AVG(monthly_revenue),2) AS avg_revenue

FROM customers_base
GROUP BY signup_month, plan_type, churn_status;

-- CUSTOMER RISK DATASET

CREATE OR REPLACE VIEW tableau_risk_customers AS
SELECT
    customer_id,
    plan_type,
    churn_status,
    risk_score,
    monthly_revenue,
    days_since_last_login,
    engagement_bucket,
    usage_bucket,
    support_bucket,
    payment_history,
    customer_satisfaction_score
FROM customers_base;

-- SEGMENT CHURN DATASET

CREATE OR REPLACE VIEW tableau_churn_segments AS
SELECT
    plan_type,
    engagement_bucket,
    usage_bucket,
    support_bucket,
    payment_history,

    COUNT(*) AS total_users,

    SUM(CASE WHEN churn_status='Churned' THEN 1 ELSE 0 END) AS churned_users,

    ROUND(
        SUM(CASE WHEN churn_status='Churned' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS churn_rate

FROM customers_base
GROUP BY
    plan_type,
    engagement_bucket,
    usage_bucket,
    support_bucket,
    payment_history;
    
-- COHORT RETENTION DATASET

CREATE OR REPLACE VIEW tableau_cohort_dataset AS
SELECT
    cohort_month,
    tenure_bucket,
    retained_users,
    cohort_size,
    retention_rate
FROM cohort_retention_final;

SHOW FULL TABLES
WHERE TABLE_TYPE='VIEW';



-- COHORT ISSUE RESOLVING
SELECT *
FROM cohort_retention_final
LIMIT 50;


CREATE OR REPLACE VIEW tableau_cohort_dataset AS
SELECT
    cohort_month,
    tenure_bucket,
    retained_users,
    cohort_size,
    retention_rate
FROM cohort_retention_final;


SELECT COUNT(*)
FROM cohort_retention_final;



