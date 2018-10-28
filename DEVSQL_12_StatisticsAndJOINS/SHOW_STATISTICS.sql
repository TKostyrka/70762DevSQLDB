USE [ContosoRetailDW]
GO

-----------------------------------------------------------------

	SELECT 
		s.[name]	AS	[schema]
	,	t.[name]	AS 	[table]
	,	c.[name]	AS  [column]
	,	st.[name]	AS 	[statistic]
	FROM 
				[sys].[schemas]			AS s 
	INNER JOIN  [sys].[tables]			AS t	ON	[s].[schema_id] = [t].[schema_id]
	INNER JOIN  [sys].[columns]			AS c	ON	[c].[object_id] = [t].[object_id]
	INNER JOIN  [sys].[stats]			AS st	ON	[t].[object_id] = [st].[object_id]
	INNER JOIN  [sys].[stats_columns]	AS sc	ON	[t].[object_id] = [sc].[object_id]
												AND [st].[stats_id] = [sc].[stats_id]
												AND [sc].[column_id] = [c].[column_id]
	WHERE 1=1
	AND t.[name]	= 'DimCurrency'
	AND st.[name]	= 'PK_DimCurrency_CurrencyKey'

-----------------------------------------------------------------
	
	--	DBCC SHOW_STATISTICS shows the header, histogram, 
	--	AND density vector based on data stored in the statistics object.

		DBCC SHOW_STATISTICS(DimCurrency, PK_DimCurrency_CurrencyKey)
		;

		DBCC SHOW_STATISTICS(DimCurrency, PK_DimCurrency_CurrencyKey)
		WITH STAT_HEADER
		;

		DBCC SHOW_STATISTICS(DimCurrency, PK_DimCurrency_CurrencyKey)
		WITH HISTOGRAM
		;

		DBCC SHOW_STATISTICS(DimCurrency, PK_DimCurrency_CurrencyKey)
		WITH DENSITY_VECTOR
		;

-----------------------------------------------------------------

--	For each step, SQL Server stores the following four values:

--	RANGE_ROWS
--	The number of rows inside the range between the current step and
--	the previous step, but does not include the step values themselves.

--	EQ_ROWS 
--	The number of rows having the same value as the sample value.

--	DISTINCT_RANGE_ROWS 
--	The number of distinct values between the current
--	step and the previous step, but does not include the step values themselves.

--	AVG_RANGE_ROWS 
--	The average number of rows for each distinct value with the
--	step range.