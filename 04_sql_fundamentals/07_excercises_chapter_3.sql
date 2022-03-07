/*	1.1. Write a query that generates five copies of each employee row. */

SELECT E.empid, E.firstname, E.lastname, N.n
FROM HR.Employees AS E
	CROSS JOIN dbo.Nums AS N
WHERE N.n <= 5
ORDER BY n, empid;

/*	1.2. Write a query that returns a row for each employee and day in the range June 12, 2016 through June 16, 2016. */

SELECT E.empid, DATEADD(day, N.n-1, CAST('20160612' AS DATE)) AS dt
FROM HR.Employees AS E
	CROSS JOIN dbo.Nums AS N
WHERE DATEADD(day, N.n-1, CAST('20160612' AS DATE)) <= '20160616'
-- WHERE N.n <= DATEDIFF(day, '20160612', '20160616') + 1
ORDER BY E.empid;

/*	2. Explain what's wrong in the following query, and provide a correct alternative. */

--SELECT *
--FROM Sales.Customers AS C
--	INNER JOIN Sales.Orders AS O
--	ON Customers.custid = Orders.custid;  remove aliases or use them

SELECT *
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
	ON C.custid = O.custid;

/*	3. Return US customers, and for each customer return the total number of orders and total quantities. */

SELECT C.custid, COUNT(DISTINCT(O.orderid)) AS numorders, SUM(OD.qty) AS totalqty
FROM Sales.Customers AS C
	LEFT JOIN Sales.Orders AS O
	ON C.custid = O.custid
		INNER JOIN Sales.OrderDetails AS OD
		ON O.orderid = OD.orderid
WHERE O.shipcountry = N'USA'
GROUP BY C.custid
ORDER BY C.custid;

/*	4. Return customers and their orders, including customers who placed no order. */

SELECT C.custid, O.orderid
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
	ON C.custid = O.custid;

/* 5. Return customers who places no orders. */

SELECT C.custid, O.orderid
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
	ON C.custid = O.custid
WHERE O.orderid IS NULL;


/*	6. Return customers with orders placed on February 12, 2016, along with their orders. */

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
	ON C.custid = O.custid
WHERE O.orderdate = '20160212';

/*	7. Write a query that resturns all customers in the output, but matches them with their respective orders
	only if they were placed on February 12, 2016. */

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O -- outer join to preserve all customers, even if they don't have matching orders
	ON O.custid = C.custid
	AND O.orderdate = '2016-02-12'; 

/*	The predicate based on order date is nonfinal, as such must appeach in ON caluse and not the WHERE
	The goal is to match orders to customers only if the order was placed by the customer on 2nd Feb, 2016. But, you still
	want to get customers who didn't place orders on the date in the output. */


/*	8. Explain wy the following query isn't a correct solusion for Excercise 7. */

SELECT *
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
	ON O.custid = C.custid
WHERE O.orderdate = '2016-02-12' OR O.orderid IS NULL; 

-- query returns customers who places order on 2nd Feb 2016 and customer who didn't place order at all

/*	9. Return all customers, and for each return a Yes/No value depending on whether the customer placed orders on Feb 12, 2016. */

SELECT DISTINCT C.custid, C.companyname, -- technicaaly you can have more then one match per customer, you should add DISTINCT clause
	CASE WHEN O.orderdate IS NULL THEN 'No' ELSE 'Yes' END AS HasOrderOn20160212
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
	ON O.custid = C.custid
	AND O.orderdate = '2016-02-12'; 