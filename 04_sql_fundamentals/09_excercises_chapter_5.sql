USE TSQLV4;
GO

/*	1. Query attems to filter orders that were not placed on the last day of the year. It's supposed to return the order id, order date, customer id, employee id, and respective end of the year date for each order.
	Explain what the problem is, and suggest a valid solution. */

SELECT orderid, orderdate, custid, empid, DATEFROMPARTS(YEAR(orderdate), 12, 31) AS endofyear
FROM Sales.Orders
WHERE orderdate <> DATEFROMPARTS(YEAR(orderdate), 12, 31);

/*	query execution order: FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY, LIMIT 
	The where clause is filtering the base data before returning the final data. And we use an allis in the SELECT statement but the system doesn't know it yet in the WHERE clause. */

/*	2.1. Write a query that returns the maximum value in the orderdate column for each employee. */

SELECT empid, MAX(orderdate) AS maxorderdate
FROM Sales.Orders
GROUP BY empid;

/*	2.2. Return orders for each maximum orderdate. */

SELECT MD.empid, MD.maxorderdate, O.orderid, O.custid
FROM Sales.Orders AS O
RIGHT JOIN (SELECT empid, MAX(orderdate) AS maxorderdate -- also INNER JOIN
			FROM Sales.Orders
			GROUP BY empid) AS MD
ON O.empid = MD.empid AND MD.maxorderdate = O.orderdate;

/*	3.1. Write a query that calculates a row number for each order based on orderdate, orderid ordering. */

SELECT orderid, orderdate, custid, empid, ROW_NUMBER() OVER(ORDER BY orderdate, orderid) AS rownum
FROM Sales.Orders;

/* 3.2. Write a query that returns rows numbers 11 through 20 based on the row-number definition in 3.1. */

WITH RowNum AS
(
	SELECT orderid, orderdate, custid, empid, ROW_NUMBER() OVER(ORDER BY orderdate, orderid) AS rownum
	FROM Sales.Orders
)
SELECT *
FROM RowNum
WHERE rownum BETWEEN 11 AND 20;

/* 4. Write a solution using a recursive CTE that returns the management chain leading to Patricia Doyle (employee ID 9). */
WITH EmpCTE AS
(
	SELECT empid, mgrid, firstname, lastname
	FROM HR.Employees
	WHERE empid = 9

	UNION ALL

	SELECT E.empid, E.mgrid, E.firstname, E.lastname
	FROM EmpCTE
	INNER JOIN HR.Employees AS E
	ON EmpCTE.mgrid = E.empid 
)
SELECT empid, mgrid, firstname, lastname
FROM EmpCTE;

/*	5.1. Create a view that returns the total quantity for each employee and year. */

DROP VIEW IF EXISTS Sales.VEmpOrders;
GO
CREATE VIEW Sales.VEmpOrders
AS
SELECT O.empid, YEAR(O.orderdate) AS orderyear, SUM(OD.qty) AS qty
FROM Sales.Orders AS O
INNER JOIN Sales.OrderDetails AS OD
ON O.orderid = OD.orderid
GROUP BY O.empid, YEAR(O.orderdate);
GO

SELECT * FROM Sales.VEmpOrders ORDER BY empid, orderyear;


/*	5.2. Write a query against Sales.VEmpOrders that retutns the running total quantity for each employee and year. */

SELECT *, SUM(qty) OVER (ORDER BY empid, orderyear) AS runningtotal FROM Sales.VEmpOrders;

/*	6.1. Create an inline TVF that accepts as inputs a supplier ID (@supid AS INT) and a requested number of products (@n AS INT).
	The function should return @n prodcts with the highest unit prices that are supplied by the specified supplier ID:
	Table involved: Production.Products. */

DROP FUNCTION IF EXISTS Production.TopProducts;
GO
CREATE FUNCTION Production.TopProducts (@supid INT, @n INT) RETURNS TABLE
AS
RETURN
	SELECT TOP(@n) productid, productname, unitprice
	FROM Production.Products 
	WHERE supplierid = @supid
	ORDER BY unitprice DESC;
GO

SELECT * FROM Production.TopProducts(7, 2);

-- alternatively
DROP FUNCTION IF EXISTS Production.TopProducts;
GO
CREATE FUNCTION Production.TopProducts (@supid INT, @n INT) RETURNS TABLE
AS
RETURN
	SELECT productid, productname, unitprice
	FROM Production.Products 
	WHERE supplierid = @supid
	ORDER BY unitprice DESC
	OFFSET 0 ROWS FETCH NEXT @n ROWS ONLY;
GO

SELECT * FROM Production.TopProducts(5, 2);

/*	6.2. Using CROSS APPLY operator and the function you created in Exc 6.1, return the two most expensive products for each supplier:
	Table involved: Production.Suppliers. */

-- Notes: to join the TVF you use CROSS APPLY (INNER JOIN won't work) CROSS APPLY works as INNER JOIN

SELECT S.supplierid, S.companyname, P.productid, P.productname, P.unitprice
FROM Production.Suppliers AS S
CROSS APPLY Production.TopProducts(S.supplierid, 2) AS P;