/*	Querying Metadata
	Querying the SQL Server System Catalog */

/*	Catalog Views */

USE TSQLV4;

SELECT SCHEMA_NAME(schema_id) AS TablesSchemaName, NAME AS TableName -- SCHEMA_NAME converts the schema ID int to its name
FROM sys.tables;

SELECT
	name AS ColumnName,
	TYPE_NAME(system_type_id) AS ColumnType,
	max_length,
	collation_name,
	is_nullable
FROM sys.columns
WHERE object_id = OBJECT_ID(N'Sales.Orders');

SELECT object_id, OBJECT_NAME(object_id) AS SchemaTable
FROM sys.objects;

/*	Information schema views */

-- INFORMATION_SCHEMA.TABLES view lists of the user tables in the current database along with their schema name:

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = N'BASE TABLE';

-- INFORMATION_SCHEMA.COLUMNS view provides most of the available information about columns in Sales.Orders table:

SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, COLLATION_NAME, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = N'Sales' AND TABLE_NAME = N'Orders';

/*	System stored procedures and functions */

-- sys.sp_tables stored procedure returns a list of objects that can be queried in current db
EXEC sys.sp_tables;

-- returns multiple result sets about the Sales.Orders table
EXEC sys.sp_help
	@objname = N'Sales.Orders';

-- info about columns in Sales.Orders table
EXEC sys.sp_columns 
	@table_name = N'Orders',
	@table_owner = N'Sales';

-- returns info about constraints in Orders table
EXEC sys.sp_helpconstraint
	@objname = N'Sales.Orders';

/* one set of functions returns info about properties of entries such as the SQL Server instance, database, object,
column, ... SERVERPROPERTY fun returns the requested property of the current instance.*/

SELECT SERVERPROPERTY('ProductLevel') AS ProductLevelOfInstance;

SELECT DATABASEPROPERTYEX(N'TSQLV4', 'Collation') AS CollectionOfDatabase;

SELECT OBJECTPROPERTY(OBJECT_ID(N'Sales.Orders'), 'TableHasPrimaryKey') AS RequestedPropertyOfSpecifiedObject;
-- OBJECT_ID returne ID of the table

SELECT
	COLUMNPROPERTY(OBJECT_ID(N'Sales.Orders'), N'shipcountry', 'AllowsNull') AS RequestedPropertyOfSpecifiedColumn;

