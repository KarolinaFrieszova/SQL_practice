USE TSQLV4;

-- create table called Employees
DROP TABLE IF EXISTS dbo.Employees;

CREATE TABLE dbo.Employees
(
	EmpId		INT			NOT NULL,
	FirstName	VARCHAR(30) NOT NULL,
	LastName	VARCHAR(30) NOT NULL,
	HireDate	DATE		NOT NULL,
	MgrId		INT			NULL,
	Ssn			VARCHAR(30) NOT NULL,
	Salary		MONEY		NOT NULL
);

-- add PRIMARY-KEY CONSTRAINT
ALTER TABLE dbo.Employees
	ADD CONSTRAINT PK_Employees PRIMARY KEY(EmpId);

-- add UNIQUE  CONSTRAINTs
ALTER TABLE dbo.Employees
	ADD CONSTRAINT UNQ_Employees_ssn UNIQUE(Ssn);

-- create table called Orders with a primary key defined on the OrderId column
DROP TABLE IF EXISTS dbo.Orders;

CREATE TABLE dbo.Orders
(
	OrderId	INT			NOT NULL,
	EmpId	INT			NOT NULL,
	CustId	VARCHAR(10) NOT NULL,
	OrderTs	DATETIME2	NOT NULL,
	Qty		INT			NOT NULL,
	CONSTRAINT PK_Orders PRIMARY KEY(OrderId)
);

/*
	FOREIGN KEY
	enfore an integrity rule that restricts the values supported by the EmpId column in the Orders table
	to the values that exists in the EmpId column in the Employees table.
*/
ALTER TABLE dbo.Orders
	ADD CONSTRAINT FK_Orders_Employees FOREIGN KEY(EmpId)
	REFERENCES dbo.Employees(EmpId);

/*
	restrict the values supported by the MngId column in the Employees table to the values that exist
	in the EmpId column of the same table
*/
ALTER TABLE dbo.Employees
	ADD CONSTRAINT FK_Employees_Employees FOREIGN KEY(MgrId)
	REFERENCES dbo.Employees(EmpId);

/*
	CHECK CONSTRAINT
	add a check constraint that ensures that the salary column in the Employees table
	will support only positive values
*/
ALTER TABLE dbo.Employees
	ADD CONSTRAINT CHK_Employees_Salary CHECK(Salary > 0.00);

/*
	DEFAULT CONSTRAINT
	define a default constraint for the OrderTs attribute/column (representing the order's time stamp
*/
ALTER TABLE dbo.Orders
	ADD CONSTRAINT DFT_Orders_OrderTs DEFAULT(SYSDATETIME()) FOR OrderTs;

-- run for cleanup
DROP TABLE IF EXISTS dbo.Orders, dbo.Employees;