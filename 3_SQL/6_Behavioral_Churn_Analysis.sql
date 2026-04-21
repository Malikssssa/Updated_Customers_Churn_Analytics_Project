-- behavioral churn analysis

-- Time to churn (tenure comparsion)
SELECT
    churn_status,
    ROUND(AVG(tenure_months),2) AS avg_tenure_months,
    MIN(tenure_months) AS min_tenure,
    MAX(tenure_months) AS max_tenure
FROM customers_base
GROUP BY churn_status;

-- inactivity behavior
SELECT
    churn_status,
    ROUND(AVG(days_since_last_login),2) AS avg_days_inactive
FROM customers_base
GROUP BY churn_status;

-- Satisfaction comparison
SELECT
    churn_status,
    ROUND(AVG(customer_satisfaction_score),2) AS avg_satisfaction
FROM customers_base
GROUP BY churn_status;

-- Revenue behavior
SELECT
    churn_status,
    ROUND(AVG(monthly_revenue),2) AS avg_monthly_revenue
FROM customers_base
GROUP BY churn_status;

-- Payment behavior
SELECT
    payment_history,
    churn_status,
    COUNT(*) AS users
FROM customers_base
GROUP BY payment_history, churn_status
ORDER BY payment_history, churn_status;

-- Engagement bucket vs churn
SELECT
    engagement_bucket,
    churn_status,
    COUNT(*) AS users
FROM customers_base
GROUP BY engagement_bucket, churn_status
ORDER BY engagement_bucket;

-- Usage bucket vs churn
SELECT
    usage_bucket,
    churn_status,
    COUNT(*) AS users
FROM customers_base
GROUP BY usage_bucket, churn_status
ORDER BY usage_bucket;

-- Support behavior vs churn
SELECT
    support_bucket,
    churn_status,
    COUNT(*) AS users
FROM customers_base
GROUP BY support_bucket, churn_status
ORDER BY support_bucket;

-- Early warning signal summary
SELECT
    churn_status,
    ROUND(AVG(days_since_last_login),2) AS avg_inactivity_days,
    ROUND(AVG(customer_satisfaction_score),2) AS avg_satisfaction,
    ROUND(AVG(monthly_revenue),2) AS avg_revenue
FROM customers_base
GROUP BY churn_status;