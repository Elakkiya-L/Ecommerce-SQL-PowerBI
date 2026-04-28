-- Checking for Null values
SELECT 
    SUM(order_id IS NULL) AS order_id_nulls,
    SUM(order_date IS NULL) AS order_date_nulls,
    SUM(ship_date IS NULL) AS ship_date_nulls,
    SUM(customer_name IS NULL) AS customer_name_nulls,
    SUM(sales IS NULL) AS sales_nulls,
    SUM(profit IS NULL) AS profit_nulls
FROM superstore;

-- Checking for invalid formats in date
SELECT 
    SUM(STR_TO_DATE(REPLACE(order_date, '-', '/'), '%d/%m/%Y') IS NULL) AS bad_order_date,
    SUM(STR_TO_DATE(REPLACE(ship_date, '-', '/'), '%d/%m/%Y') IS NULL) AS bad_ship_date
FROM superstore;

-- Checking for numeric Columns
SELECT 
    SUM(sales NOT REGEXP '^[0-9.]+$') AS bad_sales,
    SUM(profit NOT REGEXP '^-?[0-9]+(\\.[0-9]+)?$') AS bad_profit,
    SUM(quantity NOT REGEXP '^[0-9.]+$') AS bad_quantity,
    SUM(shipping_cost NOT REGEXP '^-?[0-9]+(\\.[0-9]+)?$') As bad_shipping_cost
FROM superstore;


-- cross Checking if these columns have any values than given expression
SELECT sales, profit,shopping_cost
FROM superstore
WHERE sales NOT REGEXP '^[0-9.]+$'
   OR profit NOT REGEXP '^-?[0-9]+(\\.[0-9]+)?$'
   or shipping_cost not regexp '^-?[0-9]+(\\.[0-9]+)?$' 
LIMIT 20;

-- Updating the table 
UPDATE superstore
SET sales = TRIM(REPLACE(REPLACE(sales, ',', ''), '$', '')),
    profit =TRIM(REPLACE(REPLACE(profit, ',', ''), '$', '')),
    shipping_cost =TRIM(REPLACE(REPLACE(profit, ',', ''), '$', ''));

-- Changing the datatypes of the columns    
ALTER TABLE superstore
MODIFY sales DECIMAL(10,2),
MODIFY profit DECIMAL(10,2),
MODIFY shipping_cost DECIMAL(10,2),
MODIFY quantity INT;

-- Update date 
-- likely have mixed formats:13/01/2011,13-01-2011
UPDATE superstore
SET order_date = STR_TO_DATE(REPLACE(order_date, '-', '/'), '%d/%m/%Y'),
    ship_date  = STR_TO_DATE(REPLACE(ship_date, '-', '/'), '%d/%m/%Y');
    
-- Convert the datatype to DATE
ALTER TABLE superstore
MODIFY order_date DATE,
MODIFY ship_date DATE;

-- Check if order_date > shipping_date
select order_date,ship_date from superstore
where order_date> ship_date;

-- To check if the data types have changed
Describe superstore;
