USE	[TestDB]
GO

	IF OBJECT_ID('Tabelka', 'U') IS NOT NULL 
	DROP TABLE [dbo].[Tabelka]
	;

	CREATE TABLE [dbo].[Tabelka]
	(
		TabId INT IDENTITY PRIMARY KEY,
		TabDate DATETIME
	)
	;

	-----------------------------------------------------------------------------

	WHILE (SELECT COUNT(*) FROM [dbo].[Tabelka]) < 4000
	BEGIN
		
		INSERT INTO [dbo].[Tabelka]
		VALUES(GETDATE())
		;

	END

	-----------------------------------------------------------------------------

	SELECT COUNT(*)
	FROM [dbo].[Tabelka]

	-----------------------------------------------------------------------------

	SELECT TOP 100 *
	FROM [dbo].[Tabelka]

