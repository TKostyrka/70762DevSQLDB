	USE [FileAndParts]
	GO

--	DROP Mth PARTITION SCHEMAS/FUNCS if exist
-----------------------------------------------------------
	
	IF EXISTS (	SELECT 1
				FROM [sys].[partition_schemes] AS [ps]
				WHERE [ps].[name] = 'PS_DatesMTH_OnFast'
				)	
	DROP PARTITION SCHEME [PS_DatesMTH_OnFast]

	IF EXISTS (	SELECT 1
				FROM [sys].[partition_functions] AS [pf]
				WHERE [pf].[name] = 'PF_DatesMTH'
				)
	DROP PARTITION FUNCTION [PF_DatesMTH]

--	Get distinct [DateKey] values	
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

	SELECT *
	FROM #DistinctDates

--	generate "CREATE PARTITION SCHEME/FUNC..." code 
--	PRINT and EXEC
-----------------------------------------------------------

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

	PRINT @DatesString
	PRINT @RowCount

	--	CREATE FUNCTION
	------------------------------

		SELECT @sqlcmd =
		'
			CREATE PARTITION FUNCTION [PF_DatesMTH] (int)  
			AS RANGE LEFT FOR VALUES (' + @DatesString + ')
			;
		'
		PRINT @sqlcmd
		EXEC(@sqlcmd)

	--	CREATE SCHEME
	------------------------------

		SELECT @FGString = REPLICATE(', [FastFG]', @RowCount)
		SET @FGString = RIGHT(@FGString, LEN(@FGString)-2)

		SELECT @sqlcmd =
		'
			CREATE PARTITION SCHEME [PS_DatesMTH_OnFast] 
			AS PARTITION [PF_DatesMTH] 
			TO (' + @FGString + ')
			;
		'
		PRINT @sqlcmd
		EXEC(@sqlcmd)

--	partition schema/function details
-----------------------------------------------------------

	SELECT
		[ps].[name]
	,	[ps].[type_desc]
	,	[pf].[name]
	,	[pf].[function_id]
	,	[pf].[type]
	,	[pf].[type_desc]
	,	[prv].[boundary_id]
	,	[prv].[value]
	FROM
		[sys].[partition_schemes]				AS [ps]
	INNER JOIN [sys].[partition_functions] AS [pf] ON [pf].[function_id] = [ps].[function_id]
	INNER JOIN [sys].[partition_range_values] AS [prv] ON [prv].[function_id] = [pf].[function_id]
	WHERE 1=1
	AND [ps].[name] = 'PS_DatesMTH_OnFast'
	GO

--	partition schema/function details + boundaries
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
				[sys].[partition_schemes]		AS [ps]
	INNER JOIN	[sys].[destination_data_spaces]	AS [dds]	ON [ps].[data_space_id] = [dds].[partition_scheme_id]
	INNER JOIN	[sys].[data_spaces]				AS [ds]		ON [ds].[data_space_id] = [dds].[data_space_id]
	INNER JOIN	[sys].[partition_functions]		AS [pf]		ON [pf].[function_id] = [ps].[function_id]
	LEFT JOIN	[sys].[partition_range_values]	AS [prv1]	ON [prv1].[function_id] = [pf].[function_id]
															AND [dds].[destination_id] - 1 = [prv1].[boundary_id]
	LEFT JOIN	[sys].[partition_range_values]	AS [prv2]	ON [prv2].[function_id] = [pf].[function_id]
															AND [dds].[destination_id] = [prv2].[boundary_id]
	WHERE 1=1
	AND [ps].[name] = 'PS_DatesMTH_OnFast'
	GO