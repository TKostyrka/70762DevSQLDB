	USE [FileAndParts]
	GO

--	CREATE VIEW tableData
-----------------------------------------------------------
	
	DROP VIEW IF EXISTS [dbo].[v_TableDetails]
	GO

	CREATE VIEW [dbo].[v_TableDetails]
	AS	
	SELECT
		[s_name]	= [s].[name]
	,	[t_name]	= [t].[name]
	,	[i_name]	= [i].[name]
	,	[d].[data_space_id]
	,	[d].[type_desc]
	,	[d].[name]
	,	[p].[partition_id]
	,	[p].[object_id]
	,	[p].[index_id]
	,	[p].[partition_number]
	,	[p].[rows]
	,	[p].[data_compression_desc]
	FROM
		[sys].[schemas]				AS [s]
	INNER JOIN [sys].[tables] AS [t] ON [t].[schema_id]		= [s].[schema_id]
	INNER JOIN [sys].[indexes] AS [i] ON [i].[object_id] = [t].[object_id]
	INNER JOIN [sys].[data_spaces] AS [d] ON [d].[data_space_id] = [i].[data_space_id]
	INNER JOIN [sys].[partitions] AS [p] ON [p].[object_id] = [t].[object_id];
	GO

--	CREATE Table ON [FastFG] Filegroup
-----------------------------------------------------------

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
	INTO [dbo].[FactSales] ON [FastFG]
	FROM
		[ContosoRetailDW].[dbo].[FactSales];

--	table info
-----------------------------------------------------------

	SELECT *
	FROM [dbo].[v_TableDetails]

	SELECT *
	FROM [dbo].[v_FilesAndGroups]
