/*	Working with Characters

	String manupulation on a character level
	TRIM
	REPLACE
	CHARINDEX
	REGEX
	PATINDEX
*/

USE Northwind;

SELECT CONCAT_WS(', ', dbo.Proper(LastName), dbo.Proper(FirstName)) AS FormattedName
FROM EmployeesUppercase; -- using user-defined function

SELECT * FROM EmployeesExtraCharacters;

-- using TRIM to remove trailing and leading spaces, as well as any unwanted characters

DECLARE @str AS VARCHAR(100);

SET @str = '**  . **NA&&&NCY.****  _  ';
PRINT @str;

SET @str = TRIM('* . 0 _' FROM @str); -- TRIM removes only from either side, not middle
PRINT @str;

/* REPLACE(expression, pattern, replacement) */
SET @str = REPLACE(@str, '&&&', '');
PRINT @str;

SET @str = CONCAT(SUBSTRING(UPPER(@str), 1, 1), SUBSTRING(LOWER(@str), 2, LEN(@str)));
PRINT @str;


/* CHARINDEX ( ExpressionToFind, ExpressionToSearch [ , StartLocastion ] ) */
DECLARE @str2 AS VARCHAR(100);

SET @str2 = '**  . **NA&&&NCY.****  _  ';
PRINT @str2;

DECLARE @pos AS BIGINT;

SET @pos = CHARINDEX('&', @str2);
PRINT @pos;

/*	PATINDEX ( '%pattern%', expression)
	can use regex, or group of expressions to be searched,
	and also search for characters not be included in the list by adding in a carat at the start of the pattern
*/

SET @pos = PATINDEX('%[^A-z]%', @str2);
PRINT @pos;
