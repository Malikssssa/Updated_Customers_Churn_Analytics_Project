-- HIGH RISK SEGMENT IDENTIFICATION

-- Churn Rate by Plan Type

SELECT
    plan_type,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_users,
    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS churn_rate
FROM customers_base
GROUP BY plan_type
ORDER BY churn_rate DESC;

-- Churn Rate by Engagement Level

SELECT
    engagement_bucket,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_users,
    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS churn_rate
FROM customers_base
GROUP BY engagement_bucket
ORDER BY churn_rate DESC;

-- Churn Rate by Usage Level

SELECT
    usage_bucket,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_users,
    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS churn_rate
FROM customers_base
GROUP BY usage_bucket
ORDER BY churn_rate DESC;

-- Churn Rate by Support Activity

SELECT
    support_bucket,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_users,
    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS churn_rate
FROM customers_base
GROUP BY support_bucket
ORDER BY churn_rate DESC;

-- Churn Rate by Payment Behaviour

SELECT
    payment_history,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_users,
    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS churn_rate
FROM customers_base
GROUP BY payment_history
ORDER BY churn_rate DESC;

-- Worst Case Customer Segments

SELECT
    plan_type,
    engagement_bucket,
    usage_bucket,
    COUNT(*) AS total_users,
    SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) AS churned_users,
    ROUND(
        SUM(CASE WHEN churn_status = 'Churned' THEN 1 ELSE 0 END) / COUNT(*),
        3
    ) AS churn_rate
FROM customers_base
GROUP BY plan_type, engagement_bucket, usage_bucket
HAVING COUNT(*) >= 20
ORDER BY churn_rate DESC;