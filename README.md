# Global E-Commerce Sales Analysis using SQL

## Overview

This project analyzes a global e-commerce sales dataset using MySQL. The raw CSV dataset is transformed into a normalized relational database, followed by SQL-based business analysis to generate insights into sales performance, customer behavior, product performance, and revenue trends.

The project demonstrates database design, ETL, data cleaning, SQL joins, aggregations, Common Table Expressions (CTEs), and Window Functions.

## Technologies Used

* MySQL
* SQL
* VS Code
* Terminal
* CSV Dataset

## Dataset

The project uses a global e-commerce sales dataset containing order information, customer details, product information, sales, profit, discounts, shipping cost, and payment methods.

## Database Design

The raw dataset was normalized into five related tables:

* Customers
* Categories
* Products
* Orders
* Order_Items

An Entity Relationship Diagram (ERD) is included in this repository.

## ETL Process

1. Import raw CSV data into a staging table.
2. Clean and standardize imported data.
3. Populate normalized tables.
4. Establish relationships using primary and foreign keys.

## Business Analysis

The project includes 23 SQL queries covering:

* Revenue and Profit Analysis
* Category Performance
* Product Performance
* Customer Analysis
* Regional Analysis
* Monthly Sales Trends
* Payment Method Analysis
* Discount Analysis
* Profit Margin Analysis
* Advanced SQL using CTEs and Window Functions

## Advanced SQL Concepts Used

* Common Table Expressions (CTEs)
* Window Functions
* DENSE_RANK()
* LAG()
* Running Totals
* Aggregate Functions
* GROUP BY
* JOIN Operations

## Sample Results

The repository includes screenshots of the database schema and sample query results for key business analyses.

## Key Learnings

* Database normalization
* ETL using SQL
* Relational database design
* Business analytics using SQL
* Advanced SQL techniques using CTEs and Window Functions
