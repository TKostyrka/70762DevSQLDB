
	USE [FileAndParts]
	GO

--	boundaries
---------------------------------------------------------------------

	SELECT
		[sm].[name]				AS [s_name]
	,	[tb].[name]				AS [t_name]
	,	[ix].[name]				AS [i_name]
	,	[ix].[type_desc]		AS [i_type]
	,	[pt].[partition_number] AS [p_number]
	,	[pt].[rows]				AS [p_rows]
	,	[ds].[name]				AS [d_name]
	,	[ds].[type_desc]		AS [d_type]
	,	[sh].[name]				AS [ps_name]
	,	[fc].[name]				AS [pf_name]
	,	[lv].[value]			AS [leftValue]
	,	[rv].[value]			AS [rightValue]
	FROM
		[sys].[schemas]						 AS [sm]
	INNER JOIN [sys].[tables]				 AS [tb] ON [tb].[schema_id] = [sm].[schema_id]
	INNER JOIN [sys].[indexes]				 AS [ix] ON [tb].[object_id] = [ix].[object_id]
	INNER JOIN [sys].[partitions]			 AS [pt] ON [pt].[object_id] = [ix].[object_id]
														AND [pt].[index_id] = [ix].[index_id]
	INNER JOIN [sys].[data_spaces]			 AS [ds] ON [ix].[data_space_id] = [ds].[data_space_id]
	INNER JOIN [sys].[partition_schemes]	 AS [sh] ON [ix].[data_space_id] = [sh].[data_space_id]
	INNER JOIN [sys].[partition_functions]	 AS [fc] ON [sh].[function_id] = [fc].[function_id]
	LEFT JOIN [sys].[partition_range_values] AS [rv] ON [fc].[function_id] = [rv].[function_id]
														AND [pt].[partition_number] = [rv].[boundary_id]
	LEFT JOIN [sys].[partition_range_values] AS [lv] ON [fc].[function_id] = [lv].[function_id]
														AND [pt].[partition_number] - 1 = [lv].[boundary_id]
	WHERE
		1 = 1
	ORDER BY [p_number]
	;