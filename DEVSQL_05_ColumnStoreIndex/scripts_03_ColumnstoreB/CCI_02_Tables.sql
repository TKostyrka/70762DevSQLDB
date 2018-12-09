
	USE [CCI]
	GO

	DROP TABLE IF EXISTS [dbo].[FactSales_OnYR]
	DROP TABLE IF EXISTS [dbo].[FactSales_OnMT]
	GO

--	CREATE TABLES in YR/MT SCHEME
-----------------------------------------------------------

	CREATE TABLE [dbo].[FactSales_OnYR]
	(
		[SalesKey]			[INT]	NOT NULL
	,	[DateKey]			[INT]	NOT NULL
	,	[channelKey]		[INT]	NOT NULL
	,	[StoreKey]			[INT]	NOT NULL
	,	[ProductKey]		[INT]	NOT NULL
	,	[PromotionKey]		[INT]	NOT NULL
	,	[UnitCost]			[MONEY] NOT NULL
	,	[UnitPrice]			[MONEY] NOT NULL
	,	[SalesQuantity]		[INT]	NOT NULL
	,	[DiscountQuantity]	[INT]	NULL
	,	[DiscountAmount]	[MONEY] NULL
	) ON [PS_DatesYR]([DateKey])
	;
	GO

	CREATE TABLE [dbo].[FactSales_OnMT]
	(
		[SalesKey]			[INT]	NOT NULL
	,	[DateKey]			[INT]	NOT NULL
	,	[channelKey]		[INT]	NOT NULL
	,	[StoreKey]			[INT]	NOT NULL
	,	[ProductKey]		[INT]	NOT NULL
	,	[PromotionKey]		[INT]	NOT NULL
	,	[UnitCost]			[MONEY] NOT NULL
	,	[UnitPrice]			[MONEY] NOT NULL
	,	[SalesQuantity]		[INT]	NOT NULL
	,	[DiscountQuantity]	[INT]	NULL
	,	[DiscountAmount]	[MONEY] NULL
	) ON [PS_DatesMT]([DateKey])
	;
	GO
-----------------------------------------------------------

	INSERT INTO [dbo].[FactSales_OnYR] WITH (TABLOCK)
	SELECT
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
	FROM [dbo].[FactSales]
	;
	GO

	INSERT INTO [dbo].[FactSales_OnMT] WITH (TABLOCK)
	SELECT
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
	FROM [dbo].[FactSales]
	;
	GO

--	stats:
-----------------------------------------------------------	

	SELECT
		[s].[name] AS [s_name]
	,	[t].[name] AS [t_name]
	,	[i].[name] AS [i_name]
	,	[i].[type_desc]
	,	COUNT(*)		AS [partition_cnt]
	,	SUM([p].[rows])	AS [partition_rows]
	FROM
		[sys].[schemas]			  AS [s] (NOLOCK) 
	INNER JOIN [sys].[tables]	  AS [t] (NOLOCK)	ON [t].[schema_id] = [s].[schema_id]
	INNER JOIN [sys].[indexes]	  AS [i] (NOLOCK)	ON [i].[object_id] = [t].[object_id]
	INNER JOIN [sys].[partitions] AS [p] (NOLOCK)	ON [p].[object_id] = [i].[object_id]
													AND [p].[index_id] = [i].[index_id]
	WHERE 1=1
	GROUP BY 	
		[s].[name]
	,	[t].[name]
	,	[i].[name]
	,	[i].[type_desc]
	ORDER BY
		[partition_rows] DESC
	;

-----------------------------------------------------------

	SELECT
		[s].[name]	AS [s_name]
	,	[t].[name]	AS [t_name]
	,	[i].[name]	AS [i_name]
	,	[d].[data_space_id]
	,	[d].[type_desc]
	,	[d].[name]
	,	[p].[partition_id]
	,	[p].[object_id]
	,	[p].[index_id]
	,	[p].[partition_number]
	,	[p].[rows]
	,	[p].[data_compression_desc]
	FROM
				[sys].[schemas]		AS [s]
	INNER JOIN	[sys].[tables]		AS [t] ON [t].[schema_id]		= [s].[schema_id]
	INNER JOIN	[sys].[indexes]		AS [i] ON [i].[object_id]		= [t].[object_id]
	INNER JOIN	[sys].[data_spaces]	AS [d] ON [d].[data_space_id]	= [i].[data_space_id]
	INNER JOIN	[sys].[partitions]	AS [p] ON [p].[object_id]		= [t].[object_id]
	ORDER BY 
		[s].[name]
	,	[t].[name]
	,	[i].[name]
	,	[p].[partition_number]
	GO

