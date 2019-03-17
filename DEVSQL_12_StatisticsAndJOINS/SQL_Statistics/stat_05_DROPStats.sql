	USE [STAT]
	GO

--	Stats
------------------------------------------------------

	SELECT
		[v].[sh_name]
	,	[v].[tb_name]
	,	[v].[st_name]
	,	[v].[stats_column_id]
	FROM
		[dbo].[MyStatsView] AS [v]
	WHERE
		[v].[sh_name]		= 'dbo'
		AND [v].[tb_name]	= 'FactSales';
	GO

--	DROP STATS
------------------------------------------------------

	DROP STATISTICS [dbo].[FactSales].[MyStats_01]
	DROP STATISTICS [dbo].[FactSales].[MyStats_02]
	DROP STATISTICS [dbo].[FactSales].[MyStats_03a]
	DROP STATISTICS [dbo].[FactSales].[MyStats_03b]
	DROP STATISTICS [dbo].[FactSales].[MyStats_03c_filtered]
	GO

------------------------------------------------------

	SELECT
		[v].[sh_name]
	,	[v].[tb_name]
	,	[v].[st_name]
	,	[v].[stats_column_id]
	FROM
		[dbo].[MyStatsView] AS [v]
	WHERE
		[v].[sh_name]		= 'dbo'
		AND [v].[tb_name]	= 'FactSales';
	GO