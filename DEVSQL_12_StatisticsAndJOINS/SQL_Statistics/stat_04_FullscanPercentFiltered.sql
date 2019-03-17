	USE [STAT]
	GO

--	Stats
------------------------------------------------------

	SELECT
		[v].[sh_name]
	,	[v].[tb_name]
	,	[v].[st_name]
	,	[v].[stats_column_id]
	,	[p].*
	FROM
		[dbo].[MyStatsView]														AS [v]
	CROSS APPLY [sys].[dm_db_stats_properties]([v].[object_id], [v].[stats_id]) AS [p]
	WHERE
		[v].[sh_name]		= 'dbo'
		AND [v].[tb_name]	= 'FactSales';

--	FULLSCAN vs PERCENT, FILTERED
------------------------------------------------------

	CREATE STATISTICS MyStats_03a
	ON [dbo].[FactSales]([SalesQuantity])
	WITH FULLSCAN
	GO

	CREATE STATISTICS MyStats_03b
	ON [dbo].[FactSales]([SalesQuantity])
	WITH SAMPLE 30 PERCENT
	GO

	CREATE STATISTICS MyStats_03c_filtered
	ON [dbo].[FactSales]([SalesQuantity])
	WHERE [channelKey] = 2
	GO

------------------------------------------------------

	SELECT
		[v].[sh_name]
	,	[v].[tb_name]
	,	[v].[st_name]
	,	[v].[stats_column_id]
	,	[p].*
	FROM
		[dbo].[MyStatsView]														AS [v]
	CROSS APPLY [sys].[dm_db_stats_properties]([v].[object_id], [v].[stats_id]) AS [p]
	WHERE
		[v].[sh_name]		= 'dbo'
		AND [v].[tb_name]	= 'FactSales';