# Task-1: What percentage of total orders were shipped on the same date?

with cte as(select count(*) as total_count
from superstore),

b as(select Ship_Date, Count(*) as ship, (select total_count
                            from cte) as a
from superstore
group by Ship_Date)

select round((ship/a)*100, 1) as Same_Day_Shipping_Percentage
from b


# Task-2: Name top 3 customers with highest total value of orders.

select Customer_Name, sum(sales) as t
from superstore
group by Customer_Name
order by t desc
limit 3


# Task-3: Find the top 5 items with the highest average sales per day.

with cte as(select Product_ID, sum(Sales) as Average_Sales
from superstore
group by Product_ID
order by Average_Sales desc
limit 5)

select Product_ID, cast(Average_Sales as decimal(20,8))
from cte


# Task-4: Write a query to find the average order value for each customer, and order the customers by their average order value, descending.

select Customer_ID, Customer_Name, avg(Sales) as Avg_Order_Value
from superstore
group by Customer_ID
order by Avg_Order_Value


# Task-5: Provide the names of customers who placed the highest and lowest orders based on the total sales of each customer within each city.

with cte as(select City, customer_name, sum(sales) as s
from superstore
group by city, customer_name),

maximum as(select city, customer_name, s, row_number() over(partition by city order by s desc) as rn_max
from cte),

minimum as(select city, customer_name, s, row_number() over(partition by city order by s asc) as rn_min
from cte),

a as(select city, s as highest_order_sales, customer_name as highest_order_customer
from maximum
where rn_max=1),

b as(select city, s as lowest_order_sales, customer_name as lowest_order_customer
from minimum
where rn_min=1)


select a.city, highest_order_sales, lowest_order_sales, highest_order_customer, lowest_order_customer
from a inner join b
on a.city=b.city


# Task-6: What is the most demanded sub-category in the west region?

select Sub_Category, sum(sales) as total_quantity
from superstore
where Region='West'
group by Region, Sub_Category
order by total_quantity desc
limit 1


# Task-7: Which order has the highest number of items? And which order has the highest cumulative value?

select order_id, count(Product_id) as c
from superstore
group by Order_id
order by c desc
limit 1


# Task-8: Which order has the highest cumulative value?

select Order_id, sum(Sales) as S
from superstore
group by Order_id
order by s desc
limit 1


# Task-9: Which segment’s order is more likely to be shipped via first class?

select segment, count(Ship_Mode) as s
from superstore
where Ship_Mode = 'First Class'
group by segment
order by s desc
limit 1


# Task-10: Which city is least contributing to total revenue?

select city, count(Product_id)*sum(sales) as s
from superstore
group by city
order by s 
limit 1


# Task-11: What is the average time for orders to get shipped after order is placed?

select ifnull(avg(datediff(Order_Date, Ship_Date)), 0) as d 
from superstore


# Task-12: Which city is contributing more to total revenue?

select city, sum(sales) as s
from superstore
group by city
order by s desc
limit 1


# Task-13: Find the maximum number of days for which total sales on each day kept rising.

with cte as(select Order_Date, Sum(sales) as ts
from superstore
group by 1
order by 1),

cte2 as(select *, lag(ts) over(order by Order_Date) as pre_sales
from cte),

cte3 as(select *,
case when ts>pre_sales then 1 else 0
end as count_sales
from cte2)

select sum(count_sales)
from cte3

