USE [TestDB]
GO

	IF OBJECT_ID('TestowaProcedura2') IS NOT NULL DROP PROC [dbo].[TestowaProcedura2]
	GO

	CREATE PROC [dbo].[TestowaProcedura2]
	AS
	BEGIN
		
		IF OBJECT_ID('Tabelka', 'U') IS NOT NULL 
		DROP TABLE [dbo].[Tabelka]
		;

		CREATE TABLE [dbo].[Tabelka]
		(
			TabId INT IDENTITY PRIMARY KEY,
			TabDate DATETIME
		)
		;

		INSERT INTO [dbo].[Tabelka] VALUES(GETDATE());
		INSERT INTO [dbo].[Tabelka] VALUES(GETDATE());
		INSERT INTO [dbo].[Tabelka] VALUES(GETDATE());
		INSERT INTO [dbo].[Tabelka] VALUES(GETDATE());
		;

		SELECT *
		FROM [dbo].[Tabelka]

	END
	GO

---------------------------------------------------------

	EXEC [dbo].[TestowaProcedura2]

---------------------------------------------------------
