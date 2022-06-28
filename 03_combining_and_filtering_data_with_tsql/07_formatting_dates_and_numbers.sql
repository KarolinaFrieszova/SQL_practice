USE Northwind;

/*	Formating Dates and Numbers
	GETDATE()
	CASE WHEN
		ISNUMERIC
		ISDATE
		DATEDIFF
	DATEPART
	DATEADD
	DATENAME
*/

/*	FORMAT(value, format[, culture] parameter 
	using the third optional [, culture] parameter:
*/
SELECT		FORMAT(GETDATE(), 'd', 'en-US') 'US English'
		,	FORMAT(GETDATE(), 'd', 'en-gb') 'Great Britain English'
		,	FORMAT(GETDATE(), 'm', 'de-de') 'German'
		,	FORMAT(GETDATE(), 'd', 'zh-cn') 'Simplified Chinese (PRC)';

SELECT		FORMAT(GETDATE(), 'D', 'en-US') 'US English'
		,	FORMAT(GETDATE(), 'D', 'en-gb') 'Great Britain English'
		,	FORMAT(GETDATE(), 'Y', 'de-de') 'German'
		,	FORMAT(GETDATE(), 'D', 'zh-cn') 'Simplified Chinese (PRC)';

SELECT 
	GETDATE(),
	FORMAT(GETDATE(), 'MM/dd/yyyy'),
	FORMAT(GETDATE(), 'MM-d-yy'),
	FORMAT(GETDATE(), 'MMM d yyyy');

SELECT CONVERT(VARCHAR, GETDATE(), 101);