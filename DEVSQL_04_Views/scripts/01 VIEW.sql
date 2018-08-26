	USE [ContosoRetailDW]
	GO

	CREATE VIEW dbo.View1
	AS
	SELECT
		dd.[FullDateLabel] 
	,	dc.[ChannelName]
	,	ds.[StoreName]
	,	dp.[ProductName]
	,	dr.[PromotionName]
	,	dx.[CurrencyName]
	,	f.[UnitCost]
	,	f.[UnitPrice]
	,	f.[SalesQuantity]
	FROM 
				[dbo].[FactSales]		AS f
	INNER JOIN	[dbo].[DimChannel]		AS dc ON [dc].[ChannelKey]		= [f].[channelKey]
	INNER JOIN	[dbo].[DimStore]		AS ds ON [ds].[StoreKey]		= [f].[StoreKey]
	INNER JOIN	[dbo].[DimProduct]		AS dp ON [dp].[ProductKey]		= [f].[ProductKey]
	INNER JOIN	[dbo].[DimPromotion]	AS dr ON [dr].[PromotionKey]	= [f].[PromotionKey]
	INNER JOIN	[dbo].[DimCurrency]		AS dx ON [dx].[CurrencyKey]		= [f].[CurrencyKey]
	INNER JOIN	[dbo].[DimDate]			AS dd ON [dd].[Datekey]			= [f].[DateKey]
	GO

	--------------------------------------------------------------------------

	CREATE VIEW dbo.View2
	AS
	SELECT
		dd.[FullDateLabel] 
	,	dc.[ChannelName]
	,	ds.[StoreName]
	,	dp.[ProductName]
	,	dr.[PromotionName]
	,	dx.[CurrencyName]
	,	f.[UnitCost]
	,	f.[UnitPrice]
	,	f.[SalesQuantity]
	FROM 
				[dbo].[FactSales]		AS f
	INNER JOIN	[dbo].[DimChannel]		AS dc ON [dc].[ChannelKey]		= [f].[channelKey]
	INNER JOIN	[dbo].[DimStore]		AS ds ON [ds].[StoreKey]		= [f].[StoreKey]
	INNER JOIN	[dbo].[DimProduct]		AS dp ON [dp].[ProductKey]		= [f].[ProductKey]
	INNER JOIN	[dbo].[DimPromotion]	AS dr ON [dr].[PromotionKey]	= [f].[PromotionKey]
	INNER JOIN	[dbo].[DimCurrency]		AS dx ON [dx].[CurrencyKey]		= [f].[CurrencyKey]
	INNER JOIN	[dbo].[DimDate]			AS dd ON [dd].[Datekey]			= [f].[DateKey]

	WHERE 1=1
	AND dd.[CalendarYear] = 2009
	GO

	--------------------------------------------------------------------------

	CREATE VIEW dbo.View3
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
	INNER JOIN	[dbo].[DimPromotion]	AS dr ON [dr].[PromotionKey]	= [f].[PromotionKey]
	INNER JOIN	[dbo].[DimCurrency]		AS dx ON [dx].[CurrencyKey]		= [f].[CurrencyKey]
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

	--------------------------------------------------------------------------

	CREATE VIEW dbo.View4
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
	INNER JOIN	[dbo].[DimPromotion]	AS dr ON [dr].[PromotionKey]	= [f].[PromotionKey]
	INNER JOIN	[dbo].[DimCurrency]		AS dx ON [dx].[CurrencyKey]		= [f].[CurrencyKey]
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