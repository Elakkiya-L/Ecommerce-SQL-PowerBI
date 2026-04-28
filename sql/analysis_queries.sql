---------------------------------------
-- ### Basic Business Metrics 
----------------------------------------

-- 1.Total Revenue,Profits and Metrics
SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(sales) AS total_revenue,
    SUM(profit) AS total_profit
FROM superstore;

-- 2.Monthly Sales Trend
SELECT 
    YEAR(order_date) AS yr,
    MONTH(order_date) AS mn,
    SUM(sales) AS revenue
FROM superstore
GROUP BY yr, mn
ORDER BY yr, mn;

---------------------------------------
-- ### Customer analysis
----------------------------------------

--3.Top 10 Customers
SELECT 
    customer_name,
    SUM(sales) AS total_spent
FROM superstore
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 10;

--4. Orders per Customer
SELECT 
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY customer_name
ORDER BY total_orders DESC;

---------------------------------------
-- ### Product And Category Insights 
----------------------------------------
--5. Sales by Catergory
SELECT 
    category,
    SUM(sales) AS revenue,
    SUM(profit) AS profit
FROM superstore
GROUP BY category;

-- 6. Top Products
SELECT 
    product_name,
    SUM(sales) AS revenue
FROM superstore
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;

-- Category with highest Sales
SELECT 
    category,
    SUM(sales) AS total_sales
FROM superstore
GROUP BY category
ORDER BY total_sales DESC
LIMIT 1;

-- 8. Category with low_profit
SELECT 
    category,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY category
ORDER BY total_profit ASC
LIMIT 1;

---------------------------------------
-- ### Profit Insights
----------------------------------------

-- 9. Loss-making Products
SELECT 
    product_name,
    SUM(profit) AS total_loss
FROM superstore
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_loss;

-- 10. Sales by Region
SELECT 
    region,
    SUM(sales) AS revenue,
    SUM(profit) AS profit
FROM superstore
GROUP BY region;

--11. surprising loss products
SELECT 
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_sales DESC;
---------------------------------------
-- ### Business Analysis 
----------------------------------------
-- 12.Repeat vs New Customers
WITH orders AS (
    SELECT DISTINCT 
        customer_name,
        order_id,
        order_date
    FROM superstore
),
lagged AS (
    SELECT 
        customer_name,
        order_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_name 
            ORDER BY order_date
        ) AS prev_order
    FROM orders
)

SELECT 
    customer_name,
    order_id,
    CASE 
        WHEN prev_order IS NULL THEN 'New'
        ELSE 'Repeat'
    END AS customer_type
FROM lagged;

---------------------------------------
-- ### Cohort Analysis 
----------------------------------------
-- 13.

WITH first_purchase AS (
    SELECT 
        customer_name,
        MIN(order_date) AS first_date
    FROM superstore
    GROUP BY customer_name
),

cohort_index AS (
    SELECT 
        s.customer_name,
        DATE_FORMAT(f.first_date, '%Y-%m') AS cohort_month,
        PERIOD_DIFF(
            DATE_FORMAT(s.order_date, '%Y%m'),
            DATE_FORMAT(f.first_date, '%Y%m')
        ) AS month_number
    FROM superstore s
    JOIN first_purchase f
    ON s.customer_name = f.customer_name
)

SELECT 
    cohort_month,
    month_number,
    COUNT(DISTINCT customer_name) AS customers
FROM cohort_index
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;
