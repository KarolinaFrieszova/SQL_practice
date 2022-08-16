/*
Course: SQL Server Performance: Indexing Course

Description: This script shows the fundamentals of SQL Server 
usage of page, B+Tree, Clustered and Non_clustered Index
************************************************************/

USE tempdb;
GO

-- Fundamentals with B+ Trees with SQL Server
CREATE TABLE Indexing 
(
	ID INT IDENTITY(1,1),
	Name CHAR(4000),
	Company CHAR(4000),
	Pay INT
); /*	this means that I have a row, which is close to 8000 bytes. 
		This makes sure that each row gets a single page and 
		page cannot store more then one row. */

-- Definition
SELECT
	OBJECT_NAME(object_id) TableName,
	ISNULL(name, OBJECT_NAME(object_id)) IndexName,
	index_id, -- 0 means HEAP
	type_desc
FROM sys.indexes
WHERE OBJECT_NAME(object_id) = 'Indexing';
GO

SET NOCOUNT ON -- is used to suppress the end rows affected message that comes as part of SSMS output
GO

INSERT INTO Indexing VALUES
('Vinod', 'ExtremeExperts', 10000);
GO

-- Status Check
SELECT 
      OBJECT_NAME(object_id) TableName,
      index_type_desc AS INDEX_TYPE,
	  alloc_unit_type_desc AS DATA_TYPE, -- IN_ROW_DATA means the row's data is been able to fit indide a page, hence it is inside a row
      index_id AS INDEX_ID,
      index_depth AS DEPTH,
      index_level AS IND_Level,
      record_count AS RecordCount,
      page_count AS PageCount,
	  fragment_count AS Fragmentation
FROM sys.dm_db_index_physical_stats (DB_ID() , OBJECT_ID('Indexing'), NULL, NULL, 'DETAILED');
GO

INSERT INTO Indexing VALUES
('Steve', 'Central', 15000)
,('Pinal', 'SQLAuthority', 13000)
GO

-- Satus Check
SELECT 
      OBJECT_NAME(object_id) TableName,
      index_type_desc AS INDEX_TYPE,
	  alloc_unit_type_desc AS DATA_TYPE,
      index_id AS INDEX_ID,
      index_depth AS DEPTH,
      index_level AS IND_Level,
      record_count AS RecordCount,
      page_count AS PageCount,
	  fragment_count AS Fragmentation
FROM sys.dm_db_index_physical_stats (DB_ID () , OBJECT_ID ('Indexing'), NULL, NULL, 'DETAILED');
GO

INSERT INTO Indexing VALUES
('Dummy', 'JunkCompany', 1000)
GO 100

-- Satus Check
SELECT 
      OBJECT_NAME(object_id) TableName,
      index_type_desc AS INDEX_TYPE,
	  alloc_unit_type_desc AS DATA_TYPE,
      index_id AS INDEX_ID,
      index_depth AS DEPTH,
      index_level AS IND_Level,
      record_count AS RecordCount,
      page_count AS PageCount,
	  fragment_count AS Fragmentation
FROM sys.dm_db_index_physical_stats (DB_ID () , OBJECT_ID ('Indexing'), NULL, NULL, 'DETAILED');
GO

-- Clustered Index
CREATE CLUSTERED INDEX CI_IndexingID ON Indexing (ID)
GO -- move it from the HEAP to CLASTURED INDEX

-- Satus Check
SELECT 
      OBJECT_NAME(object_id) TableName,
      index_type_desc AS INDEX_TYPE,
	  alloc_unit_type_desc AS DATA_TYPE,
      index_id AS INDEX_ID, -- clustered index had index_id of 1
      index_depth AS DEPTH,
      index_level AS IND_Level,
      record_count AS RecordCount,
      page_count AS PageCount,
	  fragment_count AS Fragmentation
FROM sys.dm_db_index_physical_stats (DB_ID () , OBJECT_ID ('Indexing'), NULL, NULL, 'DETAILED');
GO

INSERT INTO Indexing VALUES
('MoreJunk', 'MoreJunkCompany', 100)
GO 700

-- Status Check
SELECT 
      OBJECT_NAME(object_id) TableName,
      index_type_desc AS INDEX_TYPE,
	  alloc_unit_type_desc AS DATA_TYPE,
      index_id AS INDEX_ID,
      index_depth AS DEPTH,
      index_level AS IND_Level,
      record_count AS RecordCount,
      page_count AS PageCount,
	  fragment_count AS Fragmentation
FROM sys.dm_db_index_physical_stats (DB_ID () , OBJECT_ID ('Indexing'), NULL, NULL, 'DETAILED');
GO

/* page count is 103 and record count is 103
it also has the intermediate node with record count 803 and page count 2
and root node with records count 2 and page count 1 */

-- Statistics speaks a lot !!!
DBCC SHOW_STATISTICS ('Indexing', CI_IndexingID)
GO

-- Non-Clustered Index
CREATE NONCLUSTERED INDEX NCI_Pay on Indexing (Pay)
GO

-- Status Check
SELECT 
      OBJECT_NAME(object_id) TableName,
      index_type_desc AS INDEX_TYPE,
	  alloc_unit_type_desc AS DATA_TYPE,
      index_id AS INDEX_ID,
      index_depth AS DEPTH,
      index_level AS IND_Level,
      record_count AS RecordCount,
      page_count AS PageCount,
	  fragment_count AS Fragmentation
FROM sys.dm_db_index_physical_stats (DB_ID () , OBJECT_ID ('Indexing'), NULL, NULL, 'DETAILED');
GO

-- Show the Statistics for the Non-Clustered Index
DBCC SHOW_STATISTICS ('Indexing', NCI_Pay)
/* If you don't have uniqeness with respect to clustered index, SEL Server will go ahead and create another
4 bytes to make it unique internally that never gets exposed!
In our case the avarage key length are two integers of 4 bytes, hence 8 bytes.
The first column is 4 bytes and when you add the second column it becomes 8 bytes (Pay, ID).
You can see that the ID which was the clustered index is currently used as a part of the pointer.
Hence this confirms the part that the non-clustered index goes about using the key of the non-clustered index
but the lead node has got the pointer to the row data, which is the clustered index key or
woulbe be in row ID */



--
-- More Data to explore
--
-- Advanced DMVs on Indexing
--

SELECT * FROM 
sys.dm_db_index_operational_stats(DB_ID () , OBJECT_ID ('Indexing'), NULL, NULL);
GO

-- Internal - undocmented objects
-- for learning purposes ONLY
SELECT obj.name, obj.object_id, part.index_id, 
	internals.total_pages, internals.used_pages, internals.data_pages, 
	internals.first_iam_page, internals.root_page, internals.first_page
    FROM sys.objects obj
    INNER JOIN sys.partitions part 
	ON obj.object_id = part.object_id
    INNER JOIN sys.allocation_units alloc 
	ON alloc.container_id = part.hobt_id
    INNER JOIN sys.system_internals_allocation_units internals 
	ON internals.container_id = alloc.container_id
where obj.name like 'Indexing'

SELECT 
      OBJECT_NAME(object_id) TableName,
      index_type_desc AS INDEX_TYPE,
	  alloc_unit_type_desc AS DATA_TYPE,
      index_id AS INDEX_ID,
      index_depth AS DEPTH,
      index_level AS IND_Level,
      record_count AS RecordCount,
      page_count AS PageCount,
	  fragment_count AS Fragmentation,
	  min_record_size_in_bytes AS MIN_Length,
	  max_record_size_in_bytes AS MAX_Length 
FROM sys.dm_db_index_physical_stats (DB_ID () , OBJECT_ID ('Indexing'), NULL, NULL, 'DETAILED');





