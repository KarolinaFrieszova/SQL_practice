
/*	T-SQL Create Type Statement
	Use to create aliases for primitive types, or to create custom data types 

	CREATE TYPE <name of type>
	FROM <base type>;

	CREATE TYPE <name of type>
	AS TABLE
	(
		Column definitions here ...
	);
*/
USE contacts;
GO
DROP TABLE IF EXISTS dbo.ContactVerificationDetails;
GO

CREATE TABLE [dbo].[ContactVerificationDetails](
	[ContactId] [int] IDENTITY NOT NULL,
	[DrivingLicense] [varchar](40) NULL,
	[Passport] [varchar](40) NULL,
	[ContactVerified] BIT NOT NULL,
 CONSTRAINT [PK_ContactVerificationDetails] PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TYPE dbo.DrivingLicense
FROM CHAR(16) NOT NULL;

DECLARE @DL DrivingLicense = 'LAURA1234567890%%%%%%'; -- cut to 16 characters
SELECT @DL;
GO
DROP TYPE IF EXISTS DrivingLicense;