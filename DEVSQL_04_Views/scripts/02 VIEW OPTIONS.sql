	USE [ContosoRetailDW]
	GO

	DROP VIEW IF EXISTS dbo.View5
	DROP VIEW IF EXISTS dbo.View6
	GO
	
	CREATE VIEW dbo.View5
	WITH SCHEMABINDING
	AS
	SELECT
		dd.[CalendarMonthLabel] 
	,	ds.[StoreName]
	,	AVG(f.[UnitCost]		)	AS [AVG_UnitCost]	
	,	AVG(f.[UnitPrice]		)	AS [AVG_UnitPrice]	
	,	SUM(f.[SalesQuantity]	)	AS [SUM_SalesQuantity]
	FROM 
				[dbo].[FactSales]		AS f
	INNER JOIN	[dbo].[DimChannel]		AS dc ON [dc].[ChannelKey]		= [f].[channelKey]
	INNER JOIN	[dbo].[DimStore]		AS ds ON [ds].[StoreKey]		= [f].[StoreKey]
	INNER JOIN	[dbo].[DimProduct]		AS dp ON [dp].[ProductKey]		= [f].[ProductKey]
	INNER JOIN	[dbo].[DimDate]			AS dd ON [dd].[Datekey]			= [f].[DateKey]

	WHERE 1=1
	AND dd.[CalendarYear]	=	2009
	AND dc.[ChannelName]	=	'Store'
	AND ds.[ZipCode]		=	97001
	AND dp.[BrandName]		=	'Contoso'
	GROUP BY
		dd.[CalendarMonthLabel] 
	,	ds.[StoreName]
	GO

	DROP TABLE [dbo].[DimChannel]
	GO

	-----------------------------------------------------------------------------------

	CREATE VIEW dbo.View6
	WITH ENCRYPTION
	AS
	SELECT
		dd.[CalendarMonthLabel] 
	,	ds.[StoreName]
	,	AVG(f.[UnitCost]		)	AS [AVG_UnitCost]	
	,	AVG(f.[UnitPrice]		)	AS [AVG_UnitPrice]	
	,	SUM(f.[SalesQuantity]	)	AS [SUM_SalesQuantity]
	FROM 
				[dbo].[FactSales]		AS f
	INNER JOIN	[dbo].[DimChannel]		AS dc ON [dc].[ChannelKey]		= [f].[channelKey]
	INNER JOIN	[dbo].[DimStore]		AS ds ON [ds].[StoreKey]		= [f].[StoreKey]
	INNER JOIN	[dbo].[DimProduct]		AS dp ON [dp].[ProductKey]		= [f].[ProductKey]
	INNER JOIN	[dbo].[DimDate]			AS dd ON [dd].[Datekey]			= [f].[DateKey]

	WHERE 1=1
	AND dd.[CalendarYear]	=	2009
	AND dc.[ChannelName]	=	'Store'
	AND ds.[ZipCode]		=	97001
	AND dp.[BrandName]		=	'Contoso'
	GROUP BY
		dd.[CalendarMonthLabel] 
	,	ds.[StoreName]
	GO

-----------------------------------------------------------------------------------

	SELECT v.name, c.text
	FROM	
				sys.[views]		AS v 
	INNER JOIN	sys.syscomments AS c ON v.[object_id] = c.id
	WHERE v.name IN ('View5','View6')