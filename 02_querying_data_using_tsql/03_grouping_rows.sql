-- Aggregate functions
USE TSQLDemoDB;

SELECT Country, COUNT(*) AS Count -- group by attribute needs to be listed in SELECT clause
FROM Customers
WHERE Country IS NOT NULL
GROUP BY Country;

INSERT INTO Customers (Customer, Country)
VALUES ('Jane', NULL);

SELECT Country, COUNT(*) AS Count 
FROM Customers
GROUP BY Country;
-- one NULL is never equal to another NULL in mathematical sense
-- But the are treated as being the same. Both are NULLs so they are grouped together.

/*	HAVING 
	- operates on a grouped set and has no longer access to the original set
*/

SELECT Country, COUNT(*) AS Count 
FROM Customers
GROUP BY Country
HAVING COUNT(*) > 1;

SELECT Country, COUNT(*) AS Count 
FROM Customers
GROUP BY Country
HAVING Country IS NOT NULL;