USE [TestDB]
GO

	IF OBJECT_ID('TestowaProcedura2') IS NOT NULL DROP PROC [dbo].[TestowaProcedura2]
	GO

	CREATE PROC [dbo].[TestowaProcedura2]
		@Parametr1 NVARCHAR(100) = 'Wartosc Domyslna Parametru'
	AS
	BEGIN	
		
		SET NOCOUNT ON
		;
		
		IF OBJECT_ID('Tabelka', 'U') IS NOT NULL 
		DROP TABLE [dbo].[Tabelka]
		;

		CREATE TABLE [dbo].[Tabelka]
		(
			TabId INT IDENTITY PRIMARY KEY,
			TabDate DATETIME,
			TabParamValue NVARCHAR(100)
		)
		;

		INSERT INTO [dbo].[Tabelka] VALUES(GETDATE(), @Parametr1);
		INSERT INTO [dbo].[Tabelka] VALUES(GETDATE(), @Parametr1);
		INSERT INTO [dbo].[Tabelka] VALUES(GETDATE(), @Parametr1);
		INSERT INTO [dbo].[Tabelka] VALUES(GETDATE(), @Parametr1);
		;

		SELECT *
		FROM [dbo].[Tabelka]

	END
	GO

---------------------------------------------------------

	EXEC [dbo].[TestowaProcedura2] 'Wartoœæ Parametru'

---------------------------------------------------------

---------------------------------------------------------

	EXEC [dbo].[TestowaProcedura2]

---------------------------------------------------------
