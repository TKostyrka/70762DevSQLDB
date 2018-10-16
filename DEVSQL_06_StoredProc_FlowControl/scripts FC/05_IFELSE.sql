USE [ContosoRetailDW]
GO


	DECLARE	@schname VARCHAR(100) = 'dbo'
		,	@tabname VARCHAR(100) = 'DimAccount'
	;

	IF OBJECT_ID(@schname + '.' +@tabname) IS NOT NULL
	BEGIN

		SELECT [c].[object_id]
            ,  [c].[name]
            ,  [c].[column_id]
            ,  [c].[system_type_id]
            ,  [c].[user_type_id]
            ,  [c].[max_length]
            ,  [c].[precision]
            ,  [c].[scale]
            ,  [c].[collation_name]
            ,  [c].[is_nullable]
		FROM 
			sys.schemas AS s 
		INNER JOIN sys.[tables] AS t ON [t].[schema_id] = [s].[schema_id]
		INNER JOIN sys.[columns] AS c ON [c].[object_id] = [t].[object_id]
		WHERE 1=1
		AND s.name = @schname
		AND t.name = @tabname
			
	END
	ELSE 
	BEGIN
		SELECT 'Brak tabeli' AS [komunikat]
	END
	;