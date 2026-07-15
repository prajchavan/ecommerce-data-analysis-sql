-- ==========================================
-- Global E-Commerce Sales Analysis Database
-- ==========================================

DROP DATABASE IF EXISTS ecommerce;

CREATE DATABASE ecommerce;

USE ecommerce;

-- ==========================================
-- Customers
-- ==========================================

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    customer_segment VARCHAR(50) NOT NULL,
    country VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);

-- ==========================================
-- Categories
-- ==========================================

CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- ==========================================
-- Products
-- ==========================================

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category_id INT NOT NULL,

    FOREIGN KEY (category_id)
        REFERENCES Categories(category_id)
);

-- ==========================================
-- Orders
-- ==========================================

CREATE TABLE Orders (
    order_id VARCHAR(30) PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    shipping_cost DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);

-- ==========================================
-- Order Items
-- ==========================================

CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(30) NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_percent DECIMAL(5,2) NOT NULL,
    total_sales DECIMAL(10,2) NOT NULL,
    profit DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);