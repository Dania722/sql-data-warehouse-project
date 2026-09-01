-- Har country ke customers ka count nikaalo (GROUP BY country). 
select count(customer_number) as customerCount, country  from gold.dim_customers
group by country


-- Har product category ki total sales_amount nikaalo (fact_sales ko dim_products se JOIN karke).
SELECT p.category , sum(sales_amount) as TotalSales 
FROM gold.dim_products p
LEFT JOIN gold.fact_sales s
ON p.product_key = s.product_key
group by p.category ;


-- Har customer ka naam aur unki total kharidari (SUM(sales_amount)) nikaalo, JOIN use karke.
select top 5  CONCAT(c.first_name, ' ', c.last_name) AS full_name ,  sum(s.sales_amount) as TotalSales   from gold.dim_customers c 
LEFT JOIN gold.fact_sales s
ON c.customer_key = s.customer_key
group by CONCAT(c.first_name, ' ', c.last_name);


-- Sabse zyada bikne wale (by quantity) top 5 products nikaalo.
SELECT top 5 p.product_name , sum(s.quantity) as Total
FROM gold.dim_products p
LEFT JOIN gold.fact_sales s
ON p.product_key = s.product_key
group by p.product_name 
order by Total DESC ;


--Average sales_amount nikaalo har product_line ke liye.
SELECT  p.product_line ,avg(s.sales_amount) as TotalSales 
FROM gold.dim_products p
LEFT JOIN gold.fact_sales s
ON p.product_key = s.product_key
group by  p.product_line 


--Un customers ki list nikaalo jinhone kabhi koi order nahi kiya (Hint: LEFT JOIN + WHERE ... IS NULL).
select   CONCAT(c.first_name, ' ', c.last_name) AS full_name ,  sum(s.sales_amount) as TotalSales   from gold.dim_customers c 
LEFT JOIN gold.fact_sales s
ON c.customer_key = s.customer_key
where s.sales_amount   is null  or s.order_number is null 
group by CONCAT(c.first_name, ' ', c.last_name);


-- Male vs Female customers ka count compare karo.
select   count (gender) ,  gender   from gold.dim_customers 
group by gender ;

--Saal (year) ke hisaab se total sales nikaalo (order_date se YEAR() nikaal ke GROUP BY karo).
SELECT YEAR(order_date)  AS order_year , sum(sales_amount) as TotalSales 
FROM gold.fact_sales
group by YEAR(order_date) ;
