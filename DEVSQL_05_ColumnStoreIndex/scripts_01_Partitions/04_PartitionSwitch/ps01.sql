
	-------------------------------------------------------
	
		USE [master]
		GO
		DROP DATABASE IF EXISTS [PSwitch]
		GO	
		CREATE DATABASE [PSwitch]
		GO
		USE [PSwitch]
		GO

	-------------------------------------------------------

		CREATE PARTITION FUNCTION [PF_DatesYR] (INT)  
		AS RANGE RIGHT FOR VALUES (20080101, 20090101, 20100101);
		GO

		CREATE PARTITION SCHEME [PS_DatesYR_OnSlow] 
		AS PARTITION PF_DatesYR  
		ALL TO ([PRIMARY])
		GO

	-------------------------------------------------------

		DROP TABLE IF EXISTS [dbo].[FactSalesSrc]
		DROP TABLE IF EXISTS [dbo].[FactSalesTrg]
		GO

		CREATE TABLE [dbo].[FactSalesSrc]
		(
			[SalesKey]			[int] IDENTITY(1,1) NOT NULL
		,	[DateKey]			[int] NOT NULL
		,	[channelKey]		[int] NOT NULL
		,	[StoreKey]			[int] NOT NULL
		,	[ProductKey]		[int] NOT NULL
		,	[PromotionKey]		[int] NOT NULL
		,	[UnitCost]			[money] NOT NULL
		,	[UnitPrice]			[money] NOT NULL
		,	[SalesQuantity]		[int] NOT NULL
		,	[DiscountQuantity]	[int] NULL
		,	[DiscountAmount]	[money] NULL
		) ON [PS_DatesYR_OnSlow]([DateKey])
		GO

		CREATE TABLE [dbo].[FactSalesTrg]
		(
			[SalesKey]			[int] IDENTITY(1,1) NOT NULL
		,	[DateKey]			[int] NOT NULL
		,	[channelKey]		[int] NOT NULL
		,	[StoreKey]			[int] NOT NULL
		,	[ProductKey]		[int] NOT NULL
		,	[PromotionKey]		[int] NOT NULL
		,	[UnitCost]			[money] NOT NULL
		,	[UnitPrice]			[money] NOT NULL
		,	[SalesQuantity]		[int] NOT NULL
		,	[DiscountQuantity]	[int] NULL
		,	[DiscountAmount]	[money] NULL
		) ON [PS_DatesYR_OnSlow]([DateKey])
		GO
	
		INSERT INTO	[dbo].[FactSalesSrc]
		(
			[DateKey]			
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
		SELECT
			[DateKey] = ISNULL(CAST(CONVERT(VARCHAR, [DateKey], 112) AS INT), -1)
		,	[channelKey]
		,	[StoreKey]
		,	[ProductKey]
		,	[PromotionKey]
		,	[UnitCost]
		,	[UnitPrice]
		,	[SalesQuantity]
		,	[DiscountQuantity]
		,	[DiscountAmount]	
		FROM	[ContosoRetailDW].[dbo].[FactSales]
		GO

		INSERT INTO	[dbo].[FactSalesTrg]
		(
			[DateKey]			
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
		SELECT
			[DateKey] = [DateKey] + 10000
		,	[channelKey]
		,	[StoreKey]
		,	[ProductKey]
		,	[PromotionKey]
		,	[UnitCost]
		,	[UnitPrice]
		,	[SalesQuantity]
		,	[DiscountQuantity]
		,	[DiscountAmount]
		FROM [dbo].[FactSalesSrc]
		WHERE [DateKey] >= 20090101

	-------------------------------------------------------

		SELECT LEFT(DateKey,4), COUNT(*)
		FROM [dbo].[FactSalesSrc] AS f
		GROUP BY LEFT(DateKey,4)
		;

		SELECT s.name, t.name, i.name, p.partition_number, p.rows
		FROM		sys.schemas		AS s
		INNER JOIN	sys.tables		AS t	ON	s.[schema_id]	= t.[schema_id]
		INNER JOIN	sys.indexes		AS i	ON	t.[object_id]	= i.[object_id]
		INNER JOIN	sys.partitions	AS p	ON	i.[object_id]	= p.[object_id]
											AND p.[index_id]	= i.[index_id]
		WHERE 1=1
		AND s.name = 'dbo'
		AND t.name LIKE 'FactSales%'
		ORDER BY t.name, p.partition_number
		GO

	-------------------------------------------------------

		ALTER TABLE [dbo].[FactSalesSrc]
		SWITCH PARTITION 1
		TO [dbo].[FactSalesTrg] PARTITION 1
		GO

	-------------------------------------------------------

		SELECT s.name, t.name, i.name, p.partition_number, p.rows
		FROM		sys.schemas		AS s
		INNER JOIN	sys.tables		AS t	ON	s.[schema_id]	= t.[schema_id]
		INNER JOIN	sys.indexes		AS i	ON	t.[object_id]	= i.[object_id]
		INNER JOIN	sys.partitions	AS p	ON	i.[object_id]	= p.[object_id]
											AND p.[index_id]	= i.[index_id]
		WHERE 1=1
		AND s.name = 'dbo'
		AND t.name LIKE 'FactSales%'
		ORDER BY t.name, p.partition_number
		GO

	-------------------------------------------------------

		ALTER TABLE [dbo].[FactSalesSrc]
		SWITCH PARTITION 2
		TO [dbo].[FactSalesTrg] PARTITION 2
		GO
