USE [contacts]
GO

/****** Object:  Table [dbo].[person]    Script Date: 28/06/2022 12:21:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS dbo.Contacts;
GO

CREATE TABLE [dbo].[Contacts](
	[ContactId] [int] IDENTITY NOT NULL,
	[FirstName] [varchar](256) NOT NULL,
	[LastName] [varchar](256) NOT NULL,
	[DateOfBirth] DATE NULL,
	[AllowContactByPhone] BIT,
 CONSTRAINT [PK_Contacts] PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

DROP PROCEDURE IF EXISTS dbo.InsertContact;
GO
CREATE PROCEDURE dbo.InsertContact
(
	@FirstName [varchar](256), -- parameters
	@LastName [varchar](256),
	@DateOfBirth DATE = NULL,
	@AllowContactByPhone BIT
)
AS
BEGIN;

DECLARE @ContactId INT; -- variable

	INSERT INTO dbo.Contacts (FirstName, LastName, DateOfBirth, AllowContactByPhone)
	VALUES(@FirstName, @LastName, @DateOfBirth, @AllowContactByPhone);

	SELECT @ContactId = SCOPE_IDENTITY(); -- good practice

	SELECT ContactId, FirstName, LastName, DateOfBirth, AllowContactByPhone
	FROM dbo.Contacts
	WHERE ContactId = @ContactId;
END;
GO


/* Insert the contact, return the details (return ID), no duplicates are allowed
	the store procedure should be doing only one task,
	separate the tasks and create a store procedure for each

	Output Parameter - assign output to holding variable

	DECLARE @ContactIdOut INT;

	EXC dbo.SetectContactId
	@ContactId = @ContactIdOut OUTPUT;

	SELECT @ContactIdOut;
*/

DROP PROCEDURE IF EXISTS dbo.InsertContact;
GO
CREATE PROCEDURE dbo.InsertContact
(
	@FirstName [varchar](256),
	@LastName [varchar](256),
	@DateOfBirth DATE = NULL,
	@AllowContactByPhone BIT,
	@ContactId INT OUTPUT -- declare the output parameter, work OUTPUT at the end turns the parameter to an output paramenter
)
AS
BEGIN;
	SET NOCOUNT ON; -- remove the messages (1 row affected); less network traffic

	IF NOT EXISTS (	SELECT 1 FROM dbo.Contacts
					WHERE FirstName = @FirstName AND LastName = @LastName AND DateOfBirth = @DateOfBirth) -- date can be NULL so won't work
	BEGIN;
		INSERT INTO dbo.Contacts (FirstName, LastName, DateOfBirth, AllowContactByPhone)
		VALUES(@FirstName, @LastName, @DateOfBirth, @AllowContactByPhone);

		SELECT @ContactId = SCOPE_IDENTITY(); -- good practice
	END;

	EXEC dbo.SelectContact @ContactId = @ContactId;
	SET NOCOUNT OFF;
END;
GO

---------------- Calling script
USE contacts;
GO
DECLARE @ContactIdOut INT; -- variable declared

EXEC dbo.InsertContact
	@FirstName = 'Alla',
	@LastName = 'Taylor',
	@DateOfBirth = '1989-12-12',
	@AllowContactByPhone = 0,
	@ContactId = @ContactIdOut OUTPUT; -- must be added

--SELECT * FROM dbo.Contacts WHERE ContactId = @ContactIdOut ORDER BY ContactId DESC;

--SELECT @ContactIdOut AS ContactIdOut;

--EXEC dbo.SelectContact 1;

SELECT * FROM dbo.Contacts


