-- REVENUE IMPACT ANALYSIS

-- Average Revenue Per User by Churn Status

SELECT
    churn_status,
    ROUND(AVG(monthly_revenue), 2) AS avg_monthly_revenue
FROM customers_base
GROUP BY churn_status;

-- Total Revenue by Churn Status

SELECT
    churn_status,
    ROUND(SUM(monthly_revenue), 2) AS total_monthly_revenue
FROM customers_base
GROUP BY churn_status;

-- Revenue Lost Due to Churn

SELECT
    ROUND(SUM(monthly_revenue), 2) AS churned_revenue_loss
FROM customers_base
WHERE churn_status = 'Churned';

-- Revenue At Risk

SELECT
    ROUND(SUM(monthly_revenue), 2) AS revenue_at_risk
FROM customers_base
WHERE churn_status = 'At Risk';

-- High Value Customers Who Churned

SELECT
    customer_id,
    plan_type,
    monthly_revenue,
    risk_score,
    days_since_last_login,
    engagement_bucket
FROM customers_base
WHERE churn_status = 'Churned'
ORDER BY monthly_revenue DESC
LIMIT 20;

-- Revenue by Subscription Plan

SELECT
    plan_type,
    churn_status,
    ROUND(SUM(monthly_revenue), 2) AS total_revenue
FROM customers_base
GROUP BY plan_type, churn_status
ORDER BY plan_type, churn_status;

-- Monthly Revenue Trend

SELECT
    signup_month,
    ROUND(SUM(monthly_revenue), 2) AS total_revenue
FROM customers_base
GROUP BY signup_month
ORDER BY signup_month;


