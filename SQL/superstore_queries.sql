-- ================================
-- Superstore Sales Analysis
-- Author: Dushyant
-- Tool: MySQL
-- Date: May 2026
-- ================================

USE superstore;

-- Query 1: Total Sales & Profit
SELECT 
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit)/SUM(Sales))*100, 2) 
    AS Profit_Margin_Percent
FROM orders;

-- Query 2: Sales by Region
SELECT 
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit)/SUM(Sales))*100, 2) 
    AS Profit_Margin
FROM orders
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Query 3: Sales by Category
SELECT 
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit)/SUM(Sales))*100, 2) 
    AS Profit_Margin,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY Category
ORDER BY Total_Sales DESC;

-- Query 4: Top 10 Customers
SELECT 
    Customer_Name,
    Segment,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY Customer_Name, Segment
ORDER BY Total_Sales DESC
LIMIT 10;

-- Query 5: Loss Making Products
SELECT 
    Sub_Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit)/SUM(Sales))*100, 2) 
    AS Profit_Margin,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY Sub_Category
HAVING Total_Profit < 0
ORDER BY Total_Profit ASC;

-- Query 6: Monthly Sales Trend
SELECT 
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month_Number,
    MONTHNAME(Order_Date) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM orders
GROUP BY 
    YEAR(Order_Date),
    MONTH(Order_Date),
    MONTHNAME(Order_Date)
ORDER BY Year ASC, Month_Number ASC;

-- Query 7: Top 10 Products
SELECT 
    Product_Name,
    Category,
    Sub_Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(*) AS Times_Ordered
FROM orders
GROUP BY 
    Product_Name,
    Category,
    Sub_Category
ORDER BY Total_Sales DESC
LIMIT 10;

-- Query 8: Window Function RANK
SELECT 
    Region,
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    RANK() OVER (
        PARTITION BY Region 
        ORDER BY SUM(Sales) DESC
    ) AS Sales_Rank
FROM orders
GROUP BY Region, Category
ORDER BY Region ASC, Sales_Rank ASC;

-- Query 9: YoY Growth
SELECT 
    Year,
    Total_Sales,
    LAG(Total_Sales) OVER (
        ORDER BY Year
    ) AS Previous_Year_Sales,
    ROUND(Total_Sales - LAG(Total_Sales) 
        OVER (ORDER BY Year), 2) 
        AS Sales_Growth,
    ROUND((Total_Sales - LAG(Total_Sales) 
        OVER (ORDER BY Year)) / 
        LAG(Total_Sales) 
        OVER (ORDER BY Year) * 100, 2) 
        AS Growth_Percent
FROM (
    SELECT 
        YEAR(Order_Date) AS Year,
        ROUND(SUM(Sales), 2) AS Total_Sales
    FROM orders
    GROUP BY YEAR(Order_Date)
) AS Yearly_Sales
ORDER BY Year ASC;

-- Query 10: Customer Segmentation
SELECT 
    Segment,
    COUNT(DISTINCT Customer_ID) 
        AS Total_Customers,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Sales), 2) AS Avg_Order_Value,
    ROUND(SUM(Sales) / 
        COUNT(DISTINCT Customer_ID), 2) 
        AS Sales_Per_Customer,
    ROUND((SUM(Profit)/SUM(Sales))*100, 2) 
        AS Profit_Margin
FROM orders
GROUP BY Segment
ORDER BY Total_Sales DESC;