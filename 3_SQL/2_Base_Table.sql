-- Base Table (Freelance Version)


-- Base Table

CREATE TABLE customers_base AS
SELECT
    *,
    
    -- Time-based features
    DATEDIFF(CURDATE(), signup_date) AS days_since_signup,
    FLOOR(DATEDIFF(CURDATE(), signup_date) / 30) AS tenure_months,

    -- Login activity bucket
    CASE
        WHEN days_since_last_login <= 7 THEN 'Very Active'
        WHEN days_since_last_login BETWEEN 8 AND 30 THEN 'Active'
        WHEN days_since_last_login BETWEEN 31 AND 90 THEN 'At Risk'
        ELSE 'Dormant'
    END AS login_activity_bucket,

    -- Revenue segment
    CASE
        WHEN monthly_revenue < 20 THEN 'Low Value'
        WHEN monthly_revenue BETWEEN 20 AND 60 THEN 'Mid Value'
        ELSE 'High Value'
    END AS revenue_segment

FROM customers_raw;

SELECT COUNT(*) FROM customers_base;