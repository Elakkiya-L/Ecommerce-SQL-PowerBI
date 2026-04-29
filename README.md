# 🛒 E-Commerce SQL Analysis Project (Superstore Dataset)

## 📌 Project Overview

This project focuses on analyzing an e-commerce dataset using SQL to extract meaningful business insights.
The goal is to simulate real-world business scenarios such as customer behavior, product performance, and revenue trends.

---

## 📂 Dataset

* Source: Superstore dataset (Kaggle)
* Domain: Retail / E-commerce
* Data includes:

  * Orders
  * Customers
  * Products
  * Sales, Profit, Quantity
  * Regions and Categories

---

## 🧹 Data Preparation

Key cleaning steps performed:

* Converted date columns to proper format (`order_date`, `ship_date`)
* Handled inconsistent formats in sales and profit
* Ensured correct data types for numeric columns
* Removed duplicates where necessary

---

## 📊 Key SQL Analyses

### 🔹 1. Orders per Customer

```sql
CREATE VIEW orders_per_customer AS
SELECT 
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY customer_name;
```

👉 Insight:

* Helps identify high-value vs low-frequency customers

---

### 🔹 2. Category with Highest Sales

```sql
SELECT 
    category,
    SUM(sales) AS total_sales
FROM superstore
GROUP BY category
ORDER BY total_sales DESC
LIMIT 1;
```

👉 Insight:

* Identifies top-performing product category

---

### 🔹 3. Category with Lowest Profit

```sql
SELECT 
    category,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY category
ORDER BY total_profit ASC
LIMIT 1;
```

👉 Insight:

* Highlights categories impacting profitability

---

### 🔹 4. Loss-Making Products

```sql
SELECT 
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM superstore
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_sales DESC;
```

👉 Insight:

* Products generating revenue but causing losses

---

### 🔹 5. Repeat vs New Customers

```sql
WITH orders AS (
    SELECT DISTINCT customer_name, order_id, order_date
    FROM superstore
),
ranked AS (
    SELECT 
        customer_name,
        order_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_name 
            ORDER BY order_date
        ) AS rn
    FROM orders
)
SELECT 
    customer_name,
    order_id,
    CASE 
        WHEN rn = 1 THEN 'New'
        ELSE 'Repeat'
    END AS customer_type
FROM ranked;
```

👉 Insight:

* Measures customer retention and loyalty

---

### 🔹 6. Cohort Analysis (Customer Retention)

```sql
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
```

👉 Insight:

* Tracks how customers return over time

---

## 🧠 Key Business Insights

* 📈 Revenue shows consistent year-over-year growth
* 💰 Technology category generates highest sales
* ⚠️ Some high-selling products are loss-making
* 🔁 Majority of customers are one-time buyers
* 📉 Customer retention drops over time

---

## 🛠️ Tools Used

* MySQL
* SQL (CTEs, Window Functions, Aggregations)

---

## 🚀 Next Steps

* Build Power BI dashboard
* Visualize:

  * Revenue trends
  * Customer retention
  * Product performance
* Add business storytelling

---

## 📌 Author

**Elakkiya Loganathan**

---

⭐ If you found this useful, feel free to star the repo!
