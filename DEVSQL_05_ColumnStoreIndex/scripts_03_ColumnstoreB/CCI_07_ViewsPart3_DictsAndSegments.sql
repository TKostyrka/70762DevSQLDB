
	USE [CCI]
	GO
	
--	[sys].[column_store_row_groups]
-----------------------------------------------------------

	SELECT
		[TableName]						 = [s].[name] + '.' + [t].[name]
	,	[IndexName]						 = [i].[name]
	,	[partition_number]				 = [p].[partition_number]
	,	[csrg].*
	FROM
		[sys].[schemas]							AS [s]
	INNER JOIN [sys].[tables]			AS [t] ON [t].[schema_id] = [s].[schema_id]
	INNER JOIN [sys].[indexes]			AS [i] ON [i].[object_id] = [t].[object_id]
	INNER JOIN [sys].[partitions]		AS [p] ON [p].[object_id] = [i].[object_id]
														AND [p].[index_id] = [i].[index_id]
	INNER JOIN [sys].[column_store_row_groups] AS [csrg] ON [csrg].[index_id] = [i].[index_id]
															AND [csrg].[object_id] = [i].[object_id]
															AND [csrg].[partition_number] = [p].[partition_number]
	WHERE 1=1
	AND [s].[name] = 'dbo'
	AND [t].[name] = 'FactSales'

--	[sys].[column_store_segments]
-----------------------------------------------------------

	SELECT
		[s].[name] + '.' + [t].[name]	AS [TableName]
	,	[i].[name]						AS [IndexName]
	,	[p].[partition_number]			AS [partition_number]
	,	[c].[name]
	,	[css].*
	FROM
		[sys].[schemas]							AS [s]
	INNER JOIN [sys].[tables]			AS [t] ON [t].[schema_id] = [s].[schema_id]
	INNER JOIN [sys].[indexes]			AS [i] ON [i].[object_id] = [t].[object_id]
	INNER JOIN [sys].[columns]			AS [c] ON [c].[object_id] = [i].[object_id]
	INNER JOIN [sys].[partitions]		AS [p] ON [p].[object_id] = [i].[object_id]
														AND [p].[index_id] = [i].[index_id]
	INNER JOIN [sys].[column_store_segments] AS [css] ON [css].[column_id] = [c].[column_id]
															AND [css].[hobt_id] = [p].[hobt_id]
															AND [css].[partition_id] = [p].[partition_id]
	WHERE
		1 = 1
		AND [s].[name] = 'dbo'
		AND [t].[name] = 'FactSales'
		AND [p].[partition_number] = 1
	ORDER BY 
		[s].[name]
	,	[t].[name]
	,	[i].[name]
	,	[c].[column_id]
	,	[p].[partition_number]
	;

--	[sys].[column_store_dictionaries]
-----------------------------------------------------------

	SELECT
		[s].[name] + '.' + [t].[name]	AS [TableName]
	,	[i].[name]						AS [IndexName]
	,	[p].[partition_number]			AS [partition_number]
	,	[c].[name]
	,	[csd].*
	FROM
		[sys].[schemas]								AS [s]
	INNER JOIN [sys].[tables]				AS [t] ON [t].[schema_id] = [s].[schema_id]
	INNER JOIN [sys].[indexes]				AS [i] ON [i].[object_id] = [t].[object_id]
	INNER JOIN [sys].[columns]				AS [c] ON [c].[object_id] = [i].[object_id]
	INNER JOIN [sys].[partitions]			AS [p] ON [p].[object_id] = [i].[object_id]
															AND [p].[index_id] = [i].[index_id]
	INNER JOIN [sys].[column_store_dictionaries] AS [csd] ON [csd].[hobt_id] = [p].[hobt_id]
																AND [csd].[partition_id] = [p].[partition_id]
																AND [csd].[column_id] = [c].[column_id]
	WHERE
		1 = 1
		AND [s].[name] = 'dbo'
		AND [t].[name] = 'FactSales'
	ORDER BY 
		[s].[name]
	,	[t].[name]
	,	[i].[name]
	,	[c].[column_id]
	,	[p].[partition_number]


--	ALL
-----------------------------------------------------------

	SELECT
		[s].[name] + '.' + [t].[name]	AS [TableName]
	,	[i].[name]						AS [IndexName]
	,	[p].[partition_number]			AS [partition_number]
	,	[c].[name]
	,	[csrg].*
	,	[css].*
	,	[csd1].*
	,	[csd2].*
	FROM
		[sys].[schemas]							AS [s]
	INNER JOIN [sys].[tables]			AS [t] ON [t].[schema_id] = [s].[schema_id]
	INNER JOIN [sys].[indexes]			AS [i] ON [i].[object_id] = [t].[object_id]
	INNER JOIN [sys].[columns]			AS [c] ON [c].[object_id] = [i].[object_id]
	INNER JOIN [sys].[partitions]		AS [p] ON [p].[object_id] = [i].[object_id]
														AND [p].[index_id] = [i].[index_id]
	INNER JOIN [sys].[column_store_row_groups] AS [csrg] ON [csrg].[index_id] = [i].[index_id]
															AND [csrg].[object_id] = [i].[object_id]
															AND [csrg].[partition_number] = [p].[partition_number]
	INNER JOIN [sys].[column_store_segments] AS [css] ON [css].[column_id] = [c].[column_id]
															AND [css].[hobt_id] = [p].[hobt_id]
															AND [css].[partition_id] = [p].[partition_id]
															AND [css].[segment_id] = [csrg].[row_group_id]
	LEFT JOIN [sys].[column_store_dictionaries] AS [csd1] ON [csd1].[hobt_id] = [p].[hobt_id]
																AND [csd1].[partition_id] = [p].[partition_id]
																AND [csd1].[column_id] = [c].[column_id]
																AND [csd1].[dictionary_id] = [css].[primary_dictionary_id] 
	LEFT JOIN [sys].[column_store_dictionaries] AS [csd2] ON [csd2].[hobt_id] = [p].[hobt_id]
																AND [csd2].[partition_id] = [p].[partition_id]
																AND [csd2].[column_id] = [c].[column_id]
																AND [csd2].[dictionary_id] = [css].[secondary_dictionary_id] 
	WHERE
		1 = 1
		AND [s].[name] = 'dbo'
		AND [t].[name] = 'FactSales'
		AND [p].[partition_number] = 2
	ORDER BY 
		[s].[name]
	,	[t].[name]
	,	[i].[name]
	,	[c].[column_id]
	,	[p].[partition_number]