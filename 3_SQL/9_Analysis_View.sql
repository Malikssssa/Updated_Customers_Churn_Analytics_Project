-- ANALYSIS VIEWS 

-- Churn KPI Summary View

CREATE OR REPLACE VIEW churn_kpi_summary AS
SELECT
    signup_month,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churn_status = 'Active' THEN 1 ELSE 0 END) AS active_users,
    SUM(CASE WHEN churn_status = 'At Risk' THEN 1 ELSE 0 END) AS at_risk_users,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_users,
    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS churn_rate
FROM customers_base
GROUP BY signup_month;

-- Revenue Impact View

CREATE OR REPLACE VIEW revenue_impact_view AS
SELECT
    churn_status,
    COUNT(*) AS users,
    ROUND(SUM(monthly_revenue), 2) AS total_revenue,
    ROUND(AVG(monthly_revenue), 2) AS avg_revenue_per_user
FROM customers_base
GROUP BY churn_status;

-- High Risk Segment View

CREATE OR REPLACE VIEW high_risk_segments_view AS
SELECT
    plan_type,
    engagement_bucket,
    usage_bucket,
    support_bucket,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_users,
    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS churn_rate
FROM customers_base
GROUP BY plan_type, engagement_bucket, usage_bucket, support_bucket;

-- Behavioral Signals View

CREATE OR REPLACE VIEW behavioral_signals_view AS
SELECT
    churn_status,
    ROUND(AVG(days_since_last_login),2) AS avg_inactivity_days,
    ROUND(AVG(customer_satisfaction_score),2) AS avg_satisfaction,
    ROUND(AVG(monthly_revenue),2) AS avg_revenue
FROM customers_base
GROUP BY churn_status;

-- Customer Growth / Movement View

CREATE OR REPLACE VIEW customer_movement_view AS
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
FROM monthly_counts;