USE Northwind;

DECLARE @str AS VARCHAR(MAX);
DECLARE @startPosition AS INT;
DECLARE @pos AS INT;

SET @str = '- _ () 1234****()o%%%%^''con?|{}|nor lisa-a____N\ne janet li._';
SET @str = TRIM('-()_ .' FROM LOWER(@str));
-- PRINT @str;

SET @pos = 1;

-- remove all characters not alpha
WHILE PATINDEX('%[^A-z'''' -]%', @str) > 0
	BEGIN
			--PRINT @str
			--PRINT @pos
			SET @pos = PATINDEX('%[^A-z'''' -]%', @str)
			SET @str = CONCAT(SUBSTRING(@str, 1, @pos - 1),
					   SUBSTRING(@str, @pos + 1, LEN(@str)))
			--PRINT @pos
	END
PRINT @str;

-----
-----
DECLARE @str2 AS VARCHAR(256);
SET @str2 = 'Hello1 World'; -- 1 is in the position 6

SET @str2 = CONCAT(SUBSTRING(@str2, 1, 6 - 1),
			       SUBSTRING(@str2, 6 + 1, LEN(@str2)))
PRINT @str2

-----
-----

DECLARE @string AS VARCHAR(MAX);
DECLARE @position AS INT;

SET @string = 't-1sql quer710ies';
SET @string = TRIM('-()_ .' FROM LOWER(@string));
SET @position = 1;

-- remove all characters not alpha
WHILE PATINDEX('%[^A-z'''' -]%', @string) > 0
	BEGIN
			SET @position = PATINDEX('%[^A-z'''' -]%', @string)
			SET @string = CONCAT(SUBSTRING(@string, 1, @position - 1),
					   SUBSTRING(@string, @position + 1, LEN(@string)))
	END
PRINT @string;

/* Capitalise the first letter of the string */
SET @str = CONCAT(SUBSTRING(UPPER(@str), 1, 1), SUBSTRING(LOWER(@str), 2, LEN(@str)));
PRINT @str;

/*
	Capitalise the first letter after:
	- a single quote (O'Conner),
	- any space in the name,
	- any hyphen in a name
*/

SET @startPosition = 1;
SET @pos = 0;

WHILE
	CHARINDEX('''', @str, @startPosition) > 0
	OR CHARINDEX('-', @str, @startPosition) > 0
	OR CHARINDEX(' ', @str, @startPosition) > 0
	BEGIN
		IF CHARINDEX('''', SUBSTRING(@str, @startPosition, 1)) > 0
			BEGIN
				SET @pos = CHARINDEX('''', @str, @startPosition)
			END
		ELSE IF CHARINDEX('-', SUBSTRING(@str, @startPosition, 1)) > 0
			BEGIN
				SET @pos = CHARINDEX('-', @str, @startPosition)
			END
		ELSE IF CHARINDEX(' ', SUBSTRING(@str, @startPosition, 1)) > 0
			BEGIN
				SET @pos = CHARINDEX(' ', @str, @startPosition)
			END

		SET @str = CONCAT(SUBSTRING(@str, 1, @pos),
			SUBSTRING(UPPER(@str), @pos + 1, 1),
			SUBSTRING(@str, @pos + 2, LEN(@str)))

		SET @startPosition = @startPosition + 1
	END
PRINT @str;

