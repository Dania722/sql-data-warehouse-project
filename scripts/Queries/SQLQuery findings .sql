-- 1. Total revenue aur order count (headline number)
SELECT COUNT(DISTINCT order_number) AS total_orders, SUM(sales_amount) AS total_revenue
FROM gold.fact_sales;

-- 2. Top 3 countries by sales
SELECT TOP 3 c.country, SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sales DESC;

-- 3. Top 3 product categories by revenue
SELECT TOP 3 p.category, SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_sales DESC;

-- 4. Sales trend by year (growth story ke liye)
SELECT YEAR(order_date) AS sales_year, SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY sales_year;
-- 5. Top 5 best-selling products (by revenue)
SELECT TOP 5 p.product_name, SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_sales DESC;

-- 6. Average order value
SELECT SUM(sales_amount) * 1.0 / COUNT(DISTINCT order_number) AS avg_order_value
FROM gold.fact_sales;

-- 7. Male vs Female spending comparison
SELECT c.gender, SUM(f.sales_amount) AS total_sales, COUNT(DISTINCT c.customer_key) AS customer_count
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.gender;

-- 8. Top 5 highest-spending individual customers
SELECT TOP 5 CONCAT(c.first_name, ' ', c.last_name) AS customer_name, SUM(f.sales_amount) AS total_spent
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY CONCAT(c.first_name, ' ', c.last_name)
ORDER BY total_spent DESC;

-- 9. Product line performance (Mountain, Road, Touring, etc.)
SELECT p.product_line, SUM(f.sales_amount) AS total_sales, SUM(f.quantity) AS units_sold
FROM gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.product_line
ORDER BY total_sales DESC;

-- 10. Percentage of total revenue from top country (headline "wow" stat)
SELECT TOP 1 c.country, 
    SUM(f.sales_amount) AS country_sales,
    CAST(SUM(f.sales_amount) * 100.0 / (SELECT SUM(sales_amount) FROM gold.fact_sales) AS DECIMAL(5,2)) AS pct_of_total
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY country_sales DESC;

-- 11. Repeat customers vs one-time buyers (loyalty insight)
SELECT 
    CASE WHEN order_count = 1 THEN 'One-time buyer' ELSE 'Repeat customer' END AS customer_type,
    COUNT(*) AS total_customers
FROM (
    SELECT customer_key, COUNT(DISTINCT order_number) AS order_count
    FROM gold.fact_sales
    GROUP BY customer_key
) t
GROUP BY CASE WHEN order_count = 1 THEN 'One-time buyer' ELSE 'Repeat customer' END;

-- 12. Which month has historically the highest sales (seasonality)
SELECT MONTH(order_date) AS sales_month, SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY total_sales DESC;

-- 13. Marital status vs average spending (behavioral insight)
SELECT c.marital_status, AVG(f.sales_amount) AS avg_sale, COUNT(DISTINCT c.customer_key) AS customers
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.marital_status;

-- 14. Small group of customers driving big % of revenue (Pareto/80-20 check)
SELECT TOP 10 PERCENT CONCAT(c.first_name,' ',c.last_name) AS customer_name, SUM(f.sales_amount) AS total_spent
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY CONCAT(c.first_name,' ',c.last_name)
ORDER BY total_spent DESC;
-- Compare this sum manually against overall total (query 1) to get their % contribution

-- 15. Fastest vs slowest shipping (operational insight)
SELECT AVG(DATEDIFF(DAY, order_date, shipping_date)) AS avg_days_to_ship
FROM gold.fact_sales
WHERE order_date IS NOT NULL AND shipping_date IS NOT NULL;

-- 16. Products that were discontinued (data quality/historical finding)
SELECT COUNT(*) AS discontinued_products
FROM silver.crm_prd_info
WHERE prd_end_dt IS NOT NULL;

-- 17. Age distribution of customers (using birthdate)
SELECT 
    CASE 
        WHEN DATEDIFF(YEAR, birthdate, GETDATE()) < 30 THEN 'Under 30'
        WHEN DATEDIFF(YEAR, birthdate, GETDATE()) BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Above 50'
    END AS age_group,
    COUNT(*) AS customer_count
FROM gold.dim_customers
WHERE birthdate IS NOT NULL
GROUP BY 
    CASE 
        WHEN DATEDIFF(YEAR, birthdate, GETDATE()) < 30 THEN 'Under 30'
        WHEN DATEDIFF(YEAR, birthdate, GETDATE()) BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Above 50'
    END;