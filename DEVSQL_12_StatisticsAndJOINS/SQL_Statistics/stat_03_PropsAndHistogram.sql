	USE [STAT]
	GO

--	PK Stats
------------------------------------------------------

	SELECT		*
	FROM		[dbo].[MyStatsView] AS [v]
	WHERE
			[v].[sh_name]	= 'dbo'
		AND [v].[tb_name]	= 'FactSales'
		AND [v].[stats_id]	= 1;

--	[sys].[dm_db_stats_properties]
------------------------------------------------------

	SELECT
		[v].[sh_name]
	,	[v].[tb_name]
	,	[v].[st_name]
	,	[v].[stats_column_id]
	,	[p].[object_id]
	,	[p].[stats_id]
	,	[p].[last_updated]
	,	[p].[rows]
	,	[p].[rows_sampled]
	,	[p].[steps]
	,	[p].[unfiltered_rows]
	,	[p].[modification_counter]
	FROM
		[dbo].[MyStatsView]														AS [v]
	CROSS APPLY [sys].[dm_db_stats_properties]([v].[object_id], [v].[stats_id]) AS [p]
	WHERE
		[v].[sh_name]		= 'dbo'
		AND [v].[tb_name]	= 'FactSales'

--	[sys].[dm_db_stats_histogram]
------------------------------------------------------

	SELECT
		[v].[sh_name]
	,	[v].[tb_name]
	,	[v].[st_name]
	,	[v].[stats_column_id]
	,	[p].[object_id]
	,	[p].[stats_id]
	,	[p].[step_number]
	,	[p].[range_high_key]
	,	[p].[range_rows]
	,	[p].[equal_rows]
	,	[p].[distinct_range_rows]
	,	[p].[average_range_rows]
	FROM
		[dbo].[MyStatsView]														AS [v]
	CROSS APPLY [sys].[dm_db_stats_histogram]([v].[object_id], [v].[stats_id]) AS [p]
	WHERE
			[v].[sh_name]	= 'dbo'
		AND [v].[tb_name]	= 'FactSales'
		AND [v].[st_name]	= 'MyStats_01'
	ORDER BY 
		[p].[step_number]
	,	[v].[stats_column_id]