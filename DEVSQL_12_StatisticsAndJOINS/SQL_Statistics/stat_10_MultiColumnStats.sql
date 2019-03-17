	USE [STAT]
	GO

--	Include Actual Execution Plan (Ctrl+M)
--	Check ActualNumberOfRows vs. EstimatedNumberOfRows on TableScan Operator ([FactSalesParts])
-----------------------------------------------------------------------

	DROP STATISTICS [dbo].[FactSalesParts].[MyStatsOnPart_01]
	DROP STATISTICS [dbo].[FactSalesParts].[MyStatsOnPart_02]
	GO

-----------------------------------------------------------------------
	
	CREATE STATISTICS [MyStatsOnPart_01] ON [dbo].[FactSalesParts]([StoreKey])
	CREATE STATISTICS [MyStatsOnPart_02] ON [dbo].[FactSalesParts]([ProductKey])
	GO

-----------------------------------------------------------------------

	DBCC DROPCLEANBUFFERS
	DBCC FREEPROCCACHE
	GO

	SELECT [StoreKey], [ProductKey], COUNT(*)
	FROM [STAT].[dbo].[FactSalesParts]
	WHERE 1=1
	AND [StoreKey]	= 199
	AND [ProductKey]	= 600
	GROUP BY [StoreKey], [ProductKey]
	GO

-----------------------------------------------------------------------

	DROP STATISTICS [dbo].[FactSalesParts].[MyStatsOnPart_01]
	DROP STATISTICS [dbo].[FactSalesParts].[MyStatsOnPart_02]
	GO

	CREATE STATISTICS [MyStatsOnPart_03] ON [dbo].[FactSalesParts]([StoreKey], [ProductKey])
	GO

-----------------------------------------------------------------------

	DBCC DROPCLEANBUFFERS
	DBCC FREEPROCCACHE
	GO

	SELECT [StoreKey], [ProductKey], COUNT(*)
	FROM [STAT].[dbo].[FactSalesParts]
	WHERE 1=1
	AND [StoreKey]	= 199
	AND [ProductKey]	= 600
	GROUP BY [StoreKey], [ProductKey]
	GO