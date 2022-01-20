-- Date & Time

DECLARE @MyValue1 DATETIME,
		@MyValue2 DATETIME;

SET @MyValue1 = CURRENT_TIMESTAMP; -- standard, recommended to use over GETDATE(), both return the same thing
SET @MyValue2 = GETDATE();

SELECT
	@MyValue1 AS CurrentTimeStamp,
	@MyValue2 AS GetDateFun,
	CAST(SYSDATETIME() AS DATE) AS CurrentDate,
	CAST(SYSDATETIME() AS TIME) AS CurrentTime;

SELECT
	CAST('20220101' AS DATE) AS DateValue, -- casts string to date
	CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS DateChar, -- converts datetime to string
	PARSE('02/12/2016' AS DATETIME USING 'en-US') AS UsaDateTime;
-- PARSE fun is more expensive than CONVERT, it is recommended to use later (CAST is standard)

/*	SWITCHOFFSET */
SELECT
	SWITCHOFFSET(@MyValue1, '-05:00') AS OffsetToMinus5, -- adjust the current datetime to offset -05:00
	SWITCHOFFSET(SYSDATETIMEOFFSET(), '+00:00') AS OffsetToMinus5; -- adjust the current datetime to UTC

/*	DATEADD */
SELECT
	CAST(DATEADD(QUARTER, 1, '20220101') AS DATE) AS AddQuarter, -- add specific number of units of a specified date part to the input date and time
	CAST(DATEADD(HOUR, 2, CURRENT_TIMESTAMP) AS TIME) AS AddHour,
	DAY(DATEADD(DAY, 5, CURRENT_TIMESTAMP)) AS AddDay;

/*	Return difference between two datetime values
	DATEDIFF and DATEDIFF_BIG */
SELECT
	DATEDIFF(DAY, '20200101', '20210101') AS DayDifference,
	DATEDIFF_BIG(MILLISECOND, '00010101', CURRENT_TIMESTAMP) AS BigDateDiff,
	DATEADD(DAY, DATEDIFF(DAY, '19000304', CURRENT_TIMESTAMP), '19000304') AS Today,
	DATEADD(MONTH, DATEDIFF(MONTH, '19000304', CURRENT_TIMESTAMP), '19000304') AS MonthFromToday,
	EOMONTH(CURRENT_TIMESTAMP) AS LastDayOfMonth;

/*	DATEPART - returns an int representing a requested part of the day or time */
SELECT
	DATEPART(MM, '20221231') AS MonthInt,
	DATEPART(DD, '20221231') AS DayInt,
	DATEPART(NANOSECOND, CURRENT_TIMESTAMP) AS NanosecondInt,
	YEAR('20120807') AS TheYear,
	MONTH(CURRENT_TIMESTAMP) AS TheMonth,
	DAY(GETDATE()) AS TheDay;

/* DATENAME - returns a character string representing a requested part of the day or time */
SELECT
	DATENAME(MM, '20221231') AS TheMonthName,
	DATENAME(WEEKDAY, '20221231') AS NameOfWeekDay,
	DATENAME(DAYOFYEAR, '20221231') AS TheDayOfYear; -- date as character string

/* ISDATE */
SELECT
	ISDATE('20220809') AS ThisIsDate,
	ISDATE('accepts string') AS ThisIsNotDate;

/*	FROMPARTS */
SELECT
	DATEFROMPARTS(2026, 4, 6) AS TheDate,
	DATETIME2FROMPARTS(1999, 12, 09, 13, 30, 5, 1, 3) AS TheDateTime2,
	TIMEFROMPARTS(13, 30, 5, 1, 7) AS TheTime;

/*	EOMONTH */
SELECT
	EOMONTH(CURRENT_TIMESTAMP) AS LastDayOfMonth,
	EOMONTH(SYSDATETIME(), 3) AS LastDayOfMonth; -- last day of the month three months from now

-- Return orders placed last day of the month
USE TSQLV4;

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = EOMONTH(orderdate);

