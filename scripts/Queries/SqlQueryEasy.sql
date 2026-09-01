--  customers ka first_name, last_name, aur country
select first_name , last_name , country from gold.dim_customers

-- Saare products dikhao jinki category = 'Bikes'.
select * from gold.dim_products
where category ='Bikes'

-- Sabse mehenge (cost) top 10 products dikhao (highest se lowest).
SELECT TOP 10 product_name, cost
FROM gold.dim_products
ORDER BY cost DESC;

--Un customers ko dikhao jinka country = 'Germany'.
select * from gold.dim_customers
where country = 'Germany'

-- fact_sales se un records ko dikhao jinki sales_amount 1000 se zyada hai.
 select * from gold.fact_sales
 where sales_amount > 1000


--Saare unique (distinct) countries ki list nikaalo dim_customers se. 
select distinct(country) from gold.dim_customers
 
-- dim_products mein jitne bhi rows hain unka total count nikaalo.
select count(product_key) as totalRows from gold.dim_products



