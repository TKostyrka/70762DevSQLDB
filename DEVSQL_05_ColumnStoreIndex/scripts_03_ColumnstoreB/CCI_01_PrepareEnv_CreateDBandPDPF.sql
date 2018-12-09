
--	Recreate DATABASE
-----------------------------------------------------------

	USE [master];
	GO

	DROP DATABASE IF EXISTS [CCI]
	GO

	CREATE DATABASE [CCI]
	GO

	USE [CCI]
	GO

--	CREATE NON-PARTITIONED TABLE:
-----------------------------------------------------------
	
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

--	DROP Yr PARTITION SCHEMAS/FUNCS if exist
-----------------------------------------------------------
	
	DROP TABLE IF EXISTS [dbo].[FactSales_OnPSchYR]
	DROP TABLE IF EXISTS [dbo].[FactSales_OnPSchMT]
	GO

	IF EXISTS (	SELECT 1 FROM [sys].[partition_schemes] AS [ps]	WHERE [ps].[name] = 'PS_DatesMT')	
	DROP PARTITION SCHEME [PS_DatesMT]

	IF EXISTS (	SELECT 1 FROM [sys].[partition_schemes] AS [ps]	WHERE [ps].[name] = 'PS_DatesYR')	
	DROP PARTITION SCHEME [PS_DatesYR]

	IF EXISTS (	SELECT 1 FROM [sys].[partition_functions] AS [pf] WHERE [pf].[name] = 'PF_DatesMT')
	DROP PARTITION FUNCTION [PF_DatesMT]

	IF EXISTS (	SELECT 1 FROM [sys].[partition_functions] AS [pf] WHERE [pf].[name] = 'PF_DatesYR')
	DROP PARTITION FUNCTION [PF_DatesYR]
	GO

--	PF & PS DatesYR
-----------------------------------------------------------

	CREATE PARTITION FUNCTION [PF_DatesYR] (int)  
	AS RANGE LEFT FOR VALUES (20070101, 20080101, 20090101);
	GO

	CREATE PARTITION SCHEME [PS_DatesYR] 
	AS PARTITION PF_DatesYR  
	TO ([PRIMARY],[PRIMARY],[PRIMARY],[PRIMARY])
	GO

--	PF & PS DatesMT
-----------------------------------------------------------

	DROP TABLE IF EXISTS #DistinctDates
	GO

	SELECT
		CAST([DateKey] AS NVARCHAR(8)) AS [DateKeyVC]
	INTO #DistinctDates
	FROM  [dbo].[FactSales]
	WHERE [DateKey] % 100 = 1
	GROUP BY [DateKey]
	ORDER BY [DateKey]
	GO

	DECLARE @DatesString NVARCHAR(MAX)
		,	@FGString NVARCHAR(MAX)
		,	@RowCount INT
		,	@sqlcmd NVARCHAR(MAX)
	;

	SELECT @DatesString = LEFT(a.x, LEN(a.x) - 1)
	FROM
	(
		SELECT [DateKeyVC] + ','
		FROM #DistinctDates
		ORDER BY [DateKeyVC]
		FOR XML PATH ('')
	) AS a(x)
	;

	SELECT @RowCount = COUNT(*) + 1
	FROM #DistinctDates
	;

	--	CREATE FUNCTION
	------------------------------

		SELECT @sqlcmd =
		'
			CREATE PARTITION FUNCTION [PF_DatesMT] (int)  
			AS RANGE LEFT FOR VALUES (' + @DatesString + ')
			;
		'
		PRINT @sqlcmd
		EXEC(@sqlcmd)

	--	CREATE SCHEME
	------------------------------

		SELECT @FGString = REPLICATE(', [PRIMARY]', @RowCount)
		SET @FGString = RIGHT(@FGString, LEN(@FGString)-2)

		SELECT @sqlcmd =
		'
			CREATE PARTITION SCHEME [PS_DatesMT] 
			AS PARTITION [PF_DatesMT] 
			TO (' + @FGString + ')
			;
		'
		PRINT @sqlcmd
		EXEC(@sqlcmd)
		GO

--	CHECK:
-----------------------------------------------------------

	SELECT
		[ps].[name]		AS [PS_name]
	,	[ds].[name]		AS [FG_name]
	,	[pf].[name]		AS [PF_name]
	,	[pf].[type]
	,	[pf].[type_desc]
	,	[prv1].[value]	AS [value_FROM]
	,	[prv2].[value]	AS [value_TO]
	FROM
		[sys].[partition_schemes]				AS [ps]
	INNER JOIN [sys].[destination_data_spaces]	AS [dds]	ON [ps].[data_space_id]			= [dds].[partition_scheme_id]
	INNER JOIN [sys].[data_spaces]				AS [ds]		ON [ds].[data_space_id]			= [dds].[data_space_id]
	INNER JOIN [sys].[partition_functions]		AS [pf]		ON [pf].[function_id]			= [ps].[function_id]
	LEFT JOIN [sys].[partition_range_values]	AS [prv1]	ON [prv1].[function_id]			= [pf].[function_id]
															AND [dds].[destination_id] - 1	= [prv1].[boundary_id]
	LEFT JOIN [sys].[partition_range_values]	AS [prv2]	ON [prv2].[function_id]			= [pf].[function_id]
															AND [dds].[destination_id]		= [prv2].[boundary_id]
	GO