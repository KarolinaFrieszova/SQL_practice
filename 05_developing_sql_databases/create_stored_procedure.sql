/*	STORED PROCEDURE 
	- three versions: different coding and execution limitations

	CREATE PROCEDURE SchemaName.ObjectName

	[WITH options]
	[FOR REPLICATION]
		@Parameter1 datatype,
		@Parameter2 datatype = 'Optional Default',
		@Parameter3 datatype = NULL
	AS
		1 or more Transact_SQL statements; */

/*	DESIGNE STORED PROCEDURES COMPONENTS */

USE contacts;

IF EXISTS (SELECT name FROM sys.schemas WHERE name = N'Examples')
   BEGIN
      DROP SCHEMA [Examples]
END
GO
CREATE SCHEMA [Examples] 
GO

CREATE TABLE Examples.SimpleTable
(
	SimpleTableId INT NOT NULL IDENTITY(1,1)
		CONSTRAINT PHSimpleTable PRIMARY KEY,
		Value1 VARCHAR(20) NULL,
		Value2 VARCHAR(20) NULL
);
GO

-- Three sample stored procedures to insert, update, and delete data

CREATE PROCEDURE Examples.SimpleTable_Insert
	@SimpleTableId INT,
	@Value1 VARCHAR(20),
	@Value2 VARCHAR(20)
AS
	INSERT INTO Examples.SimpleTable(Value1, Value2)
	VALUES (@Value1, @Value2);
GO

CREATE PROCEDURE Examples.SimpleTable_Update
	@SimpleTableId INT,
	@Value1 VARCHAR(20),
	@Value2 VARCHAR(20)
AS
	UPDATE Examples.SimpleTable
	SET Value1 = @Value1, 
		Value2 = @Value2
	WHERE SimpleTableId = @SimpleTableId;
GO

CREATE PROCEDURE Examples.SimpleTable_Delete
	@SimpleTableId INT,
	@Value VARCHAR(20)
AS
	DELETE Examples.SimpleTable
	WHERE SimpleTableId = @SimpleTableId
GO

-- return all data seom Examples.SimpleTable ordered by Value1
CREATE PROCEDURE Examples.SimpleTable_Select
AS
	SELECT SimpleTableId, Value1, Value2
	FROM Examples.SimpleTable
	ORDER BY Value1;

GO

-- return multiple sets (it is generally desirable to return a single result set)

CREATE PROCEDURE Examples.SimpleTable_SelectValue1StartWithQorZ
AS
	SELECT SimpleTableId, Value1, Value2
	FROM Examples.SimpleTable
	WHERE Value1 LIKE 'Q%'
	ORDER BY Value1;

	SELECT SimpleTableId, Value1, Value2
	FROM Examples.SimpleTable
	WHERE Value1 LIKE 'Z%'
	ORDER BY Value1 DESC;
GO

-- returns 1 or 0
CREATE PROCEDURE Examples.SimpleTable_SelectValue1StartWithQorZ2
AS
	IF DATENAME(WEEKDAY, GETDATE()) NOT IN ('Saturday', 'Sunday')
		SELECT SimpleTableId, Value1, Value2
	FROM Examples.SimpleTable
	WHERE Value1 LIKE '[QZ]%';
GO

EXECUTE Examples.SimpleTable_Insert 1, 'Test1', 'Test2'
GO
EXEC Examples.SimpleTable_Select