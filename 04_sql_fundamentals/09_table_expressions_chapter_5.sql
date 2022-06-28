/*	TABLE EXPRESSIONS

	4 types:	- derived tables
				- common table expressions (CTEs)
				- views
				- inline table-valued functions (inline TVFs) */


/*	DERIVED tables
	- table subqueries
	- defined in FROM clause of outer querty 
	
	The query returns all customers from the USA, and the outer query selects all rows from the derived table. */

USE TSQLV4;

SELECT *
FROM	(SELECT custid, companyname
		FROM Sales.Customers
		WHERE country = N'USA') AS USACust;

-- Write a query that returns a number of distinct customer handled in each year.

SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
FROM (SELECT YEAR(orderdate) AS orderyear, custid
	  FROM Sales.Orders) AS D -- table called D with columns called orderyear and custid
GROUP BY orderyear;

-- or
SELECT YEAR(orderdate) AS orderyear, COUNT(DISTINCT custid) AS numcusts
FROM Sales.Orders
GROUP BY  YEAR(orderdate);

-- or with external aliasing instead of inline as above
SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
FROM (SELECT YEAR(orderdate), custid
	  FROM Sales.Orders) AS D(orderyear, custid)
GROUP BY orderyear;

-- USING ARGUMENTS
DECLARE @empid AS INT = 3;

-- query returns the number of distinct customers per year whose orders where handled by the input employee
SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
FROM (SELECT YEAR(orderdate) AS orderyear, custid
	  FROM Sales.Orders
	  WHERE empid = @empid) AS D 
GROUP BY orderyear;

-- NESTING
-- query returns order years and the number of customers handled in each year only for years in which more than 70 customers were handeled
SELECT *
FROM	(SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
		FROM	(SELECT YEAR(orderdate) AS orderyear, custid
				FROM Sales.Orders) AS D1
		GROUP BY orderyear) AS D2
WHERE numcusts > 70;

-- or

SELECT YEAR(orderdate) AS orderyear, COUNT(DISTINCT custid) AS numcusts
FROM Sales.Orders
GROUP BY  YEAR(orderdate)
HAVING  COUNT(DISTINCT custid) > 70;

-- MULTIPLE REFERENCES

SELECT *, Cur.numcusts - Prv.numcusts AS custgrowth
FROM	(SELECT YEAR(orderdate) AS orderyear, COUNT(DISTINCT custid) AS numcusts
		FROM Sales.Orders
		GROUP BY YEAR(orderdate)) AS Cur
LEFT OUTER JOIN
		(SELECT YEAR(orderdate) AS orderyear, COUNT(DISTINCT custid) AS numcusts
		FROM Sales.Orders
		GROUP BY YEAR(orderdate)) AS Prv
ON Cur.orderyear = Prv.orderyear + 1;

/*	COMMON TABLE EXPRESSIONS 
	
	WITH <CTE_Name>[(>target_column_list>)]
	AS
	(
		<inner_query_defining_CTE>
	)
	<outer_query_against_CTE>; */

WITH USACusts
AS
(
	SELECT custid, companyname
	FROM Sales.Customers
	WHERE country = N'USA'
)
SELECT * FROM USACusts;

-- ASSIGNING column ALIASES in CTEs & Using arguments in CTEs

DECLARE @empid1 AS INT = 3;

WITH C -- (orderyear, custid)
AS
(
	SELECT YEAR(orderdate) AS orderyear, custid
	FROM Sales.Orders
	WHERE empid = @empid1
)
SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
FROM C
GROUP BY orderyear;

-- Defining Multiple CTEs

WITH C1 AS
(
	SELECT YEAR(orderdate) AS orderyear, custid
	FROM Sales.Orders
),
	C2 AS
(
	SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
	FROM C1
	GROUP BY orderyear
)
SELECT orderyear, numcusts
FROM C2
WHERE numcusts > 70;

-- Multiple references in CTEs
-- CTE is named and defined first

WITH YearlyCount AS
(
	SELECT YEAR(orderdate) AS orderyear, COUNT(DISTINCT custid) AS numcusts
	FROM Sales.Orders
	GROUP BY YEAR(orderdate)
)
SELECT Cur.orderyear, Cur.numcusts AS curnumcusts, Prv.numcusts AS prvnumcusts, Cur.numcusts - Prv.numcusts AS growth
FROM YearlyCount AS Cur
LEFT JOIN YearlyCount AS Prv
ON Cur.orderyear = Prv.orderyear + 1;

-- for performance you should persists the inner query in temporary table or a table variable

-- Recursive CTEs
-- CTEs are unique among table expressions in the sencse that they support recursion
-- defined by at least two queries - at least one know as anchor and at least one know as the recursive member

/*
WITH <CTE_Name>[(<target_column_list>)] AS
(
	<anchor_member>
	UNION ALL
	<recursive_member>
)
<outer_query_against_CTE>;
*/

-- anchor query is ivoke only once
-- recrusive is ivoke repetedly until it returns an empty set and has a reference to CTE which is the previous set

-- The code demonstrates how to return information about an employee (Don Funk, employee ID 2) and all the employee's subordinates at all levels (direst or indirect)

WITH EmpsCTE AS
(
	SELECT empid, mgrid, firstname, lastname
	FROM HR.Employees
	WHERE empid = 2

	UNION ALL

	SELECT C.empid, C.mgrid, C.firstname, C.lastname
	FROM EmpsCTE AS P
	INNER JOIN HR.Employees AS C
	ON C.mgrid = P.empid

)
SELECT empid, mgrid, firstname, lastname
FROM EmpsCTE;

SELECT empid, mgrid, firstname, lastname
FROM HR.Employees;




