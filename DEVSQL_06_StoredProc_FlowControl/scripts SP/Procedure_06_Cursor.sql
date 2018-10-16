USE [ContosoRetailDW]
GO

	IF OBJECT_ID('TableCounter') IS NOT NULL DROP PROC [dbo].[TableCounter]
	GO

	----------------------------------------------------------------------------------------

	CREATE PROC [dbo].[TableCounter]
	AS
	BEGIN	
		
		SET NOCOUNT ON
		;

		DROP TABLE IF EXISTS #sqlcmds
		DROP TABLE IF EXISTS [dbo].[AuditTableCounts]
		;

		CREATE TABLE [dbo].[AuditTableCounts]
		(
			TblName		VARCHAR(100)	NOT NULL 
		,	TblCount	INT				NOT NULL 
		,	InsertDate	DATETIME		NOT NULL DEFAULT GETDATE()
		)
		;
		
		SELECT [sqlcmd] = 'SELECT ''[' + s.[name] + '].[' + t.[name] + ']'', COUNT(*) AS [cnt] FROM [' + s.[name] + '].[' + t.[name] + '] AS [f] (NOLOCK)'
		INTO #sqlcmds
		FROM 
					[sys].[schemas] AS s
		INNER JOIN	[sys].[tables]	AS t ON s.[schema_id] = t.[schema_id]
		WHERE 1=1
		AND s.[name] IN ('dbo')
		AND (t.[name] LIKE 'Fact%' OR t.[name] LIKE 'Dim%')
		;

		DECLARE @sqlcmd VARCHAR(MAX)

		DECLARE cur CURSOR 
		FOR
		SELECT [sqlcmd]
		FROM #sqlcmds

			OPEN cur  

				FETCH NEXT FROM cur 
				INTO @sqlcmd  

				WHILE @@FETCH_STATUS = 0  
				BEGIN  

					INSERT INTO [dbo].[AuditTableCounts]([TblName], [TblCount])
					EXEC(@sqlcmd)

					FETCH NEXT FROM cur 
					INTO @sqlcmd  
				END  

			CLOSE cur  

		DEALLOCATE cur

	END
	GO

	----------------------------------------------------------------------------------------
	

	EXEC [dbo].[TableCounter]
	GO

	SELECT *
	FROM [dbo].[AuditTableCounts]
	GO
