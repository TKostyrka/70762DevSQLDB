	USE [CCI]
	GO

-----------------------------------------------------------
	
	SELECT
		[t].[name]		AS [TableName]
	,	[s].[name]		AS [SchemaName]
	,	[i].[name]		AS [IndexName]
	,	[i].[type_desc] AS [IndexType]
	,	[PartitionNbr]	=	COUNT(DISTINCT p.[partition_number])
	,	[RowGroupNbr]	= COUNT(v.[row_group_id])
	FROM
				[sys].[tables]				AS [t]
	INNER JOIN	[sys].[schemas]				AS [s]	ON [t].[schema_id]	= [s].[schema_id]
	INNER JOIN	[sys].[indexes]				AS [i]	ON [t].[object_id]	= [i].[object_id]
	INNER JOIN	[sys].[partitions]			AS [p]	ON [i].[object_id]	= [p].[object_id]       
													AND [i].[index_id] = [p].[index_id]
	LEFT JOIN [sys].[dm_db_column_store_row_group_physical_stats] AS [v] ON [t].[object_id] = [v].[object_id]
																			 AND [v].[index_id] = [i].[index_id]
																			 AND [v].[partition_number] = [p].[partition_number]
	WHERE 1=1
	AND t.[name] = 'FactSales'
	GROUP BY
		[t].[name]
	,   [s].[name]
	,	[i].[name]
	,	i.[type_desc];
	GO


-----------------------------------------------------------

	ALTER INDEX ALL 
	ON dbo.[FactSales]
	REBUILD
	GO

		SELECT
			[t].[name]
		,	[i].[name]
		,	[i].[type_desc]
		,	COUNT(*)
		FROM
			[sys].[schemas]				AS [s]
		INNER JOIN [sys].[tables] AS [t] ON [t].[schema_id]		= [s].[schema_id]
		INNER JOIN [sys].[indexes] AS [i] ON [i].[object_id] = [t].[object_id]
		INNER JOIN [sys].[partitions] AS [p] ON [p].[index_id] = [i].[index_id]
												AND [p].[object_id] = [i].[object_id]
		GROUP BY
			[t].[name]
		,	[i].[name]
		,	[i].[type_desc];

	--	CRI_FactSales_PartitionedYr					CLUSTERED					1
	--	NCI_FactSales								NONCLUSTERED COLUMNSTORE	1
	--	NRI_FactSales_PartitionedMt1				NONCLUSTERED				37
	--	NRI_FactSales_PartitionedMt2_Include5Cols	NONCLUSTERED				4
	
----------------------------------------------------------------------------------------------------------------------
--	small, selective query
----------------------------------------------------------------------------------------------------------------------

	--	RSI
	-----------------------------------------------------------

		DBCC DROPCLEANBUFFERS
		DBCC FREEPROCCACHE
		GO

		SET STATISTICS IO	ON;
		SET STATISTICS TIME ON;
		GO

		SELECT *
		FROM [dbo].[FactSales] AS f WITH (INDEX = CRI_FactSales_PartitionedYr)
		WHERE [f].[SalesKey] = 2977504

	--	CSI
	-----------------------------------------------------------

		DBCC DROPCLEANBUFFERS
		DBCC FREEPROCCACHE
		GO

		SET STATISTICS IO	ON;
		SET STATISTICS TIME ON;
		GO

		SELECT *
		FROM [dbo].[FactSales] AS f WITH (INDEX = NCI_FactSales)
		WHERE [f].[SalesKey] = 2977504
	
----------------------------------------------------------------------------------------------------------------------
--	OLAP query
----------------------------------------------------------------------------------------------------------------------

	--	RSI
	-----------------------------------------------------------

		DBCC DROPCLEANBUFFERS
		DBCC FREEPROCCACHE
		GO

		SET STATISTICS IO	ON;
		SET STATISTICS TIME ON;
		GO

		SELECT [f].[channelKey], SUM([f].[SalesQuantity])
		FROM [dbo].[FactSales] AS f WITH (INDEX = CRI_FactSales_PartitionedYr)
		GROUP BY [f].[channelKey]

	--	CSI
	-----------------------------------------------------------

		DBCC DROPCLEANBUFFERS
		DBCC FREEPROCCACHE
		GO

		SET STATISTICS IO	ON;
		SET STATISTICS TIME ON;
		GO

		SELECT [f].[channelKey], SUM([f].[SalesQuantity])
		FROM [dbo].[FactSales] AS f WITH (INDEX = NCI_FactSales)
		GROUP BY [f].[channelKey]