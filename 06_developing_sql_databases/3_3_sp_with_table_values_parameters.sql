/*	Table-valued Parameters and Refactoring 

	User-Defined TABLE Type
	*/

Use contacts;
GO

DROP TYPE IF EXISTS dbo.ContactNote;

GO

CREATE TYPE dbo.ContactNote
AS TABLE
(
	Note VARCHAR(MAX) NOT NULL
);

GO
DROP TABLE IF EXISTS [dbo].[ContactNotes];
GO
CREATE TABLE [dbo].[ContactNotes](
	[NoteId] INT IDENTITY,
	[ContactId] [int] NOT NULL,
	[Note] VARCHAR(MAX) NOT NULL,
	CONSTRAINT [PK_ContactNotes] PRIMARY KEY CLUSTERED (NoteId),
	CONSTRAINT [FK_ContactNotes] FOREIGN KEY (ContactId) REFERENCES dbo.Contacts (ContactId)
)
GO

IF EXISTS(SELECT 1 FROM sys.procedures WHERE [name] = 'InsertContactNotes')
BEGIN;
	DROP PROCEDURE dbo.InsertContactNotes;
END;
GO

CREATE PROCEDURE dbo.InsertContactNotes
(
	@ContactId INT,
	@Notes ContactNote READONLY -- ContactNote is s user-defined TABLE Type assigned to the parameter
)
AS
BEGIN;

	INSERT INTO dbo.ContactNotes (ContactId, Note)
	SELECT @ContactId, Note FROM @Notes;

	SELECT * FROM dbo.ContactNotes
	WHERE ContactId = @ContactId
	ORDER BY NoteId DESC;
END;

GO

DECLARE @TempNotes ContactNote;

INSERT INTO @TempNotes (Note)
VALUES
('Hi, Peter called.'), 
('Paula is on holiday 12.12.2022'),
('Last one');

EXEC dbo.InsertContactNotes @ContactId = 6, @Notes = @TempNotes;
