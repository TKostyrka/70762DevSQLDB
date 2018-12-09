USE [FileAndParts]
GO

--	quick overview
-----------------------------------------------------------

	SELECT
		[o].[type_desc]
	,	COUNT(*)
	FROM
		[sys].[partitions]		AS [p]
	INNER JOIN [sys].[objects] AS [o] ON [o].[object_id] = [p].[object_id]
	GROUP BY
		[o].[type_desc]
	ORDER BY
		[o].[type_desc];

	--------------------------

	SELECT
		[t].[name]
	,	[o].[type_desc]
	,	COUNT(*)
	FROM
		[sys].[partitions]		AS [p]
	INNER JOIN [sys].[objects] AS [o] ON [o].[object_id] = [p].[object_id]
	INNER JOIN [sys].[tables] AS [t] ON [t].[object_id] = [o].[object_id]
	WHERE
		[o].[is_ms_shipped] = 0
	GROUP BY
		[t].[name]
	,	[o].[type_desc]
	ORDER BY
		[t].[name]
	,	[o].[type_desc];

--	partition-related sys views
-----------------------------------------------------------

	SELECT *
	FROM [sys].[partition_schemes] AS [ps]

	SELECT *
	FROM sys.[partition_functions] AS [pf]

	SELECT *
	FROM sys.[partition_parameters] AS [pp]

	SELECT *
	FROM sys.[partition_range_values] AS [prv]

--	partition schema/function details
-----------------------------------------------------------

	SELECT
		[s_name]	= [ps].[name]
	,	[ps].[type_desc]
	,	[f_name]	= [pf].[name]
	,	[pf].[function_id]
	,	[pf].[type]
	,	[pf].[type_desc]
	,	[prv].[boundary_id]
	,	[prv].[value]
	FROM
		[sys].[partition_schemes]				AS [ps]
	INNER JOIN [sys].[partition_functions] AS [pf] ON [pf].[function_id] = [ps].[function_id]
	INNER JOIN [sys].[partition_range_values] AS [prv] ON [prv].[function_id] = [pf].[function_id]
	WHERE
		1				= 1
		AND [ps].[name] = 'PS_DatesYR_OnFast';