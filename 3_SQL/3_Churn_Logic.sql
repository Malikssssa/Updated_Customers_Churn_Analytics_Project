-- Churn Logic

-- disabling safe mode
SET SQL_SAFE_UPDATES = 0;


-- add churn and risk columns
ALTER TABLE customers_base
ADD COLUMN churn_status VARCHAR(20),
ADD COLUMN risk_score INT;



-- populate risk score
UPDATE customers_base
SET risk_score =
    (
        -- Recency risk (most important churn signal)
        CASE
            WHEN days_since_last_login > 90 THEN 4
            WHEN days_since_last_login BETWEEN 60 AND 90 THEN 3
            WHEN days_since_last_login BETWEEN 31 AND 59 THEN 2
            WHEN days_since_last_login BETWEEN 15 AND 30 THEN 1
            ELSE 0
        END

        +

        -- Engagement risk
        CASE
            WHEN engagement_bucket = 'Low' THEN 2
            WHEN engagement_bucket = 'Medium' THEN 1
            ELSE 0
        END

        +

        -- Usage risk
        CASE
            WHEN usage_bucket = 'Low' THEN 2
            WHEN usage_bucket = 'Medium' THEN 1
            ELSE 0
        END

        +

        -- Support friction
        CASE
            WHEN support_bucket = 'High' THEN 2
            WHEN support_bucket = 'Medium' THEN 1
            ELSE 0
        END

        +

        -- Payment risk
        CASE
            WHEN payment_history = 'Missed' THEN 3
            WHEN payment_history = 'Delayed' THEN 2
            ELSE 0
        END

        +

        -- Satisfaction signal
        CASE
            WHEN customer_satisfaction_score <= 3 THEN 3
            WHEN customer_satisfaction_score BETWEEN 4 AND 6 THEN 1
            ELSE 0
        END
    );



-- churn classification (tuned thresholds)
UPDATE customers_base
SET churn_status =
    CASE
        WHEN risk_score >= 9 THEN 'Churned'
        WHEN risk_score BETWEEN 5 AND 8 THEN 'At Risk'
        ELSE 'Active'
    END;



-- distribution check
SELECT
    churn_status,
    COUNT(*) AS users,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS percentage
FROM customers_base
GROUP BY churn_status;

UPDATE customers_base
SET churn_status =
CASE
    WHEN risk_score >= 9 THEN 'Churned'
    WHEN risk_score BETWEEN 5 AND 8 THEN 'At Risk'
    ELSE 'Active'
END;

-- inspect highest risk users
SELECT
    customer_id,
    churn_status,
    risk_score,
    days_since_last_login,
    engagement_bucket,
    usage_bucket,
    support_bucket,
    payment_history,
    customer_satisfaction_score
FROM customers_base
ORDER BY risk_score DESC
LIMIT 50;




SELECT 
    churn_status,
    COUNT(*) AS users,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM customers_base), 2) AS percentage
FROM customers_base
GROUP BY churn_status;