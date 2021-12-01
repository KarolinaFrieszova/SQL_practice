-- CAST, TRY_CAST, CONVERT, TRY_CONVERT
-- see Microsoft: Data type convention (Database Engine)
USE Northwind;

SELECT GETDATE() AS [CurrentDateTime];

SELECT CAST(GETDATE() AS varchar) AS [VarcharDateTime];

SELECT CAST(GETDATE() AS varchar(11)) AS [CurrentDate]; -- add length parameter

-- Convert includes number of pre-formated parameters
SELECT
	CONVERT(varchar(50), GETDATE(), 101), -- third optional parameter
	CONVERT(varchar, GETDATE(), 1),
	CONVERT(varchar, GETDATE(), 2);

SELECT
	CAST(GETDATE() AS money),
	CONVERT(money, GETDATE()); 
/* some data type conversion won't return error 
because they are allowed but they don't return a valid result
*/

SELECT TRY_CAST('hello world' AS int) AS [IncompatibleDataTypeConversionHandling];
SELECT TRY_CONVERT(int, 'hello world')  AS [IncompatibleDataTypeConversionHandling];
/* this methods don't return error if values cannot be converted,
they just return NULL. Handle any unexpected errors/incompatible data types.
*/