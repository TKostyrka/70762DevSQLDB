
	USE [FileAndParts]
	GO

--	CREATE CCI
---------------------------------------------------------------
	
	DROP INDEX IF EXISTS [CCI_FactSales_OnFastParSch]	
	ON [dbo].[FactSales_OnFastParSch]
	GO

	CREATE CLUSTERED COLUMNSTORE INDEX [CCI_FactSales_OnFastParSch]	
	ON [dbo].[FactSales_OnFastParSch]
	GO

--	
---------------------------------------------------------------

	SELECT
		[s].[name] AS [s_name]
	,	[t].[name] AS [t_name]
	,	[i].[name] AS [i_name]
	,	[t].[object_id]
	,	[i].[index_id]
	,	[i].[type]
	,	[i].[type_desc]
	,	[p].[partition_number]
	,	[p].[data_compression_desc]
	,	[p].[rows]
	FROM
		[sys].[schemas]			  AS [s] 
	INNER JOIN [sys].[tables]	  AS [t] ON [t].[schema_id] = [s].[schema_id]
	INNER JOIN [sys].[indexes]	  AS [i] ON [i].[object_id] = [t].[object_id]
	INNER JOIN [sys].[partitions] AS [p] ON [p].[object_id] = [i].[object_id]
											AND [p].[index_id] = [i].[index_id]
	WHERE 1=1
	ORDER BY
		[s].[name]
	,	[t].[name]
	,	[i].[name]
	,	[p].[partition_number]
	;