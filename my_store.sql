-- Creating Databse for a Local Retail Shop --
create database more_supermarket;
use more_supermarket;

drop table if exists my_store;
create table my_store(
transaction_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(15), 
age int,
category varchar(15),
quantity int,
price_per_unit float,
cogs float,
total_sale float
);

select * from my_store;
select count(*) from my_store;

-- Data Cleaning --
-- To check for null values --
select * from my_store
where transaction_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null;

-- To delete null values --
delete from my_store
where transaction_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null;

-- Data Exploration --
-- How many sales do we have? --
select count(*) as total_sale from my_store;

-- How many unique customers do we have? --
select count(distinct customer_id) as total_customers from my_store;
select distinct category from my_store;

-- Data Analysis and Business Key Problems & Answers --
-- My Analysis & Findings --

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05' --
select * from my_store where sale_date = '2022-11-05';

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022 --

select category, quantity from my_store where category = 'Clothing' and quantity >=4 group by 1;

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category --

select category, sum(total_sale) as net_sale, count(*) as total_orders from my_store group by 1;

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category --
select category,round(avg(age),2) as avg_age
from my_store
where category = "Beauty";

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000 --
select transaction_id, total_sale from my_store 
where total_sale >=1000;

-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category --
select * from my_store;

select category, gender, count(*) as total_trans
from my_store 
group by category, gender 
order by 1;

-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year --

select year, month , avg_sale from
(
select
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rankk
from my_store
group by 1,2
) as t1 where rankk = 1;

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales --
select * from my_store;

select customer_id, sum(total_sale) as sales
from my_store
group by 1
order by 2 desc
limit 5;

-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category --

select category, count(distinct customer_id) as customers
from my_store
group by category; 

-- Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17) --

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM my_store
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- End of Project --









