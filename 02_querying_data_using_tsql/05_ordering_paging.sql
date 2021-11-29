USE TSQLDemoDB; 
/* 
	ORDER BY
	- any valid expressions evaluated by the SELECT list
	- can use the aliases that were defined in the select list
	- asc, desc
	- NULLs assume the lowest ordering value (NULLS FIRST/LAST)
*/

SELECT TOP(5) WITH TIES OrderID
FROM Orders
ORDER BY OrderDate DESC;
/*	TOP
	WITH TIES - more rows for same OrderID
	Allowed without an ORDER BY
	Can use percentage
	No OFFSET
*/

SELECT OrderID
FROM Orders
ORDER BY OrderDate DESC
OFFSET 0 ROWS
FETCH NEXT 5 ROWS ONLY;

SELECT OrderID, Item
FROM OrderItems
ORDER BY Quantity;

-- DETERMINISM
SELECT *
FROM OrderItems
ORDER BY OrderID, Item;
--

SELECT TOP(3) Item, SUM(Quantity) AS NumOfItemsSold
FROM OrderItems
GROUP BY Item
ORDER BY NumOfItemsSold DESC;

-- Paging using OFFSET and FETCH
SELECT Item, SUM(Quantity) AS NumOfItemsSold
FROM OrderItems
GROUP BY Item
ORDER BY NumOfItemsSold DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

SELECT Item, SUM(Quantity) AS NumOfItemsSold
FROM OrderItems
GROUP BY Item
ORDER BY NumOfItemsSold DESC
OFFSET 3 ROWS FETCH NEXT 3 ROWS ONLY; -- skip first three items and go to the next page





