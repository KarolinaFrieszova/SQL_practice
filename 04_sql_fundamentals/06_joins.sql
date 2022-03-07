

-- CROSS JOIN
SELECT C.custid, E.empid
FROM Sales.Customers AS C
	CROSS JOIN HR.Employees AS E;

-- SELF CROSS JOIN
SELECT
	E1.empid, E1.firstname, E1.lastname,
	E2.empid, E2.firstname, E2.lastname
FROM HR.Employees AS E1
	CROSS JOIN HR.Employees AS E2; -- in SELF JOIN aliases are not optional!

/*	 Producing tables of numbers */

USE TSQLV4;

DROP TABLE IF EXISTS dbo.Digits;

CREATE TABLE dbo.Digits
(
	digit INT NOT NULL PRIMARY KEY
);

INSERT INTO dbo.Digits(digit)
	VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

SELECT digit
FROM dbo.Digits;

SELECT D3.digit * 100 + D2.digit * 10 + D1.digit + 1 AS n
FROM			dbo.Digits AS D1
	CROSS JOIN	dbo.Digits AS D2
	CROSS JOIN	dbo.Digits AS D3
ORDER BY n;

SELECT
	D3.digit AS D3, 
	D3.digit*100 AS D3Times100, 
	D2.digit AS D2,
	D2.digit*10 AS D2Times10, 
	D1.digit AS D1,
	D1.digit + 1 AS D1Plus1,
	D2.digit*10 + D1.digit + 1 AS D2Times10Plus1, 
	D3.digit * 100 + D2.digit * 10 + D1.digit + 1 AS n
FROM			dbo.Digits AS D1
	CROSS JOIN	dbo.Digits AS D2
	CROSS JOIN	dbo.Digits AS D3
ORDER BY n;

-- INNDER JOIN

SELECT E.empid, E.firstname, E.lastname, O.orderid
FROM HR.Employees AS E
	INNER JOIN Sales.Orders AS O
	ON E.empid = O.empid;
-- matching each employee with all order rows that have the same employee ID

/*	COMPOSITE JOINS */

-- usualy used when pripary key-forein key relationship is based on more than one attribute

-- suppose you need to audit updates to column values against the OrderDetails table in the TSQLV4 database
-- you create a custom auditing table called OrderDetailsAudit


USE TSQLV4;

DROP TABLE IF EXISTS Sales.OrderDetailsAudit;

CREATE TABLE Sales.OrderDetailsAudit
(
	lsn			INT NOT NULL IDENTITY,
	orderid		INT NOT NULL,
	productid	INT NOT NULL,
	dt			DATETIME NOT NULL,
	loginname	sysname NOT NULL,
	columnname	sysname NOT NULL,
	oldval		SQL_VARIANT,
	newval		SQL_VARIANT,
	CONSTRAINT	PK_OrderDetailsAudit PRIMARY KEY(lsn),
	CONSTRAINT	FK_OrderDetailsAudit FOREIGN KEY(orderid, productid) 
		REFERENCES Sales.OrderDetails(orderid, productid)

);

SELECT *
FROM Sales.OrderDetailsAudit;

SELECT
	OD.orderid, OD.productid, OD.qty,
	ODA.dt, ODA.loginname, ODA.oldval, ODA.newval
FROM Sales.OrderDetails AS OD
	INNER JOIN Sales.OrderDetailsAudit AS ODA
	ON OD.orderid = ODA.orderid 
	AND OD.productid = ODA.productid
WHERE ODA.columnname = N'qty';


/*	Non-equi joins */

-- when join involves any operator besides equality

-- following query joins two instances of the Employees table to produce unique pairs of employees:
SELECT
	E1.empid, E1.firstname, E1.lastname,
	E2.empid, E2.firstname, E2.lastname
FROM HR.Employees AS E1
	INNER JOIN HR.Employees AS E2
	ON E1.empid < E2.empid
ORDER BY E1.empid;

/*	Multi-join queries */

-- operates only on two tables, but a single query can have multiple joins

SELECT
	C.custid, C.companyname, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O
	ON C.custid = O.custid
	INNER JOIN Sales.OrderDetails AS OD
	ON O.orderid = OD.orderid;

/*	Outer joins */

SELECT C.custid, C.companyname, O.orderid, O.shipcity
FROM Sales.Customers AS C
	INNER JOIN Sales.Orders AS O -- inner join
	ON C.custid = O.custid;

SELECT C.custid, C.companyname, O.orderid, O.shipcity
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
	ON C.custid = O.custid;

-- outer rows are identified by NULLs

/*	Using Outer Join to identify and include missing values 
	query orders form Orders table ensuring that you get at least one row in the output 
	for each date in the range Jan 1, 2014 through Dec 31,2016.
	You want the output to include dates with no orders, with NULLs as a placeholders 

	1. write a query that returns a sequence of all dates in the requested period
	
*/

SELECT DATEADD(day, n-1, CAST('20140101' AS DATE)) AS orderdate
FROM dbo.Nums -- auxiliary table
WHERE n <= DATEDIFF(day, '20140101', '20161231') + 1 -- number of days as for this ammount of days we need the sequence
ORDER BY orderdate;

SELECT
	DATEADD(day, Nums.n-1, CAST('20140101' AS DATE)) AS orderdate,
	O.orderid, O.custid, O.empid
FROM dbo.Nums
	LEFT JOIN Sales.Orders AS O
	ON DATEADD(day, Nums.n-1, CAST('20140101' AS DATE)) = O.orderdate
WHERE n <= DATEDIFF(day, '20140101', '20161231') + 1
ORDER BY orderdate;


/*	Filtering attributes from the nonpreserved side of an outer join 

	WHERE cause filters UNKNOWNS out. 
	So if you have WHERE cause refering to an attribute from the nonpreserved side, such a predicate 
	in WHERE cause causes all outer rows to be filtered out, nullilfying the outher join. 
	Effectively, the join become and inner join. */

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
	ON C.custid = O.custid
WHERE O.orderdate >= '20160101';

-- use of outer join in this case is futile

/*	Using outer joins in a multi-join query */

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O -- returning also customers who did not place an order
	ON C.custid = O.custid
	INNER JOIN Sales.OrderDetails AS OD -- here these rows are discarded
	ON O.orderid = OD.orderid;

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O 
	ON C.custid = O.custid
	LEFT OUTER JOIN Sales.OrderDetails AS OD -- returns also customers with no order
	ON O.orderid = OD.orderid; -- this solution preserves a;; rows from Orders. What if there are rows in Orders that don't have OrderDetails, and you want these rows to be discarted?

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Orders AS O
	INNER JOIN Sales.OrderDetails AS OD -- only orders with order details
	ON O.orderid = OD.orderid
	RIGHT OUTER JOIN Sales.Customers AS C -- this way the outer rows are not filtered out
	ON O.custid = C.custid;

SELECT C.custid, O.orderid, OD.productid, OD.qty
FROM Sales.Customers AS C
	LEFT OUTER JOIN
		(Sales.Orders AS O
			INNER JOIN Sales.OrderDetails AS OD
			ON O.orderid = OD.orderid) -- create an independent unit with parentheses
	ON C.custid = O.custid; -- same as above

/*	Using the COUNT aggregate with outer joins */

SELECT C.custid, COUNT(*) AS numorders -- takes into consideration outer rows (customer 22 and 57 didn;t place an order and each have show up with count of 1
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
	ON C.custid = O.custid
GROUP BY C.custid;

SELECT C.custid, COUNT(O.orderid) AS numorders -- COUNT(column) provide a column from nonpreserved side of the join, such as primary key
FROM Sales.Customers AS C
	LEFT OUTER JOIN Sales.Orders AS O
	ON C.custid = O.custid
GROUP BY C.custid;

/*	Conclusion

	- COUNT(<column>) from nonpreserved side
	- in WHERE caluse use column from preserved side of the join

