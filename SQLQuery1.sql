
-- Select all products with brand Cacti Plus
select * from dbo.product where brand ='Cacti Plus'

-- Count of total products with product category=Skin Care
select count(*) from dbo.product where category ='Skin Care'

-- Count of total products with MRP more than 100
select count(*) from dbo.product where mrp > 100

-- Count of total products with product category =Skin Care and MRP more than 100
select count(*) from dbo.product where category ='Skin Care' and  mrp > 100

-- Brandwise product count
select count(*) from dbo.product group by brand

-- Brandwise as well as Active/Inactive Status wise product count
select count(*) from dbo.product where active IN('Y','N') group by brand 

-- Display all columns with Product category in Skin Care or Hair Care
select * from dbo.product where category = 'Skin Care' or category = 'Hair Care'

-- Display all columns with Product category in Skin Care or Hair Care, and MRP more than 100
select * from dbo.product where category = 'Skin Care' or category = 'Hair Care' and mrp > 100

-- Display   all   columns   with   Product   category=Skin   Care   and
-- Brand=Pondy, and MRP more than 100
select * from dbo.product where category = 'Skin Care' and brand = 'Pondy' and mrp >100

-- Display   all   columns   with   Product   category   =Skin   Care   or
-- Brand=Pondy, and more than 100
select * from dbo.product where category = 'Skin Care' or brand = 'Pondy' and mrp >100

-- Display all product names only with names starting from letter P
select product_name from dbo.product where product_name like 'P%'

-- Display  all product  names only with names Having letters Bar  in Between
select product_name from dbo.product where product_name like '%Bar%'

-- Sales of those products which have been sold in more than two quantity in a bill
select*from dbo.sales where qty>2

-- Sales of those products which have been sold in more than two quantity throughout the bill
select product_id,sum(qty)from dbo.sales group by product_id having sum(qty)>2 

-- Create a new table with columns username and birthday, and dump data from dates file. Convert it to .csv format if required.
Create table employee(
username varchar(30),
birthday date);

BULK INSERT dbo.employee
FROM 'C:\Users\poonam\Documents\date.csv'
WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  ROWTERMINATOR ='\n'
)
select * from dbo.employee

-- Research on Date Function Queries from the slide
-- After populating the data, find no of people sharing
-- Birth date
select count(username) from dbo.employee where birthday IN( select birthday from dbo.employee group by birthday having count(birthday)> 1)

-- Find no of people sharing Birth month
select count(*) as Total, datename(month, birthday) as MonthName
from employee group by datename(month, birthday) order by Monthname;

-- Find no of people sharing weekday
select count(*) as Total, datename(weekday, datepart(weekday, birthday)) as Weekday
from employee group by datepart(weekday, birthday);

-- Find the current age of all people
select *, datediff(year, birthday, getdate()) age from employee;


