	USE [FileAndParts]
	GO

--	DROP Yr PARTITION SCHEMAS/FUNCS if exist
-----------------------------------------------------------
	
	DROP TABLE IF EXISTS [dbo].[FactSales_OnFastParSch]
	;

	IF EXISTS (	SELECT 1
				FROM [sys].[partition_schemes] AS [ps]
				WHERE [ps].[name] = 'PS_DatesYR_OnSlow'
				)	
	DROP PARTITION SCHEME [PS_DatesYR_OnSlow]

	IF EXISTS (	SELECT 1
				FROM [sys].[partition_schemes] AS [ps]
				WHERE [ps].[name] = 'PS_DatesYR_OnFast'
				)	
	DROP PARTITION SCHEME [PS_DatesYR_OnFast]

	IF EXISTS (	SELECT 1
				FROM [sys].[partition_functions] AS [pf]
				WHERE [pf].[name] = 'PF_DatesYR'
				)
	DROP PARTITION FUNCTION [PF_DatesYR]

--	CREATE PARTITION FUNCTION
-----------------------------------------------------------

	CREATE PARTITION FUNCTION [PF_DatesYR] (int)  
	AS RANGE LEFT FOR VALUES (20070101, 20080101, 20090101);
	GO

--	CREATE PARTITION SCHEMEs (on Slow FG, on Fast FG)
-----------------------------------------------------------

	CREATE PARTITION SCHEME [PS_DatesYR_OnSlow] 
	AS PARTITION PF_DatesYR  
	TO ([SlowFG],[SlowFG],[SlowFG],[SlowFG])
	GO

	CREATE PARTITION SCHEME [PS_DatesYR_OnFast]  
	AS PARTITION PF_DatesYR  
	TO ([FastFG],[FastFG],[FastFG],[FastFG])
	GO

--	CREATE TABLE in [PS_DatesYR_OnFast] SCHEME, Load data
-----------------------------------------------------------

	CREATE TABLE [dbo].[FactSales_OnFastParSch]
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
	) ON [PS_DatesYR_OnFast]([DateKey])
	;
	GO

	INSERT INTO [dbo].[FactSales_OnFastParSch]
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

--	table data
-----------------------------------------------------------

	SELECT *
	FROM [dbo].[v_TableDetails]