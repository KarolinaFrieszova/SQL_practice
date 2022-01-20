USE TSQLV4;

SELECT 
	empid,
	YEAR(orderdate) AS orderyear,
	COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear