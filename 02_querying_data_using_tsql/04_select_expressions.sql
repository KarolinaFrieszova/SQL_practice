USE TSQLDemoDB; 
-- SELECT
SELECT OrderID, Item, Quantity, Price
FROM OrderItems;

SELECT OrderID, Item, (Quantity * Price) AS Amount -- executes all at the same time
FROM OrderItems;

/*  Dealing with NULLs:

	ISNULL (X, Y)		<-	IF X IS NULL, returns Y (most commonly unknown or 0 for numeric)
	ISNULL = function, but IS NULL = logical predicate

	COALESCE (X, Y, Z)	<-	Returns the first known expression (left to right)

	NULLIF (X, Y)		<-	Evaluates to NULL if X = Y
*/

SELECT ALL Country
FROM Customers;

SELECT DISTINCT Country
FROM Customers;

SELECT Country
FROM Customers
GROUP BY Country;

SELECT DISTINCT ISNULL(Country, 'N/A') AS Country, Customer
FROM Customers;