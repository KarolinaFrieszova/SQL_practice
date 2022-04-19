USE TSQLV4;

/*	1. Write a query that returns all orders placed on the last day of activity that can be found in the Orders table. */

SELECT *
FROM Sales.Orders
WHERE orderdate = (SELECT MAX(orderdate)
				   FROM Sales.Orders);

/*	2. Write a query that returns all orders placed by th customer(s) who placed the highest number of orders. */
SELECT TOP(1) custid, COUNT(orderid) AS ordercount
FROM Sales.Orders
GROUP BY custid
ORDER BY ordercount DESC;

SELECT O1.custid, O1.orderid, O1.orderdate
FROM Sales.Orders AS O1
WHERE custid IN (SELECT TOP(1) WITH TIES O2.custid -- return customer or customers with the highest number of orders, in case there is more than one
				 FROM Sales.Orders AS O2
				 GROUP BY O2.custid
				 ORDER BY COUNT(O2.orderid) DESC);

/*	3. Write a query that returns employees who did not place orders on or after May 1, 2016. */

SELECT E.empid, E.firstname, E.lastname
FROM HR.Employees AS E
WHERE E.empid NOT IN (SELECT O.empid
					  FROM Sales.Orders AS O
					  WHERE O.orderdate >= '2016-05-01');

/*	4. Write a query that returns countries where are customers but not employees. */
SELECT * FROM HR.Employees;
SELECT * FROM Sales.Customers;

SELECT DISTINCT(C.country)
FROM Sales.Customers AS C
WHERE NOT EXISTS (SELECT DISTINCT(E.country)
				  FROM HR.Employees AS E
				  WHERE E.country = C.country);

-- or

SELECT DISTINCT(country)
FROM Sales.Customers
WHERE country NOT IN (SELECT DISTINCT(country)
					  FROM HR.Employees);

/*	5. Write a query that returns for each customer all orders placed on the customer last day of activity. */


SELECT O1.custid, O1.orderid, O1.orderdate
FROM Sales.Orders AS O1
WHERE orderdate = (SELECT MAX(O2.orderdate)
				   FROM Sales.Orders AS O2
				   WHERE O1.custid = O2.custid)
ORDER BY O1.custid;

/*	6. Write a query that returns customers who placed orders in 2015 but not in 2016. */

SELECT custid
FROM Sales.Orders
WHERE orderdate BETWEEN '2015-01-01' AND '2015-12-31';


SELECT *
FROM Sales.Customers AS C
WHERE	EXISTS (SELECT O.custid
					FROM Sales.Orders AS O
					WHERE O.orderdate BETWEEN '2015-01-01' AND '2015-12-31' AND C.custid = O.custid) 
		AND NOT EXISTS (SELECT O.custid
					FROM Sales.Orders AS O
					WHERE O.orderdate BETWEEN '2016-01-01' AND '2016-12-31' AND C.custid = O.custid);

/*	7. Write a query that returns customers who ordered product 12. */

SELECT *
FROM Sales.OrderDetails
WHERE productid = 12;

SELECT *
FROM Sales.Orders AS O
WHERE EXISTS (SELECT *
			  FROM Sales.OrderDetails AS OD
			  WHERE OD.productid = 12 
					AND O.orderid = OD.orderid);

SELECT *
FROM Sales.Customers AS C
WHERE EXISTS (SELECT *
			  FROM Sales.Orders AS O
			  WHERE EXISTS (SELECT *
							FROM Sales.OrderDetails AS OD
							WHERE OD.productid = 12 
							AND O.orderid = OD.orderid)
					AND C.custid = O.custid);

-- or

SELECT *
FROM Sales.Customers AS C
WHERE EXISTS (SELECT *
			  FROM Sales.Orders AS O
			  WHERE C.custid = O.custid
			  AND EXISTS (SELECT *
						  FROM Sales.OrderDetails AS OD
						  WHERE OD.productid = 12 
						  AND O.orderid = OD.orderid));

/*	8. Write a query that calculates a running-total quantity for each customer and month. */

SELECT *, (SELECT SUM(CO2.qty) -- aggregate all quantities from CO2 for the current customer in CO1 where the month from CO2 is on or before the current month in CO1
		   FROM Sales.CustOrders AS CO2
		   WHERE CO1.custid = CO2.custid AND CO2.ordermonth <= CO1.ordermonth)
FROM Sales.CustOrders AS CO1
ORDER BY CO1.custid, CO1.ordermonth;

/*	9. Explain the difference between IN and EXISTS. 
	if NULLs are not involved, IN and EXISTS give same results in positives or negatices (with NOT).
	When NULLs are involved IN and EXISTS give same results in positives but not in negatives.
	IN follows three-value logic, value NOT IN NULL -> evaluates to UNKNOWN
	EXISTS follows two-value logic, value NOT EXISTS in NULL -> evaluates to TRUE. */

/* 10. Write a query that returns for each order the number of days that passed since the same customer's previous order. */

-- 1. Write a query that computes the date of customer's previous order
SELECT O1.custid, O1.orderid, O1.orderdate, (SELECT TOP(1) O2.orderdate
											FROM Sales.Orders AS O2
											WHERE O1.custid = O2.custid AND /*(O2.orderdate = O1.orderdate AND */ O2.orderid < O1.orderid
																			--OR O2.orderdate < O1.orderdate)
											ORDER BY O2.custid DESC, O2.orderid DESC) AS prevdate
FROM Sales.Orders AS O1
ORDER BY O1.custid, O1.orderid;

-- 2. Compute the difference between the date returned by the first step and the current order date
SELECT O1.custid, O1.orderid, O1.orderdate, 
		DATEDIFF(day,	(SELECT TOP(1) O2.orderdate
						FROM Sales.Orders AS O2
						WHERE O1.custid = O2.custid AND (O2.orderdate = O1.orderdate AND O2.orderid < O1.orderid
														OR O2.orderdate < O1.orderdate)
				ORDER BY O2.custid DESC, O2.orderid DESC), O1.orderdate) AS daydiff
FROM Sales.Orders AS O1
ORDER BY O1.custid, O1.orderid;
