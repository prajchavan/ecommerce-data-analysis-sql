-- ==========================================
-- 1. Total Revenue
-- ==========================================

SELECT
    ROUND(SUM(total_sales), 2) AS total_revenue
FROM Order_Items;

-- ==========================================
-- 2. Total Profit
-- ==========================================

SELECT
    ROUND(SUM(profit), 2) AS total_profit
FROM Order_Items;

-- ==========================================
-- 3. Total Orders
-- ==========================================

SELECT
    COUNT(*) AS total_orders
FROM Orders;

-- ==========================================
-- 4. Total Customers
-- ==========================================

SELECT
    COUNT(*) AS total_customers
FROM Customers;

-- ==========================================
-- 5. Revenue by Category
-- ==========================================

SELECT
    c.category_name,
    ROUND(SUM(oi.total_sales),2) AS revenue
FROM Categories c
JOIN Products p
ON c.category_id = p.category_id
JOIN Order_Items oi
ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY revenue DESC;

-- ==========================================
-- 6. Profit by Category
-- ==========================================

SELECT
    c.category_name,
    ROUND(SUM(oi.profit),2) AS total_profit
FROM Categories c
JOIN Products p
ON c.category_id = p.category_id
JOIN Order_Items oi
ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY total_profit DESC;

-- ==========================================
-- 7. Top Products by Revenue
-- ==========================================

SELECT
    p.product_name,
    ROUND(SUM(oi.total_sales),2) AS revenue
FROM Products p
JOIN Order_Items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- ==========================================
-- 8. Top Products by Profit
-- ==========================================

SELECT
    p.product_name,
    ROUND(SUM(oi.profit),2) AS profit
FROM Products p
JOIN Order_Items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY profit DESC
LIMIT 10;

-- ==========================================
-- 9. Most Purchased Products
-- ==========================================

SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity
FROM Products p
JOIN Order_Items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 10;

-- ==========================================
-- 10. Sales by Customer Segment
-- ==========================================

SELECT
    c.customer_segment,
    ROUND(SUM(oi.total_sales),2) AS revenue
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
JOIN Order_Items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_segment
ORDER BY revenue DESC;

-- ==========================================
-- 11. Revenue by Country
-- ==========================================

SELECT
    c.country,
    ROUND(SUM(oi.total_sales),2) AS revenue
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY c.country
ORDER BY revenue DESC;

-- ==========================================
-- 12. Revenue by Region
-- ==========================================

SELECT
    c.region,
    ROUND(SUM(oi.total_sales),2) AS revenue
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY c.region
ORDER BY revenue DESC;

-- ==========================================
-- 13. Monthly Sales Trend
-- ==========================================

SELECT
    DATE_FORMAT(order_date,'%Y-%m') AS month,
    ROUND(SUM(total_sales),2) AS revenue
FROM Orders o
JOIN Order_Items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- ==========================================
-- 14. Monthly Profit Trend
-- ==========================================

SELECT
    DATE_FORMAT(order_date,'%Y-%m') AS month,
    ROUND(SUM(profit),2) AS profit
FROM Orders o
JOIN Order_Items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- ==========================================
-- 15. Payment Method Distribution
-- ==========================================

SELECT
    payment_method,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY payment_method
ORDER BY total_orders DESC;

-- ==========================================
-- 16. Average Order Value
-- ==========================================

SELECT
    ROUND(AVG(total_sales),2) AS average_order_value
FROM Order_Items;

-- ==========================================
-- 17. Top 10 Customers by Revenue
-- ==========================================

SELECT
    c.customer_name,
    ROUND(SUM(oi.total_sales),2) AS revenue
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
JOIN Order_Items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY revenue DESC
LIMIT 10;

-- ==========================================
-- 18. Top 10 Customers by Profit
-- ==========================================

SELECT
    c.customer_name,
    ROUND(SUM(oi.profit),2) AS profit
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
JOIN Order_Items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY profit DESC
LIMIT 10;

-- ==========================================
-- 19. Average Discount by Category
-- ==========================================

SELECT
    c.category_name,
    ROUND(AVG(oi.discount_percent),2) AS average_discount
FROM Categories c
JOIN Products p
ON c.category_id = p.category_id
JOIN Order_Items oi
ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY average_discount DESC;

-- ==========================================
-- 20. Profit Margin by Category
-- ==========================================

SELECT
    c.category_name,
    ROUND((SUM(oi.profit)/SUM(oi.total_sales))*100,2) AS profit_margin_percent
FROM Categories c
JOIN Products p
ON c.category_id = p.category_id
JOIN Order_Items oi
ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY profit_margin_percent DESC;

-- ==========================================
-- 21. Top 5 Customers by Revenue Within Each Segment
-- ==========================================

WITH CustomerRevenue AS (
    SELECT
        c.customer_segment,
        c.customer_name,
        ROUND(SUM(oi.total_sales),2) AS revenue,
        DENSE_RANK() OVER (
            PARTITION BY c.customer_segment
            ORDER BY SUM(oi.total_sales) DESC
        ) AS ranking
    FROM Customers c
    JOIN Orders o
        ON c.customer_id = o.customer_id
    JOIN Order_Items oi
        ON o.order_id = oi.order_id
    GROUP BY
        c.customer_segment,
        c.customer_name
)

SELECT
    customer_segment,
    customer_name,
    revenue,
    ranking
FROM CustomerRevenue
WHERE ranking <= 5
ORDER BY customer_segment, ranking;

-- ==========================================
-- 22. Month-over-Month Revenue Growth
-- ==========================================

WITH MonthlyRevenue AS (
    SELECT
        DATE_FORMAT(o.order_date,'%Y-%m') AS month,
        ROUND(SUM(oi.total_sales),2) AS revenue
    FROM Orders o
    JOIN Order_Items oi
        ON o.order_id = oi.order_id
    GROUP BY month
)

SELECT
    month,
    revenue,
    ROUND(
        revenue - LAG(revenue) OVER (ORDER BY month),
        2
    ) AS revenue_change,
    ROUND(
        (
            (revenue - LAG(revenue) OVER (ORDER BY month))
            / LAG(revenue) OVER (ORDER BY month)
        ) * 100,
        2
    ) AS growth_percentage
FROM MonthlyRevenue;

-- ==========================================
-- 23. Cumulative Monthly Revenue
-- ==========================================

WITH MonthlyRevenue AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        ROUND(SUM(oi.total_sales),2) AS revenue
    FROM Orders o
    JOIN Order_Items oi
        ON o.order_id = oi.order_id
    GROUP BY month
)

SELECT
    month,
    revenue,
    ROUND(
        SUM(revenue) OVER (
            ORDER BY month
        ),
        2
    ) AS cumulative_revenue
FROM MonthlyRevenue;