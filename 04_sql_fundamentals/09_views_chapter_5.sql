USE TSQLV4;
GO

/*	VIEWS */

DROP VIEW IF EXISTS Sales.USACusts;
GO
CREATE VIEW Sales.USACusts
AS

SELECT custid, companyname, contactname, contacttitle, address, city, region, postalcode, country, phone, fax
FROM Sales.Customers
WHERE country = N'USA';
GO

/*	The ENCRYPTION option
	is available when you create or alter tables, stored procedures, triggers, and user-defined functions (UDFs).
	only privilaged users can see the obfuscated text. */

SELECT OBJECT_DEFINITION(OBJECT_ID('Sales.USACusts'));
GO

--
ALTER VIEW Sales.USACusts WITH ENCRYPTION
AS

SELECT custid, companyname, contactname, contacttitle, address, city, region, postalcode, country, phone, fax
FROM Sales.Customers
WHERE country = N'USA';
GO
--
SELECT OBJECT_DEFINITION(OBJECT_ID('Sales.USACusts')); -- returns NULL
GO
-- alternative to the object_definition
EXEC sp_helptext 'Sales.USACusts'; -- returns The text for object 'Sales.USACusts' is encrypted.
GO

/*	SCHEMABINDING & WITH CHECK OPTION */

ALTER VIEW Sales.USACusts WITH SCHEMABINDING -- it indicates that referenced objects cannot be dropped
AS

SELECT custid, companyname, contactname, contacttitle, address, city, region, postalcode, country, phone, fax
FROM Sales.Customers
WHERE country = N'USA'
WITH CHECK OPTION; -- prevent modifications through the view that conflict with the view's filter (as for example inserting cust from UK to the view and to the table)
GO

DROP VIEW IF EXISTS Sales.USACusts;
GO

/*	INLINE TABLE-VALIED FUNCTIONS (TVFs)
	"parametarised views" */

DROP FUNCTION IF EXISTS dbo.GetCustOrders;
GO
CREATE FUNCTION dbo.GetCustOrders (@cid AS INT) RETURNS TABLE
AS
RETURN
	SELECT orderid, custid, empid, orderdate, requireddate, shippeddate, shipperid, freight, shipname, shipaddress, shipcity,
		shipregion, shippostalcode, shipcountry
	FROM Sales.Orders
	WHERE custid = @cid;
GO

SELECT * FROM dbo.GetCustOrders(1) AS O;

-- returning customer1's orders with Sales.OrderDetails table, matching the orders with their respective order lines
SELECT O.orderid, O.custid, OD.productid, OD.qty
FROM dbo.GetCustOrders(1) AS O
INNER JOIN Sales.OrderDetails AS OD
ON O.orderid = OD.orderid;

DROP FUNCTION IF EXISTS dbo.GetCustOrders;
GO