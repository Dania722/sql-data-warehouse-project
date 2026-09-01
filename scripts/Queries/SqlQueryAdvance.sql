-- Har customer ka naam aur unka sabse pehla order date (MIN(order_date)) nikaalo.
select top 5 CONCAT(c.first_name, ' ', c.last_name) AS full_name  , min(s.order_date) as firstOrder  , max(s.order_date)as lastestOrder 
from gold.dim_customers c 
LEFT JOIN gold.fact_sales s
ON c.customer_key = s.customer_key
group by CONCAT(c.first_name, ' ', c.last_name)

-- RANK() window function use karke har category ke andar products ko unki cost ke hisaab se rank do.
SELECT  top 11 p.category,  p.product_name , sum(p.cost) as TotalSales ,
Rank() Over( Partition by p.category order by  sum(s.sales_amount)DESC ) AS CategoryRank
FROM gold.dim_products p
LEFT JOIN gold.fact_sales s
ON p.product_key = s.product_key
group by p.category ,  p.product_name;

-- Ek CTE (WITH clause) banao jo pehle har customer ki total sales calculate kare, phir usse top 3 customers select karo.
WITH customerTotalSales AS (
    SELECT CONCAT(c.first_name, ' ', c.last_name) AS fullname, SUM(s.sales_amount) AS TotalSales  
    FROM gold.dim_customers c 
    LEFT JOIN gold.fact_sales s 
        ON c.customer_key = s.customer_key
    GROUP BY CONCAT(c.first_name, ' ', c.last_name)
)
SELECT TOP 3 fullname, TotalSales 
FROM customerTotalSales 
ORDER BY TotalSales DESC;