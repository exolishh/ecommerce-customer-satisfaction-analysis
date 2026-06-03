-- ============================================
-- Olist E-Commerce — Seller Performance Analysis
-- 7 Business Queries
-- ============================================


-- Q1: Sellers with highest bad review rates
-- (minimum 50 orders)
SELECT 
    seller_id,
    seller_state,
    COUNT(order_id) as total_orders,
    ROUND(AVG(review_score), 2) as avg_review_score,
    ROUND(SUM(is_bad_review) * 100.0 / COUNT(order_id), 1) as bad_review_rate_pct
FROM orders_master
GROUP BY seller_id, seller_state
HAVING total_orders >= 50
ORDER BY bad_review_rate_pct DESC
LIMIT 10;


-- Q2: Sellers with chronic delivery delays
SELECT 
    seller_id,
    seller_state,
    COUNT(order_id) as total_orders,
    ROUND(AVG(delivery_delay_days), 1) as avg_delay_days,
    ROUND(SUM(is_late) * 100.0 / COUNT(order_id), 1) as late_rate_pct,
    ROUND(AVG(review_score), 2) as avg_review_score
FROM orders_master
GROUP BY seller_id, seller_state
HAVING total_orders >= 50
ORDER BY late_rate_pct DESC
LIMIT 10;


-- Q3: Top sellers by revenue
SELECT 
    seller_id,
    seller_state,
    COUNT(order_id) as total_orders,
    ROUND(SUM(total_price), 2) as total_revenue,
    ROUND(AVG(review_score), 2) as avg_review_score,
    ROUND(SUM(is_bad_review) * 100.0 / COUNT(order_id), 1) as bad_review_rate_pct
FROM orders_master
GROUP BY seller_id, seller_state
HAVING total_orders >= 50
ORDER BY total_revenue DESC
LIMIT 10;


-- Q4: CTE — Seller risk scorecard
WITH seller_stats AS (
    SELECT 
        seller_id,
        seller_state,
        COUNT(order_id) as total_orders,
        ROUND(AVG(review_score), 2) as avg_review_score,
        ROUND(SUM(is_bad_review) * 100.0 / COUNT(order_id), 1) as bad_review_rate_pct,
        ROUND(AVG(delivery_delay_days), 1) as avg_delay_days,
        ROUND(SUM(is_late) * 100.0 / COUNT(order_id), 1) as late_rate_pct,
        ROUND(SUM(total_price), 2) as total_revenue
    FROM orders_master
    GROUP BY seller_id, seller_state
    HAVING total_orders >= 50
),
seller_scored AS (
    SELECT *,
        CASE 
            WHEN bad_review_rate_pct >= 20 THEN 'High Risk'
            WHEN bad_review_rate_pct >= 15 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END as risk_category
    FROM seller_stats
)
SELECT 
    risk_category,
    COUNT(*) as seller_count,
    ROUND(AVG(total_orders), 0) as avg_orders,
    ROUND(AVG(bad_review_rate_pct), 1) as avg_bad_review_rate,
    ROUND(AVG(late_rate_pct), 1) as avg_late_rate,
    ROUND(SUM(total_revenue), 2) as total_revenue
FROM seller_scored
GROUP BY risk_category
ORDER BY avg_bad_review_rate DESC;


-- Q5: Window function — rank sellers within state
WITH seller_stats AS (
    SELECT 
        seller_id,
        seller_state,
        COUNT(order_id) as total_orders,
        ROUND(AVG(review_score), 2) as avg_review_score,
        ROUND(SUM(is_bad_review) * 100.0 / COUNT(order_id), 1) as bad_review_rate_pct
    FROM orders_master
    GROUP BY seller_id, seller_state
    HAVING total_orders >= 50
)
SELECT *,
    RANK() OVER (
        PARTITION BY seller_state 
        ORDER BY bad_review_rate_pct DESC
    ) as rank_within_state
FROM seller_stats
ORDER BY seller_state, rank_within_state
LIMIT 20;


-- Q6: High revenue sellers with high complaints
WITH seller_stats AS (
    SELECT 
        seller_id,
        seller_state,
        COUNT(order_id) as total_orders,
        ROUND(SUM(total_price), 2) as total_revenue,
        ROUND(SUM(is_bad_review) * 100.0 / COUNT(order_id), 1) as bad_review_rate_pct,
        ROUND(AVG(delivery_delay_days), 1) as avg_delay_days
    FROM orders_master
    GROUP BY seller_id, seller_state
    HAVING total_orders >= 50
)
SELECT *
FROM seller_stats
WHERE total_revenue > 50000
AND bad_review_rate_pct > 15
ORDER BY total_revenue DESC;


-- Q7: State level performance summary
SELECT 
    seller_state,
    COUNT(DISTINCT seller_id) as total_sellers,
    COUNT(order_id) as total_orders,
    ROUND(AVG(review_score), 2) as avg_review_score,
    ROUND(SUM(is_bad_review) * 100.0 / COUNT(order_id), 1) as bad_review_rate_pct,
    ROUND(AVG(actual_delivery_days), 1) as avg_delivery_days,
    ROUND(SUM(is_late) * 100.0 / COUNT(order_id), 1) as late_rate_pct
FROM orders_master
GROUP BY seller_state
ORDER BY total_orders DESC;
