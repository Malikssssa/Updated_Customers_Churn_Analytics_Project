CREATE DATABASE churn_analysis;

USE churn_analysis;

CREATE TABLE customers_churn_demo (
    customer_id VARCHAR(20) PRIMARY KEY,
    signup_date DATE,
    age INT,
    gender VARCHAR(10),
    region VARCHAR(50),
    subscription_plan VARCHAR(20),
    monthly_fee NUMERIC(10,2),
    customer_satisfaction_score INT,
    daily_watch_time_hours NUMERIC(5,2),
    engagement_rate INT,
    device_used VARCHAR(20),
    genre_preference VARCHAR(30),
    payment_history VARCHAR(20),
    support_queries INT,
    promotional_offers_used INT,
    profiles_created INT,
    last_login_date DATE
);
