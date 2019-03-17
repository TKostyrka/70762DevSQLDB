	USE [STAT]
	GO

--	
------------------------------------------------------

	CREATE PARTITION FUNCTION [PF_DatesYR] (int)  
	AS RANGE LEFT FOR VALUES (20070101, 20080101, 20090101);
	GO

--	
-----------------------------------------------------------

	CREATE PARTITION SCHEME [PS_DatesYR] 
	AS PARTITION PF_DatesYR  
	TO ([PRIMARY],[PRIMARY],[PRIMARY],[PRIMARY])
	GO

-----------------------------------------------------------

	CREATE TABLE [dbo].[FactSalesParts]
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
	
-----------------------------------------------------------
	
	INSERT INTO [dbo].[FactSalesParts]
	(
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
	)
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
	FROM
		[dbo].[FactSales];
	GO
