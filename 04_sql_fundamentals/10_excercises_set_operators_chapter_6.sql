/* SET OPERATORS */

USE TSQLV4;
GO

/*	1. Explain the difference between UNION ALL and UNION operators. In what cases are the two equivalent?
	When they are equivalent, which one should you use?
 
	Operators are equivalent when records are UNIQUE in both multisets.
	In this case it is better to use UNION ALL to safe performance on checing for the DISTICT values.
	DISTINCT is implicit in UNION. 

	Differences -	UNION returns distinct rows#
					UNION ALL returns occurance of each row
*/

/*	2. Write a query that generates a virtual auxiliary table of 10 numbers in the range 1 through 10 without
	using looping construct. You do not need to guarantee any order of the rows in the output of your solution. */

SELECT v0.n + v1.n
FROM (
    SELECT 0 n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3
)v0,
(
    SELECT 1 n UNION ALL SELECT 5 UNION ALL SELECT 9
)v1
WHERE v0.n + v1.n <= 10
ORDER BY 1;

/*	3. Write a query that returns customer and employee pairs that had order activity in January 2016 but not in 
	February 2016. */

SELECT custid, empid FROM Sales.Orders WHERE MONTH(orderdate) = 1 AND YEAR(orderdate) = 2016
EXCEPT
SELECT custid, empid FROM Sales.Orders WHERE MONTH(orderdate) = 2 AND YEAR(orderdate) = 2016;

/*	Write a query that returns customers and eomployee pairs that had order activity in both January 2016
	and February 2016. */

SELECT custid, empid FROM Sales.Orders WHERE MONTH(orderdate) = 1 AND YEAR(orderdate) = 2016
INTERSECT
SELECT custid, empid FROM Sales.Orders WHERE MONTH(orderdate) = 2 AND YEAR(orderdate) = 2016;

/*	Write a query that returns customer and employee pairs that had order activity in January 2016
	and February 2016 but not in 2015. */

SELECT custid, empid FROM Sales.Orders WHERE MONTH(orderdate) = 1 AND YEAR(orderdate) = 2016
INTERSECT
SELECT custid, empid FROM Sales.Orders WHERE MONTH(orderdate) = 2 AND YEAR(orderdate) = 2016
EXCEPT
SELECT custid, empid FROM Sales.Orders WHERE YEAR(orderdate) = 2015;