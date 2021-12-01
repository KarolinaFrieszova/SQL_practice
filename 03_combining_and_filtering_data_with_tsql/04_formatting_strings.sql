-- Formatting Strings

-- 1. Remove trailing and leading spaces using TRIM
-- TRIM, LTRIM, RTRIM, TRIM(characters FROM expression)
USE Northwind;

SELECT
	FirstName,
	LastName,
	TRIM(FirstName),
	TRIM(LastName)
FROM EmployeesUppercase;

-- 2. Isolate the char for upper and lower casing using SUBSTRING(expression, start, length)

SELECT
	FirstName,
	LastName,
	SUBSTRING(TRIM(FirstName),1,1) AS FirstCharFirstName,
	SUBSTRING(TRIM(LastName),1,1) AS FirstCharLastName
FROM EmployeesUppercase;

SELECT
	FirstName,
	LastName,
	SUBSTRING(TRIM(FirstName),2,LEN(FirstName)) AS FirstNameButFirstChar,
	SUBSTRING(TRIM(LastName),2,LEN(LastName)) AS LastNameButFirstChar
FROM EmployeesUppercase;

-- 3. Apply UPPER and LOWER
SELECT
	UPPER(SUBSTRING(TRIM(FirstName),1,1)) AS FirstCharFirstName,
	UPPER(SUBSTRING(TRIM(LastName),1,1)) AS FirstCharLastName,
	LOWER(SUBSTRING(TRIM(FirstName),2,LEN(FirstName))) AS FirstNameButFirstChar,
	LOWER(SUBSTRING(TRIM(LastName),2,LEN(LastName))) AS LastNameButFirstChar
FROM EmployeesUppercase;


-- 4. Apply concatination to return Lastname, Firstname using CONCAT

SELECT
	CONCAT(
	UPPER(SUBSTRING(TRIM(FirstName),1,1)),
	LOWER(SUBSTRING(TRIM(FirstName),2,LEN(FirstName))),
	', ',
	UPPER(SUBSTRING(TRIM(LastName),1,1)),
	LOWER(SUBSTRING(TRIM(LastName),2,LEN(LastName)))
	) AS FormattedName
FROM EmployeesUppercase; -- remove aliases

---

SELECT SUBSTRING('hello', 1, 1) AS H;
SELECT SUBSTRING(' hello', 1, 1) AS [Space];
SELECT SUBSTRING(TRIM(' hello'), 2, 5) AS Ello;
SELECT SUBSTRING(TRIM(' hello'), 2, 5000) AS Ello;
SELECT SUBSTRING(TRIM(' hello'), 2, LEN(' hello')) AS Ello;

SELECT UPPER('day');
SELECT LOWER('WEEK');
