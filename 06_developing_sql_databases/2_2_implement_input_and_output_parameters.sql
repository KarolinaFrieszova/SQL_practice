USE contacts;
GO
/*	IMPLEMENT INPUT and OUTPUT PARAMETERS */

CREATE TABLE Examples.Parameter
(
	ParameterId INT NOT NULL IDENTITY(1,1) CONSTRAINT PKParameter PRIMARY KEY,
	Value1 VARCHAR(20) NOT NULL,
	Value2 VARCHAR(20) NOT NULL
)
GO

CREATE PROCEDURE Examples.Parameter_Insert
	@Value1 VARCHAR(20) = 'No entry given',
	@Value2 VARCHAR(20) = 'No entry given'
AS
	SET NOCOUNT ON;
	INSERT INTO Examples.Parameter(Value1, Value2)
	VALUES(@Value1,@Value2);
GO

EXECUTE Examples.Parameter_Insert;
EXECUTE Examples.Parameter_Insert 'Some Entry';
EXECUTE Examples.Parameter_Insert 'More Entry', 'More Entry';
EXECUTE Examples.Parameter_Insert @Value2 = 'Other Entry';
SELECT * FROM Examples.Parameter;
GO

ALTER PROCEDURE Examples.Parameter_Insert
	@Value1 VARCHAR(20) = 'No entry given',
	@Value2 VARCHAR(20) = 'No entry given',
	@NewParameterId INT = NULL OUTPUT
AS
	SET NOCOUNT ON;
	SET @Value1 = UPPER(@Value1);
	SET @Value2 = LOWER(@Value2);

	INSERT INTO Examples.Parameter(Value1, Value2)
	VALUES(@Value1,@Value2);

	SET @NewParameterId = SCOPE_IDENTITY();
GO

DECLARE @Value1 VARCHAR(20) = 'Test',
		@Value2 VARCHAR(20) = 'Test',
		@NewParameterId INT = -200;

EXECUTE Examples.Parameter_Insert	@Value1 = @Value1,
									@Value2 = @Value2,
									@NewParameterId = @NewParameterId OUTPUT;

GO
SELECT @Value1 AS Value1, @Value2 AS Value2, @NewParameterId AS NewParameterId;
GO
SELECT *
FROM Examples.Parameter
WHERE ParameterId = @NewParameterId;