	
	USE [master]
	GO
	DROP DATABASE IF EXISTS [PartsSlideW]
	GO
	CREATE DATABASE [PartsSlideW]
	GO
	USE [PartsSlideW]
	GO

--	PF/PS
------------------------------------------------------

	CREATE PARTITION FUNCTION [PF_DatesYR] (INT)  
	AS RANGE RIGHT FOR VALUES (20070701, 20080101, 20080701, 20090101, 20090701);
	GO

	CREATE PARTITION SCHEME [PS_DatesYR]
	AS PARTITION [PF_DatesYR]  
	ALL TO ([PRIMARY])
	GO

------------------------------------------------------
	
	DROP TABLE IF EXISTS [dbo].[FactSalesArch]
	DROP TABLE IF EXISTS [dbo].[FactSalesTemp]
	DROP TABLE IF EXISTS [dbo].[FactSales]
	GO

	CREATE TABLE [dbo].[FactSalesArch]
	(
		[SalesKey]		[int]	NOT NULL
	,	[DateKey]		[int]	NOT NULL
	,	[StoreKey]		[int]	NOT NULL
	,	[UnitCost]		[money] NOT NULL
	,	[UnitPrice]		[money] NOT NULL
	,	[SalesQuantity] [int]	NOT NULL
	)
	GO

	CREATE TABLE [dbo].[FactSalesTemp]
	(
		[SalesKey]		[int]	IDENTITY(1,1) NOT NULL
	,	[DateKey]		[int]	NOT NULL
	,	[StoreKey]		[int]	NOT NULL
	,	[UnitCost]		[money] NOT NULL
	,	[UnitPrice]		[money] NOT NULL
	,	[SalesQuantity] [int]	NOT NULL
	)
	GO

	CREATE TABLE [dbo].[FactSales]
	(
		[SalesKey]		[int]	IDENTITY(1,1) NOT NULL
	,	[DateKey]		[int]	NOT NULL
	,	[StoreKey]		[int]	NOT NULL
	,	[UnitCost]		[money] NOT NULL
	,	[UnitPrice]		[money] NOT NULL
	,	[SalesQuantity] [int]	NOT NULL
	) ON [PS_DatesYR]([DateKey])
	GO

------------------------------------------------------
	
	INSERT INTO [dbo].[FactSales]
	(
		[DateKey]		
	,	[StoreKey]		
	,	[UnitCost]		
	,	[UnitPrice]		
	,	[SalesQuantity] 
	)
	SELECT
		[DateKey] = ISNULL(CAST(CONVERT(VARCHAR, [DateKey], 112) AS INT), -1)
	,	[StoreKey]
	,	[UnitCost]
	,	[UnitPrice]
	,	[SalesQuantity]
	FROM
		[ContosoRetailDW].[dbo].[FactSales]
	;

	INSERT INTO [dbo].[FactSalesTemp]
	(
		[DateKey]		
	,	[StoreKey]		
	,	[UnitCost]		
	,	[UnitPrice]		
	,	[SalesQuantity] 
	)
	SELECT
		[DateKey] = [DateKey] + 10000
	,	[StoreKey]
	,	[UnitCost]
	,	[UnitPrice]
	,	[SalesQuantity]
	FROM
		[dbo].[FactSales]
	WHERE 1=1
	AND [DateKey] >= 20090101 
	AND [DateKey] < 20090701
	;