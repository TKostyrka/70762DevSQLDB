USE	[TestDB]
GO

	-----------------------------------------------------------------------------
	
	PRINT CONVERT(VARCHAR(100), GETDATE(), 109)

	WAITFOR DELAY '00:00:03'

	PRINT CONVERT(VARCHAR(100), GETDATE(), 109)
	GO


	-----------------------------------------------------------------------------

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

	WHILE (SELECT COUNT(*) FROM [dbo].[Tabelka]) < 20
	BEGIN
		
		WAITFOR DELAY '00:00:01'

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
