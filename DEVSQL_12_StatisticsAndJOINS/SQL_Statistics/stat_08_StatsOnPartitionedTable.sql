	USE [STAT]
	GO

--	There is a database level setting to enable incremental statistics. 
--	When the option INCREMENTAL is turn on at the database level, newly auto created column statistics will use incremental statistics on partitioned tables by default.
--	Existing index or column statistics will not be affected by this database option. 
--	You will have to manually set the existing statistics to be an incremental statistics on the partitioned table. 
--	The command is quite straight-forward as below.

	--	ALTER DATABASE [databaseName] SET AUTO_CREATE_STATISTICS ON (INCREMENTAL = ON)
	--	GO

------------------------------------------------------

	CREATE STATISTICS MyStatsOnPart_01
	ON [dbo].[FactSalesParts]([SalesQuantity])
	WITH INCREMENTAL = ON
	GO

	CREATE STATISTICS MyStatsOnPart_02
	ON [dbo].[FactSalesParts]([DiscountQuantity])
	WITH INCREMENTAL = OFF
	GO

------------------------------------------------------

	SELECT	[v].*
	FROM	[dbo].[MyStatsView] AS [v]
	WHERE
		[v].[sh_name]		= 'dbo'
	AND [v].[tb_name]	= 'FactSalesParts';

--	[sys].[dm_db_stats_properties_internal]:	UNDOCUMENTED (!!!)
------------------------------------------------------------------------------------------------------------
	
	SELECT
		[v].[sh_name]
	,	[v].[tb_name]
	,	[v].[st_name]
	,	[v].[co_name]
	,	[sp].[partition_number]
	,	[sp].[last_updated]
	,	[sp].[rows]
	,	[sp].[rows_sampled]
	,	[sp].[steps]
	,	[sp].[unfiltered_rows]
	,	[sp].[modification_counter]
	FROM
		[dbo].[MyStatsView]																	AS [v]
	CROSS APPLY [sys].[dm_db_incremental_stats_properties]([v].[object_id], [v].[stats_id]) AS [sp]
	WHERE
		[v].[sh_name]		= 'dbo'
		AND [v].[tb_name]	= 'FactSalesParts'
		AND [v].[st_name]	= 'MyStatsOnPart_01'
	ORDER BY
		[sp].[partition_number]

------------------------------------------------------

	UPDATE STATISTICS [dbo].[FactSalesParts](MyStatsOnPart_01)	WITH RESAMPLE ON PARTITIONS(1)
	UPDATE STATISTICS [dbo].[FactSalesParts](MyStatsOnPart_01)	WITH RESAMPLE ON PARTITIONS(2)

------------------------------------------------------
	
	SELECT
		[v].[sh_name]
	,	[v].[tb_name]
	,	[v].[st_name]
	,	[v].[co_name]
	,	[sp].[partition_number]
	,	[sp].[last_updated]
	FROM
		[dbo].[MyStatsView]																	AS [v]
	CROSS APPLY [sys].[dm_db_incremental_stats_properties]([v].[object_id], [v].[stats_id]) AS [sp]
	WHERE
		[v].[sh_name]		= 'dbo'
		AND [v].[tb_name]	= 'FactSalesParts'
		AND [v].[st_name]	= 'MyStatsOnPart_01'
	ORDER BY
		[sp].[partition_number]



--	[sys].[dm_db_stats_properties_internal]:	UNDOCUMENTED (!!!)
------------------------------------------------------------------------------------------------------------

	SELECT
		[v].[sh_name]
	,	[v].[tb_name]
	,	[v].[st_name]
	,	[v].[co_name]
	,	[sp].[object_id]
	,	[sp].[stats_id]
	,	[sp].[last_updated]
	,	[sp].[rows]
	,	[sp].[rows_sampled]
	,	[sp].[steps]
	,	[sp].[unfiltered_rows]
	,	[sp].[modification_counter]
	,	[sp].[node_id]
	,	[sp].[first_child]
	,	[sp].[next_sibling]
	,	[sp].[left_boundary]
	,	[sp].[right_boundary]
	,	[sp].[partition_number]
	FROM
		[dbo].[MyStatsView]																	AS [v]
	CROSS APPLY [sys].[dm_db_stats_properties_internal]([v].[object_id], [v].[stats_id]) AS [sp]
	WHERE
		[v].[sh_name]		= 'dbo'
		AND [v].[tb_name]	= 'FactSalesParts'
		AND [v].[st_name]	= 'MyStatsOnPart_01'
	ORDER BY
		[sp].[partition_number]
	,	[sp].[node_id];