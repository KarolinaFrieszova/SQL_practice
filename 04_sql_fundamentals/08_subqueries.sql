/* SUBQUERIES */

/* SEFL-CONTAINED SUBQUERIES */

/* Self-contained scalar subquery examples 
	Return information about the order that has the maximum order ID in the table. */

USE TSQLV4;

DECLARE @maxid AS INT = (SELECT MAX(orderid)
						 FROM Sales.Orders);

SELECT *
FROM Sales.Orders
WHERE orderid = @maxid;

-- OR

SELECT *
FROM Sales.Orders
WHERE orderid = (SELECT MAX(O.orderid)
				 FROM Sales.Orders AS O);

/*	Self-contained multivalued subquery examples
	returns multiple values as a single column
	predicates: IN, SOME, ANY, ALL

	Return orders placed by employees whose last name starts with the letter D. */
SELECT orderid
FROM Sales.Orders
WHERE empid IN (SELECT E.empid
			   FROM HR.Employees AS E
			   WHERE E.lastname LIKE N'D%');

-- or using join

SELECT O.orderid
FROM HR.Employees AS E
	INNER JOIN Sales.Orders AS O
	ON E.empid = O.empid
WHERE E.lastname LIKE N'D%';

--	Write a query that returns orders placed by customers from the US

SELECT orderid
FROM Sales.Orders
WHERE custid IN (SELECT custid
				FROM Sales.Customers
				WHERE country = 'USA');

-- Return customers who did not place any order
SELECT custid, companyname, contactname
FROM Sales.Customers
WHERE custid NOT IN (SELECT custid
				FROM Sales.Orders);

-- create a table called dbo.Orders in the TSQLV4 database, and populate it with even-numbered order IDs from Sales.Orders table
DROP TABLE IF EXISTS dbo.Orders;
CREATE TABLE dbo.Orders (
	orderid INT NOT NULL
	CONSTRAINT PK_Orders PRIMARY KEY);

INSERT INTO dbo.Orders (orderid)
	SELECT orderid
	FROM Sales.Orders
	WHERE orderid % 2 = 0;

-- return all individual order IDs that are missing between the minimum and maximum onse in the table

SELECT n
FROM dbo.Nums
WHERE	n BETWEEN (SELECT MIN(orderid) FROM Sales.Orders) AND (SELECT MAX(orderid) FROM Sales.Orders)
	AND n NOT IN (SELECT orderid FROM dbo.Orders);


DROP TABLE IF EXISTS dbo.Orders; -- drop created table with even order IDs

/*	CORRELATED SUBQUERIES
	refer to attributes from the table that appear in the outer query. This means that th subquery is dependent
	on the outer query and cannot be invoked independantly. */

-- Return orders with the maximum order ID for each customer.

SELECT *
FROM Sales.Orders AS O1
WHERE orderid = (SELECT MAX(O2.orderid)
				 FROM Sales.Orders AS O2
				 WHERE O2.custid = O1.custid);

/*	suppose you need to query Sales.OrderValues view and return for each order the percentage of the current order value 
	out of the customer total. */ 

SELECT orderid, CAST(val * 100 / (SELECT SUM(OV2.val)
								  FROM Sales.OrderValues AS OV2
								  WHERE OV2.custid = OV1.custid ) AS NUMERIC(5,2)) AS pctoftotal -- out of customer total
FROM Sales.OrderValues AS OV1
ORDER BY custid, orderid;

SELECT SUM(val) AS customertotal
FROM Sales.OrderValues
WHERE custid = 85; -- OV1 means 85

/*	The EXISTS predicate 

	EXISTS predicate lends itself to good optimization. The database engine knows that it's enough to determine whether the subquery
	returns at least one row or none, and it doesn't need to process all qualfying rows. The same applies to IN predicate.
	Using * with EXISTS is not considered to be a bad practice. */

-- return customers from Spain who placed orders

SELECT custid, companyname
FROM Sales.Customers
WHERE custid IN (SELECT custid
				 FROM Sales.Orders) AND Sales.Customers.country = N'Spain';

SELECT DISTINCT(C.custid), C.companyname
FROM Sales.Customers AS C
RIGHT JOIN Sales.Orders AS O
ON C.custid = O.custid
WHERE C.country = N'Spain';

SELECT custid, companyname
FROM Sales.Customers AS C
WHERE country = N'Spain'
AND EXISTS (SELECT * 
			FROM Sales.Orders AS O
			WHERE O.custid = C.custid);

-- return customers from Spain who didn't place order

SELECT custid, companyname
FROM Sales.Customers AS C
WHERE country = N'Spain'
AND NOT EXISTS (SELECT * 
			FROM Sales.Orders AS O
			WHERE O.custid = C.custid);

/*	Query the Orders table and return, for each order, information about the current order and also the previous order ID */

SELECT orderid, orderdate, empid, custid, 
	(SELECT MAX(O2.orderid)
	 FROM Sales.Orders AS O2
	 WHERE O2.orderid < O1.orderid) AS previousorder
FROM Sales.Orders AS O1;

/*	Return for each order the next order.
	The minimum value that is greater than the current value. */

SELECT orderid, orderdate, empid, custid, 
	(SELECT MIN(O2.orderid)
	 FROM Sales.Orders AS O2
	 WHERE O2.orderid > O1.orderid) AS previousorder
FROM Sales.Orders AS O1;

/* Using running aggregates */

SELECT *
FROM Sales.OrderTotalsByYear; -- the view has the total order quantity by year

-- calculate running total qty up to and including that year's

SELECT *, (SELECT SUM(OT2.qty)
		   FROM Sales.OrderTotalsByYear AS OT2
		   WHERE OT2.orderyear <= OT1.orderyear) AS runqty -- running total is the sum of the first year plus the second year, and so on
FROM Sales.OrderTotalsByYear AS OT1
ORDER BY OT1.orderyear;

/*	Dealing with misbehaving subqueries
	NULL trouble 
	remember T-SQL uses three-valued logic because of its NULLs */

-- return customers who did not place orders

SELECT *
FROM Sales.Customers
WHERE custid NOT IN (SELECT custid
					 FROM Sales.Orders);

-- run:
INSERT INTO [Sales].[Orders]
           ([custid]
           ,[empid]
           ,[orderdate]
           ,[requireddate]
           ,[shippeddate]
           ,[shipperid]
           ,[freight]
           ,[shipname]
           ,[shipaddress]
           ,[shipcity]
           ,[shipregion]
           ,[shippostalcode]
           ,[shipcountry])
     VALUES
           (NULL
           ,1
           ,'20160212'
           ,'20160212'
           ,'20160212'
           ,1
           ,123.00
           ,N'abc'
           ,N'abc'
           ,N'abc'
           ,N'abc'
           ,N'abc'
           ,N'abc');
GO

SELECT *
FROM Sales.Customers
WHERE custid NOT IN (SELECT custid
					 FROM Sales.Orders
					 WHERE custid IS NOT NULL); -- explicitly exclude NULLs

/*	22 NOT IN (1,2,.., NULL) -> 22=1, 22=2,22=NULL -> FALSE, FALSE, UNKNOWN -> 
	which translate to NOT UNKNOWN, -> which eveluates to UNKNOWN */

SELECT *
FROM Sales.Customers AS C
WHERE NOT EXISTS (SELECT * -- implicitly exclude NULLs
				  FROM Sales.Orders AS O
				  WHERE C.custid = O.custid);

/* unlike IN EXISTS uses two-valued predicate logic. EXISTS always return TRUE or FALSE and never UNKNOWN!!!
	When subquery stumbles into a NULL in O.custid, the expression evaluates to UNKNOWN and the row is filtered out. 
	As far as the EXISTS predicate is concerned, the NULLcases are eleminiated nalurally, as though they weren't there. 
	Therefore, it's safer to use NOT EXISTS than NOT IN. */

DELETE FROM Sales.Orders WHERE custid IS NULL;

/*	Substitution errors in subquery column names */

DROP TABLE IF EXISTS Sales.MyShippers;

CREATE TABLE Sales.MyShippers 
(	shipper_id INT NOT NULL,
	companyname NVARCHAR(40) NOT NULL,
	phone NVARCHAR(24) NOT NULL,
	CONSTRAINT PK_MyShippers PRIMARY KEY(shipper_id)
);

INSERT INTO Sales.MyShippers (shipper_id, companyname, phone)
	VALUES	(1, N'Shipper GVSUA', N'(503) 555 -0137'),
			(2, N'Shipper ETYNR', N'(503) 555 -8902'),
			(3, N'Shipper ZHISN', N'(503) 555 -6733');

SELECT shipper_id, companyname
FROM Sales.MyShippers
WHERE shipper_id IN (SELECT shipper_id -- it doesn't find the column shipper_id in S.Orders tbl so it looks into the outer table
					 FROM Sales.Orders
					 WHERE custid = 43);

SELECT shipper_id, companyname
FROM Sales.MyShippers
WHERE shipper_id IN (SELECT shipperid
					 FROM Sales.Orders
					 WHERE custid = 43);

/*	Best practices: 
	- use consistent attribute names across tables
	- prefix column names in subqueries with the source table name or alias */

SELECT shipper_id, companyname
FROM Sales.MyShippers AS MS
WHERE shipper_id IN (SELECT O.shipper_id
					 FROM Sales.Orders AS O
					 WHERE custid = 43);

DROP TABLE IF EXISTS Sales.MyShippers;