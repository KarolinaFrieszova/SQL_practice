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

-- Exc 3. Write a query against HR.employees table that returns employees with a last name containing letter e twice or more:

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE LEN(lastname) - LEN(REPLACE(lastname, 'e', '')) >= 2;

-- Exc 4. return from Sales.OrderDetails orders with a total value (qty * unitprice) greater than 10000, sorted by total value

SELECT orderid, (qty * unitprice) AS totalvalue
FROM Sales.OrderDetails
WHERE (qty * unitprice) > 10000
ORDER BY totalvalue DESC;

/*	Exc 5. Check the validity of data, write a query  aginst the HR.Employees table that returns employees
	with a last name that starts with a lower case. Remember that the collection of sample databse is case insensitive
	(Latin1_General_CI_AS): */

SELECT empid, lastname
FROM HR.Employees
WHERE LEFT(PATINDEX('[a-z]', lastname), 1) = 1;