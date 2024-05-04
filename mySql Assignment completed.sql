
-- --------------- Day 3----------------------
Use Classicmodels;
-- 1)
select customerNumber , CustomerName , State , CreditLimit from customers 
where state is not null 
and creditLimit between 50000 and 100000 
order by creditLimit desc ;

-- 2)
select distinct productLine from products where productLine like "%Cars";

-- --------------- Day 4 ------------------------
-- 1) 
select orderNumber , Status ,coalesce(comments, "_") as Comments from orders
where status="shipped"; 

-- 2)

select EmployeeNumber , FirstName , JobTitle , 
case  
	when JobTitle="President" then 'p'
    when JobTitle like "Sale Manager%" or JobTitle like"Sales Manager%" then 'SM'
    when JobTitle="Sales Rep" then 'SR'
    when JobTitle like"%VP%" then "VP"
    else "_"
    END AS jobTitleAbbr
from employees;


			-- _____________  Day 5 _____________________
-- 1)
select Year(paymentDate) as Year, min(amount) as "Min Amount" from payments group by year order by year;

-- 2)
select year(orderDate) as Year , concat('Q',quarter(orderDate)) as Quarter , count(distinct(customerNumber)) as "Unique Customers" , count(orderNumber) from orders group by Year, quarter;

-- 3)
select monthname(paymentDate) as Month, concat(round(sum(amount)/1000) ,"K") as "Formatted Amount" 
from payments
group by Month
having sum(amount) between 500000 and 1000000 
order by concat(round(sum(amount)/1000) ,"K") desc;

				-- _______________  Day 6 ________________
                
-- 1) 
create table Journey ( 
Bus_ID Int not null,
Bus_Name Varchar(20) not null,
Source_Station Varchar(20) not null,
Destination Varchar(20) not null,
Email varchar(50) unique
);

-- 2)
Create table Vender(
Vender_Id int primary key,
Name varchar(20) not null,
Email Varchar(50) unique,
Country varchar(20) default "N/A"
); 

-- 3)

create table Movies(
Movie_ID int primary key,
Name varchar(20) not null,
Release_Year char(4) default "_",
Cast Varchar(20) Not Null,
Gender varchar(10) check(gender in("Male","Female")),
No_of_shows int check( No_of_shows >0)
); 

-- 4)
create table Suppliers(
Supplier_Id int primary key auto_increment,
Supplier_Name Varchar(20),
Location Varchar(100)
);

create table Product(
Product_Id int Primary key auto_increment,
Product_name varchar(50) not null unique,
Description text ,
Supplier_id int,
foreign key(Supplier_id) references suppliers(Supplier_Id))
;

create table Stock(
Id int primary key auto_increment,
Product_id int ,
Balance_Stock Int,
foreign key (Product_id) references product(Product_id)
);

		-- ______________ Day 7 _________________
        
        
desc products;
desc customers;
desc orders;
select * from products;
select * from customers;
select * from orders;
select* from orderdetails;

-- 1)
select e.employeeNumber , concat(firstName," ",LastName) as "Sales Person" , count(c.customerName) as UniqueCustomers
from employees as e join customers as c on e.employeeNumber = c.salesRepEmployeeNumber 
group by e.employeeNumber
order by UniqueCustomers desc;


-- 2)
select c.customerNumber,  c.customerName , p.productCode as ProductCode ,P.productName ,p.quantityInStock as "Total Inventory " ,
sum(od.quantityOrdered) as "Order Qty" , 
(P.quantityInStock - sum(od.quantityOrdered)) as "Left Qty"
from customers as c join orders as o on o.customerNumber = c.customerNumber
join orderdetails as od on od.orderNumber =o.orderNumber
join  products as p on od.productCode = p.productCode
group by c.customerNumber,P.productCode order by c.customerNumber
;


-- 3)

create Table Laptop (Laptop_Name varchar(30));
insert into Laptop Values("HP"),("Dell"),("Asus");

create table Colours (Colour_Name varchar(20));
insert into Colours Values("Red"),("Blue"),("Grey");
select L.Laptop_Name , c.colour_Name from Laptop as L cross join Colours as c;

-- 4)

Create Table Project( EmployeeId int , FullName varchar(20), Gender Varchar(10) check(gender in ("Male","Female")), ManagerID int );

INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

select M.fullName  as "Manager Name", E.fullName as "Emp Name"
from project as E  join Project as M on E.EmployeeId = M.EmployeeId
group by M.fullName;

-- _______________ Day 8 ___________________
create table Facility (Facility_Id int , Name Varchar (20) , State varchar(20) , Country varchar(20));

-- step 1 - Create new  new_ids column
-- step 2 - drop Existing Facility_Id column 
-- step 3 - rename New_ids column with Facility_Id with primary key and auto_increment...

alter table Facility add column new_Ids int;
alter table facility drop column Facility_Id;
alter table facility 
change column new_ids Facility_Id  int primary key auto_increment;
desc facility;

--        ________________________ Day 9 __________________

create table University ( Id int , Name Varchar (20));
alter table University modify Name varchar(100);

INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
update university set name = replace(name,"  "," ");
select * from university;

--       _________________________ Day 10 _____________________
select * from products;
select * from customers;


select 
year(o.orderDAte) as OrderYear,
concat(
count(od.productCode),
"(",
concat(ROUND((count(od.productcode)/(SELECT count(productcode) from Orderdetails))*100),
"%"),")") as "VALUE" 
from Orders o
join OrderDetails od using (orderNumber)
group by OrderYear
order by Value desc;
set sql_mode ="";
select * from Orderdetails;
select * from Orders;

    --   _________________________ Day 11 ______________________
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Country_Payment`(Input_Year varchar(20) , Country_name varchar(100))
BEGIN
select year(paymentdate) as Year,country,concat(round(sum(amount)/1000), "K") as Total_Amount from Customers
join Payments using(customernumber)
where year(paymentdate) = Input_Year and country = Country_name
group by Country, Year(paymentdate);
END//
--  __________________________ Day 12 _____________________

-- 1)

select
year(orderdate) as "YEAR",
monthname(orderdate) as "Month",
count(ordernumber) as "Total Orders",
concat(
round(((count(ordernumber)- lag(count(ordernumber),1) over())/ 
lag(count(ordernumber),1) over())*100),"%") as "% YOY Chnage" 
from Orders
group by Year,Month;

-- 2)

CREATE TABLE emp_udf (
    Emp_ID INT ,
    Name VARCHAR(50),
    DOB DATE
);
INSERT INTO emp_udf (Name, DOB)
VALUES
    ('Piyush', '1990-03-30'),
    ('Aman', '1992-08-15'),
    ('Meena', '1998-07-28'),
    ('Ketan', '2000-11-21'),
    ('Sanjay', '1995-05-21');
SELECT Name, calculate_age(DOB) AS Age FROM emp_udf;

delimiter //
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_age`( dob DATE ) 
RETURNS varchar(50) CHARSET latinl
deterministic
BEGIN
DECLARE years INT;
DECLARE months INT;
set years = (TIMESTAMPDIFF(YEAR, dob, CURDATE()));
set months = (TIMESTAMPDIFF(MONTH, dob, CURDATE()) % 12);
RETURN CONCAT(years,'years', months ,'months');
END //

-- ________________13__________

-- 1)
select * from orders;
select customerNumber , CustomerName from customers where customerNumber not in (select customerNumber from orders) order by customerNumber;

-- 2)
SELECT c.customerNumber, c.customerName, COUNT(o.orderNumber) AS totalorders
FROM Customers c
LEFT JOIN Orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName
UNION
SELECT c.customerNumber, c.customerName, COUNT(o.orderNumber) AS totalorders
FROM Customers c
RIGHT JOIN Orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber, c.customerName;
select * from customers;
-- 3)

WITH RankedOrders AS (
  SELECT
    orderNumber,
    quantityOrdered,
    DENSE_RANK() OVER (PARTITION BY orderNumber ORDER BY quantityOrdered DESC) AS quantity_rank
  FROM
    orderdetails
)

SELECT
  orderNumber,
  quantityOrdered AS second_highest_quantity
FROM
  RankedOrders
WHERE
  quantity_rank = 2;
  
-- 4)

With OrderProductCount as(
select OrderNUmber , count(Productcode) as ProductCount from orderDetails
group by OrderNumber
)
select Min(productCount) , Max(productCount) from OrderProductCount;

-- 5)
select ProductLine , count(*) as Total from products 
where buyPrice > (select avg(buyPrice) from products)
group by productline
order by total desc
; 
 

-- _____________________________ Day 14 ___________________________

create table  Emp_Eh ( EmpID int primary key , EmpName Varchar(20) , EmailAddress Varchar(50));

delimeter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `Procd_Emp_EH`(empId int , empName varchar(20) , emailAddress varchar(50))
Begin
declare exit handler for 1062 select " EmpId can not be blank and duplicate";
insert into emp_eh values(empid , empname , emailaddress);
select * from emp_eh;
end//

--  ___________________________ Day 15 _______________________________

create table emp_bit(Name varchar(20) , Occupation varchar(20) , Working_date date , Working_hours int);
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11); 

delimiter //
CREATE DEFINER=`root`@`localhost` TRIGGER `emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW BEGIN
if new.working_hours <0 then set new.working_hours=-(new.working_hours);
end if ;
END //

