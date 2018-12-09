
	USE [CCI]
	GO

-----------------------------------------------------------

	DROP PROCEDURE IF EXISTS #RowCount
	GO

	CREATE PROCEDURE #RowCount
	AS
	BEGIN

	SELECT
		[name]			= 'FactSales_OnYR'
	,	[state_desc]	= NULL
	,	[rg_count]		= NULL
	,	[total_rows]	= COUNT(*)
	,	[deleted_rows]	= NULL
	FROM
		[dbo].[FactSales_OnYR] AS [f]

	UNION ALL 

	SELECT
		[name]			= [t].[name]
	,	[state_desc]	= [v].[state_desc]
	,	[rg_count]		= COUNT(*)
	,	[total_rows]	= SUM([v].[total_rows])
	,	[deleted_rows]	= SUM([v].[deleted_rows])
	FROM
		[sys].[tables]												AS [t]
	INNER JOIN [sys].[dm_db_column_store_row_group_physical_stats] AS [v] ON [v].[object_id] = [t].[object_id]
	WHERE
		1				= 1
		AND [t].[name]	= 'FactSales_OnYR'
	GROUP BY
		[t].[name]
	,	[v].[state_desc]
	ORDER BY
		1

	END
	GO

	EXEC #RowCount
	GO

-----------------------------------------------------------

	DROP PROCEDURE IF EXISTS #GetRowGroups
	GO

	CREATE PROCEDURE #GetRowGroups
	AS
	BEGIN

		SELECT
			[t].[name]
		,	[i].[name]
		,	[i].[type_desc]
		,	[v].[object_id]
		,	[v].[index_id]
		,	[v].[partition_number]
		,	[v].[row_group_id]
		,	[v].[delta_store_hobt_id]
		,	[v].[state_desc]
		,	[v].[total_rows]
		,	[v].[deleted_rows]
		,	[v].[trim_reason_desc]
		,	[v].[transition_to_compressed_state_desc]
		FROM
			[sys].[tables]											   AS [t]
		INNER JOIN [sys].[indexes]									   AS [i] ON [i].[object_id] = [t].[object_id]
		INNER JOIN [sys].[dm_db_column_store_row_group_physical_stats] AS [v] ON [v].[object_id] = [t].[object_id]
																					AND [v].[index_id] = [i].[index_id]
		WHERE
			1 = 1
			AND [t].[name] = 'FactSales_OnYR'
		ORDER BY
			[t].[name]
		,	[i].[name]
		,	[i].[type_desc]

	END

-----------------------------------------------------------

	ALTER INDEX [CCI_FactSales_OnYR]
	ON [dbo].[FactSales_OnYR]
	REBUILD

	EXEC #RowCount
	GO
	
----------------------------------------------------------------------------------------------------------------------
--	DML DELETE
----------------------------------------------------------------------------------------------------------------------
	
	DELETE TOP (10) f FROM [dbo].[FactSales_OnYR] AS f WHERE [f].[DateKey] = 20070201
	DELETE TOP (10) f FROM [dbo].[FactSales_OnYR] AS f WHERE [f].[DateKey] = 20080201
	DELETE TOP (10) f FROM [dbo].[FactSales_OnYR] AS f WHERE [f].[DateKey] = 20090201
	GO

	EXEC #RowCount
	EXEC #GetRowGroups
	GO

	ALTER INDEX [CCI_FactSales_OnYR]
	ON [dbo].[FactSales_OnYR]
	REBUILD

	EXEC #RowCount
	EXEC #GetRowGroups
	GO

----------------------------------------------------------------------------------------------------------------------
--	DML INSERT
----------------------------------------------------------------------------------------------------------------------

	INSERT	[dbo].[FactSales_OnYR]
	(
		[SalesKey]
	,	[DateKey]
	,	[channelKey]
	,	[StoreKey]
	,	[ProductKey]
	,	[PromotionKey]
	,	[UnitCost]
	,	[UnitPrice]
	,	[SalesQuantity]
	,	[DiscountQuantity]
	,	[DiscountAmount]
	)
	VALUES
		( -1	,	20070101, 1, 116,	2360,	2, 101.9600,	199.9900,	4, 0, 0.0000)
	,	( -1	,	20070101, 1, 40,	928,	2, 17.3300,		33.9900,	4, 0, 0.0000)
	,	( -1	,	20080101, 1, 193,	2439,	2, 5.0900,		9.9900,		4, 0, 0.0000)
	,	( -1	,	20080101, 1, 85,	332,	2, 111.6500,	219.0000,	4, 0, 0.0000)
	,	( -1	,	20090101, 1, 124,	1962,	2, 66.2700,		129.9900,	4, 0, 0.0000)
	,	( -1	,	20090101, 1, 172,	1106,	2, 148.0800,	322.0000,	4, 0, 0.0000)
	,	( -1	,	20100101, 1, 105,	2023,	2, 50.9800,		99.9900,	4, 0, 0.0000)
	,	( -1	,	20100101, 1, 66,	229,	2, 152.9000,	299.9000,	4, 0, 0.0000)
	,	( -1	,	20110101, 1, 103,	743,	2, 6.6000,		12.9500,	4, 0, 0.0000)
	,	( -1	,	20110101, 1, 44,	1284,	2, 12.7400,		24.9900,	4, 0, 0.0000)
	;

	EXEC #RowCount
	EXEC #GetRowGroups
	GO
	
-----------------------------------------------------------

	ALTER INDEX [CCI_FactSales_OnYR]
	ON [dbo].[FactSales_OnYR]
	REBUILD

	EXEC #RowCount
	EXEC #GetRowGroups
	GO

----------------------------------------------------------------------------------------------------------------------
--	DML UPDATE
----------------------------------------------------------------------------------------------------------------------

	UPDATE [dbo].[FactSales_OnYR]
	SET [DiscountAmount] = 100
	WHERE [SalesKey] = -1

	EXEC #RowCount
	EXEC #GetRowGroups
	GO

--	REORGANIZE
-----------------------------------------------------------

	ALTER INDEX [CCI_FactSales_OnYR]
	ON [dbo].[FactSales_OnYR]
	REORGANIZE

	EXEC #RowCount
	EXEC #GetRowGroups
	GO
	
--	REORGANIZE + COMPRESS_ALL_ROW_GROUPS
-----------------------------------------------------------

	ALTER INDEX [CCI_FactSales_OnYR]
	ON [dbo].[FactSales_OnYR]
	REORGANIZE WITH (COMPRESS_ALL_ROW_GROUPS = ON)

	EXEC #RowCount
	EXEC #GetRowGroups
	GO

--	REBUILD	
-----------------------------------------------------------

	ALTER INDEX [CCI_FactSales_OnYR]
	ON [dbo].[FactSales_OnYR]
	REBUILD

	EXEC #RowCount
	EXEC #GetRowGroups
	GO