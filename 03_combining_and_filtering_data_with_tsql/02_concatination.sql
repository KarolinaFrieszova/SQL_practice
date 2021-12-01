-- Concatination - linking string values together
USE Northwind;

SELECT
	FirstName + ' ' + LastName AS StringConcatMethrod,
	CONCAT(Firstname, ' ', LastName) AS ConcatMethod,
	CONCAT_WS(' ', FirstName, LastName) AS ConcatWithSeparatorMethod
FROM Employees;

SELECT
	NULL + ' ' + LastName AS [StringConcatMethrod],
	CONCAT(NULL, Firstname, ' ', LastName) AS [ConcatMethod],
	CONCAT_WS(' ', NULL, FirstName, LastName) AS [ConcatWithSeparatorMethod]
FROM Employees;

SET CONCAT_NULL_YIELDS_NULL OFF

SELECT
	NULL + ' ' + LastName AS [StringConcatMethrod],
	CONCAT(NULL, Firstname, ' ', LastName) AS [ConcatMethod],
	CONCAT_WS(' ', NULL, FirstName, LastName) AS [ConcatWithSeparatorMethod]
FROM Employees;

SET CONCAT_NULL_YIELDS_NULL ON -- stay off untill you reset it to on

SELECT 5 + ' ' + 3 AS [StringConcatMethrod];
SELECT CONCAT(5, ' ', 3) AS [ConcatMethod]; -- evaluating the fields and converting to string values