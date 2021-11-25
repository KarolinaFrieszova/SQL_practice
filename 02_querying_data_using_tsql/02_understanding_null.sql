-- NULL
/*	
	NULL is not a value (inapplicable or missing)
	When comparing NULL to a value:
	X = NULL -> is always unknown
	X <> NULL -> is always unknow
	but
	X IS NULL -> evaluated FALSE if not
	X IS NOT NULL -> evaluated TRUE if not
*/

SELECT *
FROM Customers
WHERE Country = NULL; -- comparison with NULL is always unknown

SELECT *
FROM Customers
WHERE Country IS NULL; -- evaluates to TRUE or FALSE

SELECT *
FROM Customers
WHERE Country IS NOT NULL; -- evaluates to TRUE or FALSE

SELECT *
FROM Customers
WHERE Country BETWEEN 'A' AND 'Z'; -- NULL doesn't show up

SELECT *
FROM Items
WHERE Item IN ('Amplifier', 'Turntable', NULL);
-- TRUE when X = A OR X = B OR X = C 
-- UNKNOWN OR TRUE -> TRUE

SELECT *
FROM Items
WHERE Item NOT IN ('Amplifier', 'Turntable', NULL);
-- evalues to unknown
-- UNKNOW OR FALSE -> UNKNOWN