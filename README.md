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


## 📊 Customer Behavior & Revenue Analysis Dashboard (Power BI)


## 🎯 Key Objectives

* Understand **customer order frequency distribution**
* Identify **repeat vs new customer trends**
* Analyze **revenue contribution by customer segments**
* Detect **loss-making products**
* Provide **actionable business insights**

---

## 📊 Dashboard Highlights

### 👥 Customer Insights

* Total Customers: **795**
* Maximum Orders by a Customer: **47**
* Average Orders per Customer: **32.39**

---

### 🔁 Customer Behavior

* ~**97% customers are repeat customers**
* Strong indication of **high customer retention**
* Majority of customers fall in the **31–40 order range**

---

### 📦 Order Frequency Analysis

* Most customers belong to the **medium-to-high frequency segment**
* Very few customers fall into the low-frequency group
* Indicates a **loyal and engaged customer base**

---

### 💰 Revenue Insights

* Higher order-frequency customers contribute **disproportionately more revenue**
* Even though they are fewer in number, their **business impact is significant**
* Opportunity to **target and retain high-frequency users**

---

### ⚠️ Loss Analysis

* Identified multiple products with **negative profit margins**
* Indicates:

  * Possible **over-discounting**
  * **High cost vs selling price imbalance**
* These products are **key drivers of overall profitability loss**

---

## 💡 Key Business Insights

* The business demonstrates **exceptionally high retention (~97%)**, indicating strong customer loyalty
* A large portion of customers consistently place **31–40 orders**, forming the core user base
* **High-frequency customers generate the majority of revenue**, making them critical for growth strategy
* A subset of products contributes to **consistent losses**, highlighting opportunities for pricing and cost optimization

---

## 🛠 Tools & Technologies

* **SQL (MySQL)** → Data extraction & aggregation
* **Power BI** → Data modeling & visualization
* **DAX** → Measures & business logic

---

## 🚀 Key Features

* Customer segmentation based on order frequency
* Revenue distribution by customer behavior
* Repeat vs new customer analysis
* Loss-making product identification

---

## 📌 Conclusion

This dashboard provides a **holistic view of customer behavior and business performance**, enabling better decision-making in:

* Customer retention strategies
* Revenue optimization
* Product-level profitability improvements

  

## 📌 Author

**Elakkiya Loganathan**

---

⭐ If you found this useful, feel free to star the repo!
