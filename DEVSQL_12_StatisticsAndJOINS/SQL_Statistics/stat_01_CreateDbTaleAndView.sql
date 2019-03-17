	USE [master];
	GO

	DROP DATABASE IF EXISTS [STAT]
	GO

	CREATE DATABASE [STAT]
	GO

	USE [STAT]
	GO

--	GetData -> [dbo].[FactSales]
------------------------------------------------------

	DROP TABLE IF EXISTS [dbo].[FactSales]
	GO

	SELECT
		[SalesKey]
	,	[DateKey] = ISNULL(CAST(CONVERT(VARCHAR, [DateKey], 112) AS INT), -1)
	,	[channelKey]
	,	[StoreKey]
	,	[ProductKey]
	,	[PromotionKey]
	,	[UnitCost]
	,	[UnitPrice]
	,	[SalesQuantity]
	,	[DiscountQuantity]
	,	[DiscountAmount]	
	INTO [dbo].[FactSales]
	FROM
		[ContosoRetailDW].[dbo].[FactSales];
	GO

--	CREATE [dbo].[MyStatsView]
------------------------------------------------------
	
	DROP VIEW IF EXISTS [dbo].[MyStatsView]
	GO

	CREATE VIEW [dbo].[MyStatsView]
	AS
	SELECT
		[c].[object_id]
	,	[sh_name] = [s].[name]
	,	[tb_name] = [t].[name]
	,	[st].[stats_id]
	,	[st_name] = [st].[name]
	,	[sc].[stats_column_id]
	,	[co_name] = [c].[name]	
	,	[st].[auto_created]
	,	[st].[user_created]
	,	[st].[is_incremental]	
	FROM
		[sys].[schemas]				 AS [s]
	INNER JOIN [sys].[tables]		 AS [t] ON [t].[schema_id] = [s].[schema_id]
	INNER JOIN [sys].[stats]		 AS [st] ON [st].[object_id] = [t].[object_id]
	INNER JOIN [sys].[stats_columns] AS [sc] ON [st].[stats_id] = [sc].[stats_id]
												AND [st].[object_id] = [sc].[object_id]
	INNER JOIN [sys].[columns]		 AS [c] ON [c].[column_id] = [sc].[column_id]
											   AND [c].[object_id] = [t].[object_id]
	WHERE 1=1
	AND [t].[type] = 'U'
	GO

------------------------------------------------------

	SELECT  *
	FROM [MyStatsView]
	WHERE 1=1
	AND [tb_name] = 'FactSales'
