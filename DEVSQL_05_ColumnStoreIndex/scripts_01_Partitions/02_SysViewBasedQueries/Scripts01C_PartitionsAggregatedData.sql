
	USE [FileAndParts]
	GO

--	aggregated info
---------------------------------------------------------------------

	SELECT
		[s].[name] AS [s_name]
	,	[t].[name] AS [t_name]
	,	[i].[name] AS [i_name]
	,	[i].[type_desc]
	,	COUNT(*)		AS [partition_cnt]
	,	SUM([p].[rows])	AS [partition_rows]
	FROM
		[sys].[schemas]			  AS [s] (NOLOCK) 
	INNER JOIN [sys].[tables]	  AS [t] (NOLOCK) ON [t].[schema_id] = [s].[schema_id]
	INNER JOIN [sys].[indexes]	  AS [i] (NOLOCK) ON [i].[object_id] = [t].[object_id]
													AND [i].[type] = 5
	INNER JOIN [sys].[partitions] AS [p] (NOLOCK) ON [p].[object_id] = [i].[object_id]
													AND [p].[index_id] = [i].[index_id]
	WHERE 1=1
	GROUP BY 	
		[s].[name]
	,	[t].[name]
	,	[i].[name]
	,	[i].[type_desc]
	ORDER BY
		[partition_rows] DESC
	;
