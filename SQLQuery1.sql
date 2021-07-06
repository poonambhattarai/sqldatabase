CREATE DATABASE ecommerce;
USE ecommerce;

select * from dbo.product;

-- DML Queries
 --DAY 1
--Select all products with brand �Cacti Plus�
select * from dbo.product where brand ='Cacti Plus'

--Count of total products with product category=�Skin Care�
select count(*) from dbo.product where category ='Skin Care'

--Count of total products with MRP more than 100
select count(*) from dbo.product where mrp > 100

--Count of total products with product category =�Skin Care� and MRP more than 100
select count(*) from dbo.product where category ='Skin Care' and  mrp > 100

--Brandwise product count
select count(*) from dbo.product group by brand

--Brandwise as well as Active/Inactive Status wise product count
select count(*) from dbo.product where active IN('Y','N') group by brand 

--Display all columns with Product category in Skin Care or Hair Care
select * from dbo.product where category = 'Skin Care' or category = 'Hair Care'

--Display all columns with Product category in Skin Care or Hair Care, and MRP more than 100
select * from dbo.product where category = 'Skin Care' or category = 'Hair Care' and mrp > 100

--Display   all   columns   with   Product   category=�Skin   Care�   and Brand=�Pondy�, and MRP more than 100
select * from dbo.product where category = 'Skin Care' and brand = 'Pondy' and mrp >100

--Display   all   columns   with   Product   category   =�Skin   Care�   or Brand=�Pondy�, and more than 100
select * from dbo.product where category = 'Skin Care' or brand = 'Pondy' and mrp >100

--Display all product names only with names starting from letter P
select product_name from dbo.product where product_name like 'P%'

--Display  all product  names only with names Having letters �Bar�  in Between
select product_name from dbo.product where product_name like '%Bar%'

--Sales of those products which have been sold in more than two quantity in a bill
select*from dbo.sales where qty>2

--Sales of those products which have been sold in more than two quantity throughout the bill
select product_id,sum(qty)from dbo.sales group by product_id having sum(qty)>2 

select * from dbo.employee

--Birth date
select count(username) from employee where birthday
IN( select birthday from dbo.employee group by birthday having count(birthday)> 1)

-- Birth month
select count(username) from dbo.employee where birthday 
IN( select birthday from dbo.employee group by birthday having count(birthday)> 1)

-- Find no of people sharing Birth month
select count(*) as Total, datename(month, birthday) as MonthName
from dbo.employee group by datename(month, birthday) order by Monthname;

-- Find no of people sharing weekday
select count(*) as Total, datename(weekday, datepart(weekday, birthday)) as Weekday
from employee group by datepart(weekday, birthday);

-- Find the current age of all people
select *, datediff(year, birthday, getdate()) age from employee;

--DAY 2
--Display product name, customer name and discount amount where discount has been provided (discount_amt > 0) using
--Subquery
select product_name,first_name,last_name from sales,product,customer where discount_amt> 0 and product_name 
in( select product_name from product where product.product_id= sales.product_id) 
and user_name in(select user_name from customer where customer.customer_id= sales.customer_id)

--JOIN
select product_name,first_name,last_name,discount_amt from product inner join
sales on product.product_id = sales.product_id inner join customer on sales.customer_id = customer.customer_id where discount_amt>0

--Display product wise sum of sales amount ordered with highest sales amount on top.
select product_id, sum(net_bill_amt)as sumofsales from sales group by product_id order by sum(net_bill_amt) desc

--Display brand wise sum of sales amount ordered with highest sales amount on top.
select brand, sum(net_bill_amt) as sumofsales from sales inner join product on sales.product_id=product.product_id group by brand order by sum(net_bill_amt) desc

--Display category, brand and product wise sum of sales amount ordered with category, brand and product in ascending order.
select category, brand,sales.product_id, sum(net_bill_amt) as sumofsales from sales  inner join product on sales.product_id=product.product_id 
group by sales.product_id,category,brand order by sales.product_id,category,brand asc

--Display product_id and product name from the list of products which have not been billed yet using
--Subquery
select product_id,product_name from product where product_id NOT IN(select product_id from sales)
--select product_name,product_id from product where product_id IN(select product_id from sales where getdate()<bill_date)
--JOIN
select product.product_id, product_name from product left join sales on product.product_id = sales.product_id where bill_no is null
--EXCEPT along with
--WHERE ___ IN
select product_id, product_name from product where product_id  NOT IN (select product_id from sales)
--JOIN
(select product_name,product.product_id from product left join sales on product.product_id = sales.product_id)
except (select product_name,product.product_id from product right join sales on product.product_id= sales.product_id)


--Display list of brands whose products have not been billed yet.
select brand from product where product_id not in (select product_id from sales)

--Display all the products� sales quantity sorting by sales quantity. If it has no sales, show it as null.
select sum(qty) as AllProductSalesQuantity from sales group by qty order by qty asc

--Display product name and customer name from the list of products which have been purchased by a single customer only.
select distinct s1.product_id, s1.customer_id from sales s1
inner join (
           select product_id, count(distinct customer_id) as count from sales
              group by product_id
            having count(distinct customer_id) = 1
           ) s2
on s1.product_id = s2.product_id

--Display customer name and the total amount spent of the highest spending customer/s using a combination of JOIN and subquery.
select first_name, last_name,net_bill_amt from customer inner join sales on customer.customer_id = sales.customer_id where net_bill_amt =
(select MAX(net_bill_amt) from sales)

--Display customer name, product name whose maximum quantity is sold and that maximum quantity of each bill.
select first_name, last_name,product_name, qty from sales inner join
product on sales.product_id = product.product_id inner join
customer on sales.customer_id = customer.customer_id 
 where qty = (select MAX(qty) from sales)



