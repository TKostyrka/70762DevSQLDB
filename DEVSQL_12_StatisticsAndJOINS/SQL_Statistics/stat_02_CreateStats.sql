	USE [STAT]
	GO

--	GetData -> [dbo].[FactSales]
------------------------------------------------------

	SELECT TOP 10
		[f].[StoreKey]
	,	[f].[ProductKey]
	,	[SalesQuantity]		= SUM([f].[SalesQuantity])
	,	[DiscountQuantity]	= SUM([f].[DiscountQuantity])
	FROM
		[dbo].[FactSales] AS [f]
	WHERE
		[f].[SalesKey]
	BETWEEN 1
	AND		1000000
	GROUP BY
		[f].[StoreKey]
	,	[f].[ProductKey]
	ORDER BY 
		[f].[StoreKey]
	,	[f].[ProductKey]
	;

--	AUTO CREATED STATS
------------------------------------------------------

	SELECT  *
	FROM [MyStatsView]
	WHERE 1=1
	AND [tb_name] = 'FactSales'
	GO

--	CREATE PK and NC-RS-IX
------------------------------------------------------

	--	The Query Optimizer creates statistics for indexes on tables or views when the index is created. 
	--	These statistics are created on the key columns of the index. 
	--	IF the index is a filtered index, the Query Optimizer creates filtered statistics on the same subset of rows specified for the filtered index.

	ALTER TABLE [dbo].[FactSales]
	ADD CONSTRAINT PK_SalesKey
	PRIMARY KEY ([SalesKey])
	GO

	CREATE NONCLUSTERED INDEX CRIX_FactSales
	ON [dbo].[FactSales] ( [DateKey],[PromotionKey] )
	GO

--	
------------------------------------------------------

	SELECT  *
	FROM [MyStatsView]
	WHERE 1=1
	AND [tb_name] = 'FactSales'
	GO

--	CREATE STATS
------------------------------------------------------

	CREATE STATISTICS MyStats_01
	ON [dbo].[FactSales]([SalesQuantity])
	GO

	--	When a query predicate contains multiple columns that have cross-column relationships and dependencies, statistics on the multiple columns might improve the query plan. 
	--	Statistics on multiple columns contain cross-column correlation statistics, called densities, that are not available in single-column statistics. 
	--	Densities can improve cardinality estimates when query results depend on data relationships among multiple columns.

	CREATE STATISTICS MyStats_02
	ON [dbo].[FactSales]([SalesQuantity],[DiscountQuantity])
	GO

--	
------------------------------------------------------

	SELECT  *
	FROM [MyStatsView]
	WHERE 1=1
	AND [tb_name] = 'FactSales'
	GO