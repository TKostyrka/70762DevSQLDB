	USE [STAT]
	GO

--	Stats
------------------------------------------------------

	SELECT
		[v].[sh_name]
	,	[v].[tb_name]
	,	[v].[st_name]
	,	[v].[co_name]
	,	[v].[stats_column_id]
	,	[p].*
	FROM
		[dbo].[MyStatsView]														AS [v]
	CROSS APPLY [sys].[dm_db_stats_properties]([v].[object_id], [v].[stats_id]) AS [p]
	WHERE
		[v].[sh_name]		= 'dbo'
		AND [v].[tb_name]	= 'FactSales';
	GO

--	UPDATE STATS
------------------------------------------------------

	UPDATE STATISTICS [dbo].[FactSales] _WA_Sys_00000001_35BCFE0A
	UPDATE STATISTICS [dbo].[FactSales] _WA_Sys_00000004_35BCFE0A	WITH FULLSCAN
	UPDATE STATISTICS [dbo].[FactSales] _WA_Sys_00000005_35BCFE0A	WITH SAMPLE 50 PERCENT
	GO

------------------------------------------------------

	SELECT
		[v].[sh_name]
	,	[v].[tb_name]
	,	[v].[st_name]
	,	[v].[co_name]
	,	[v].[stats_column_id]
	,	[p].*
	FROM
		[dbo].[MyStatsView]														AS [v]
	CROSS APPLY [sys].[dm_db_stats_properties]([v].[object_id], [v].[stats_id]) AS [p]
	WHERE
		[v].[sh_name]		= 'dbo'
		AND [v].[tb_name]	= 'FactSales';
	GO

--	UPDATE STATS
------------------------------------------------------

	UPDATE STATISTICS [dbo].[FactSales] PK_SalesKey
	UPDATE STATISTICS [dbo].[FactSales] CRIX_FactSales
	GO

------------------------------------------------------

	SELECT
		[v].[sh_name]
	,	[v].[tb_name]
	,	[v].[st_name]
	,	[v].[co_name]
	,	[v].[stats_column_id]
	,	[p].*
	FROM
		[dbo].[MyStatsView]														AS [v]
	CROSS APPLY [sys].[dm_db_stats_properties]([v].[object_id], [v].[stats_id]) AS [p]
	WHERE
		[v].[sh_name]		= 'dbo'
		AND [v].[tb_name]	= 'FactSales';
	GO

--	UPDATE STATS
------------------------------------------------------

	UPDATE STATISTICS [dbo].[FactSales] WITH RESAMPLE
	GO

------------------------------------------------------

	SELECT
		[v].[sh_name]
	,	[v].[tb_name]
	,	[v].[st_name]
	,	[v].[co_name]
	,	[v].[stats_column_id]
	,	[p].*
	FROM
		[dbo].[MyStatsView]														AS [v]
	CROSS APPLY [sys].[dm_db_stats_properties]([v].[object_id], [v].[stats_id]) AS [p]
	WHERE
		[v].[sh_name]		= 'dbo'
		AND [v].[tb_name]	= 'FactSales';
	GO
