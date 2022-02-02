/*	Excersises */

USE TSQLV4;

-- Exc 1. Return orders placed in 2015 from Sales.Orders table

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate BETWEEN '2015-06-01' AND '2015-06-30';

-- Exc 2. Return orders placed on the last day of the month from Sales.Orders

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = EOMONTH(orderdate);

-- or

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = DATEADD(month, DATEDIFF(month, '18991231', orderdate), '18991231');

-- Exc 3. Write a query against HR.employees table that returns employees with a last name containing letter e twice or more:

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE LEN(lastname) - LEN(REPLACE(lastname, 'e', '')) >= 2;

-- or

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname LIKE '%e%e%';

/*	Exc 4. Write a query against Sales.OrderDetails tbl that returns orders with a total value (qty * unitprice)
	greater than 10000, sorted by total value */

SELECT orderid, SUM(qty * unitprice) AS totalvalue
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(qty * unitprice) > 10000
ORDER BY totalvalue DESC;

/*	Exc 5. Check the validity of data, write a query  aginst the HR.Employees table that returns employees
	with a last name that starts with a lower case. Remember that the collection of sample databse is case insensitive
	(Latin1_General_CI_AS): */

SELECT empid, lastname
FROM HR.Employees
WHERE LEFT(PATINDEX('[a-z]', lastname), 1) = 1;

-- or

SELECT empid, lastname
FROM HR.Employees
WHERE lastname COLLATE Latin1_General_CS_AS LIKE N'[abcdefghijklmnopqrstuvwxyz]%';

-- Exc 6. explain the difference

SELECT empid, COUNT(*) AS numorders
FROM Sales.Orders
WHERE orderdate < '20160501' -- orderdate smaller per each orders
GROUP BY empid; 
-- WHERE is row filter

SELECT empid, COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY empid
HAVING MAX(orderdate) < '20160501'; -- max order date per group
-- HAVING is a group filer

-- Exc 7.

-- write a query against Sales.Orders tbl that returns 3 shipping-to countries with highest average freight in 2013

SELECT TOP(3) shipcountry, AVG(freight) AS avgefreight
FROM Sales.Orders
WHERE YEAR(orderdate) = '2015'
GROUP BY shipcountry
ORDER BY avgefreight DESC;

-- or

SELECT shipcountry, AVG(freight) AS avgefreight
FROM Sales.Orders
WHERE orderdate >= '20150101' AND orderdate < '20160101'
GROUP BY shipcountry
ORDER BY avgefreight DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

/*	Exc 8. write query against Sales.Orders tbl that calculates row numbers for orders based on order date ordering
	(using the order ID as the tiebreaker) for each customer separately */

/*	Because the excercise requests row number calculation for each custumer separately,
	the expression should patition the window by custid. */

SELECT 
	ROW_NUMBER() OVER (PARTITION BY custid ORDER BY orderdate, orderid) AS rownumber,
	custid, orderdate, orderid
FROM Sales.Orders
ORDER BY custid, rownumber;

/*	Exc. 9 Using the HR.Employees tbl, write a SELECT statement that returns for each employee the gender
	based on the title of courtesy. For 'Ms' and 'Mrs' return 'Female'; for 'Mr' return 'Male',
	and in all other cases(for example 'Dr.') return 'Unknown', */

SELECT
	empid, firstname, lastname, titleofcourtesy,
	CASE
		WHEN titleofcourtesy = 'Ms.' OR titleofcourtesy = 'Mrs.' THEN 'Famale'
		WHEN titleofcourtesy = 'Mr.' THEN 'Male'
		ELSE 'Unknown'
	END AS gender
FROM HR.Employees;

/*	Exc. 10 Write a query against the Sales.Orders tbl that returns for each customer the customer ID and region.
	Sort the rows in the output by region, having NULLs sort last (after non-NULL values).
	Note that the default sort behaviour for NULLs in T-SQL is to be sort first. */

SELECT custid, region
FROM Sales.Customers
ORDER BY CASE WHEN region IS NULL THEN 1 ELSE 0 END, region;

-- use case expressions to get NULLs last and then sort by the column
-- for demo purposes:
SELECT region,
	CASE WHEN region IS NULL THEN 1 ELSE 0 END
FROM Sales.Customers
ORDER BY CASE WHEN region IS NULL THEN 1 ELSE 0 END