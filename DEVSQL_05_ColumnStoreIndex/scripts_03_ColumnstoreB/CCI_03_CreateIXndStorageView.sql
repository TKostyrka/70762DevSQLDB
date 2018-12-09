
	USE [CCI]
	GO

-----------------------------------------------------------
	
	DROP VIEW IF EXISTS [dbo].[MyStorageView]
	GO

	CREATE VIEW [dbo].[MyStorageView]
	AS
	SELECT
		[t].[name]		AS [TableName]
	,	[s].[name]		AS [SchemaName]
	,	[i].[name]		AS [IndexName]
	,	[i].[type_desc] AS [IndexType]
	,	[PartitionNbr]	=	COUNT(DISTINCT p.[partition_number])
	,   [TotalSpaceMB]	=	CAST(ROUND(( ( SUM([a].[total_pages]) * 8 ) / 1024.00 ), 2) AS NUMERIC(36, 2))
	,   [UsedSpaceMB]	=	CAST(ROUND(( ( SUM([a].[used_pages]) * 8 ) / 1024.00 ), 2) AS NUMERIC(36, 2))
	FROM
				[sys].[tables]				AS [t]
	INNER JOIN	[sys].[schemas]				AS [s]	ON [t].[schema_id]	= [s].[schema_id]
	INNER JOIN	[sys].[indexes]				AS [i]	ON [t].[object_id]	= [i].[object_id]
	INNER JOIN	[sys].[partitions]			AS [p]	ON [i].[object_id]	= [p].[object_id]       
													AND [i].[index_id] = [p].[index_id]
	INNER JOIN	[sys].[allocation_units]	AS [a]  ON [p].[partition_id] = [a].[container_id]

	WHERE 1=1
	GROUP BY
		[t].[name]
	,   [s].[name]
	,	[i].[name]
	,	i.[type_desc];
	GO

	SELECT *
	FROM [dbo].[MyStorageView]

--	CREATE CLUSTERED CI
-----------------------------------------------------------

	DROP INDEX IF EXISTS [CCI_FactSales_OnYR]	ON [dbo].[FactSales_OnYR];
	GO
		
	CREATE CLUSTERED COLUMNSTORE INDEX [CCI_FactSales_OnYR] 
	ON [dbo].[FactSales_OnYR]
	GO
	
	SELECT *
	FROM [dbo].[MyStorageView]
	GO

--	CREATE NON-CLUSTERED CI
-----------------------------------------------------------

	DROP INDEX IF EXISTS [NCI_FactSales_OnMT]	ON [dbo].[FactSales_OnMT];
	GO
		
	CREATE NONCLUSTERED COLUMNSTORE INDEX [NCI_FactSales_OnMT]
	ON [dbo].[FactSales_OnMT]
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
	);
	GO
	
	SELECT *
	FROM [dbo].[MyStorageView]
	GO


--	MIX
-----------------------------------------------------------
	
	DROP INDEX IF EXISTS [CRI_FactSales_PartitionedYr]					ON [dbo].[FactSales];
	DROP INDEX IF EXISTS [NRI_FactSales_PartitionedMt1]					ON [dbo].[FactSales];
	DROP INDEX IF EXISTS [NRI_FactSales_PartitionedMt2_Include5Cols]	ON [dbo].[FactSales];
	DROP INDEX IF EXISTS [NCI_FactSales]								ON [dbo].[FactSales];
	GO

	--	A columnstore index on a partitioned table must be partition-aligned with the base table

	CREATE CLUSTERED INDEX [CRI_FactSales_PartitionedYr] 
	ON [dbo].[FactSales]([SalesKey])
	;

	CREATE NONCLUSTERED INDEX [NRI_FactSales_PartitionedMt1] 
	ON [dbo].[FactSales]([SalesKey])
	ON [PS_DatesMT]([DateKey])
	;

	CREATE NONCLUSTERED INDEX [NRI_FactSales_PartitionedMt2_Include5Cols] 
	ON [dbo].[FactSales]([SalesKey])
	INCLUDE
	(
		[DateKey]		
	,	[StoreKey]			
	,	[ProductKey]		
	,	[PromotionKey]		
	,	[UnitCost]			
	)
	ON [PS_DatesYR]([DateKey])
	;

	CREATE NONCLUSTERED COLUMNSTORE INDEX [NCI_FactSales] 
	ON [dbo].[FactSales]	
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
	GO

	SELECT *
	FROM [dbo].[MyStorageView]
	;
