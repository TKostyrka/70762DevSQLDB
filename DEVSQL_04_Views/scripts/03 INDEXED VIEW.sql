	USE [ContosoRetailDW]
	GO

	DROP VIEW IF EXISTS dbo.View10
	DROP VIEW IF EXISTS dbo.View11
	GO
	
	CREATE VIEW dbo.View10
	WITH SCHEMABINDING
	AS
	SELECT
		dd.[CalendarMonthLabel] 
	,	ds.[StoreName]
	,	dp.[BrandName]
	,	COUNT_BIG(*)								AS [RowCount]	
	,	SUM(f.[SalesQuantity]	)					AS [SUM_SalesQuantity]
	FROM 
				[dbo].[FactSales]		AS f
	INNER JOIN	[dbo].[DimChannel]		AS dc ON [dc].[ChannelKey]		= [f].[channelKey]
	INNER JOIN	[dbo].[DimStore]		AS ds ON [ds].[StoreKey]		= [f].[StoreKey]
	INNER JOIN	[dbo].[DimProduct]		AS dp ON [dp].[ProductKey]		= [f].[ProductKey]
	INNER JOIN	[dbo].[DimDate]			AS dd ON [dd].[Datekey]			= [f].[DateKey]

	WHERE 1=1
	AND dd.[CalendarYear]	=	2009
	GROUP BY
		dd.[CalendarMonthLabel] 
	,	ds.[StoreName]
	,	dp.[BrandName]
	GO

	------------------------------------------------------------------------------

	CREATE VIEW dbo.View11
	WITH SCHEMABINDING
	AS
	SELECT
		dd.[CalendarMonthLabel] 
	,	ds.[StoreName]
	,	dp.[BrandName]
	,	COUNT_BIG(*)								AS [RowCount]	
	,	SUM(f.[SalesQuantity]	)					AS [SUM_SalesQuantity]
	FROM 
				[dbo].[FactSales]		AS f
	INNER JOIN	[dbo].[DimChannel]		AS dc ON [dc].[ChannelKey]		= [f].[channelKey]
	INNER JOIN	[dbo].[DimStore]		AS ds ON [ds].[StoreKey]		= [f].[StoreKey]
	INNER JOIN	[dbo].[DimProduct]		AS dp ON [dp].[ProductKey]		= [f].[ProductKey]
	INNER JOIN	[dbo].[DimDate]			AS dd ON [dd].[Datekey]			= [f].[DateKey]

	WHERE 1=1
	AND dd.[CalendarYear]	=	2009
	GROUP BY
		dd.[CalendarMonthLabel] 
	,	ds.[StoreName]
	,	dp.[BrandName]
	GO

	------------------------------------------------------------------------------

	CREATE UNIQUE CLUSTERED INDEX IX_View11
	ON dbo.View11([CalendarMonthLabel], [StoreName], [BrandName])

	------------------------------------------------------------------------------

	SET STATISTICS TIME ON
	SET STATISTICS IO ON

	-- SSMS: Include Actual Execution Plan (Ctrl + M)

		SELECT *
		FROM dbo.View10

		SELECT *
		FROM dbo.View11 WITH (NOEXPAND)

---------------------------------

		SELECT *
		FROM sys.[views] AS v
		WHERE v.name IN ('View10', 'View11') 

		SELECT *
		FROM sys.[indexes] AS i
		WHERE i.name = 'IX_View11'

-----------------------------------
--	https://sqlperformance.com/2015/12/sql-performance/noexpand-hints