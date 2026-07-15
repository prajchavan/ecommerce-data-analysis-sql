USE ecommerce;

DROP TABLE IF EXISTS raw_sales_data;

CREATE TABLE raw_sales_data (
    order_id VARCHAR(30),
    order_date DATE,
    customer_name VARCHAR(100),
    customer_segment VARCHAR(50),
    country VARCHAR(100),
    region VARCHAR(100),
    product_category VARCHAR(100),
    product_name VARCHAR(255),
    quantity INT,
    unit_price DECIMAL(10,2),
    discount_percent DECIMAL(5,2),
    total_sales DECIMAL(10,2),
    shipping_cost DECIMAL(10,2),
    profit DECIMAL(10,2),
    payment_method VARCHAR(50)
);

LOAD DATA LOCAL INFILE '/Users/prajaktachavan/Desktop/ecommerce/dataset/global_ecommerce_sales.csv'
INTO TABLE raw_sales_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    @order_date,
    customer_name,
    customer_segment,
    country,
    region,
    product_category,
    product_name,
    quantity,
    unit_price,
    discount_percent,
    total_sales,
    shipping_cost,
    profit,
    payment_method
)
SET
    order_date = STR_TO_DATE(@order_date, '%Y-%m-%d'),
    payment_method = TRIM(REPLACE(@payment_method, '\r', ''));

-- ==========================================
-- Clear Existing Data
-- ==========================================

DELETE FROM Order_Items;
DELETE FROM Orders;
DELETE FROM Products;
DELETE FROM Categories;
DELETE FROM Customers;

-- ==========================================
-- Populate Categories
-- ==========================================

INSERT INTO Categories (category_name)
SELECT DISTINCT product_category
FROM raw_sales_data;

-- ==========================================
-- Populate Customers
-- ==========================================

INSERT INTO Customers (
    customer_name,
    customer_segment,
    country,
    region
)
SELECT
    customer_name,
    MAX(customer_segment),
    MAX(country),
    MAX(region)
FROM raw_sales_data
GROUP BY customer_name;

-- ==========================================
-- Populate Products
-- ==========================================

INSERT INTO Products (
    product_name,
    category_id
)
SELECT DISTINCT
    r.product_name,
    c.category_id
FROM raw_sales_data r
JOIN Categories c
ON r.product_category = c.category_name;

-- ==========================================
-- Populate Orders
-- ==========================================

INSERT INTO Orders (
    order_id,
    customer_id,
    order_date,
    payment_method,
    shipping_cost
)
SELECT DISTINCT
    r.order_id,
    c.customer_id,
    r.order_date,
    r.payment_method,
    r.shipping_cost
FROM raw_sales_data r
JOIN Customers c
ON r.customer_name = c.customer_name;

-- ==========================================
-- Populate Order_Items
-- ==========================================

INSERT INTO Order_Items (
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_percent,
    total_sales,
    profit
)
SELECT
    r.order_id,
    p.product_id,
    r.quantity,
    r.unit_price,
    r.discount_percent,
    r.total_sales,
    r.profit
FROM raw_sales_data r
JOIN Products p
ON r.product_name = p.product_name;