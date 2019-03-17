	USE [STAT]
	GO

-----------------------------------------------------------------

	SELECT	[v].*
	FROM	[dbo].[MyStatsView] AS [v]
	WHERE
		[v].[sh_name]		= 'dbo'
	AND [v].[tb_name]	= 'FactSales';

-----------------------------------------------------------------
	
	--	DBCC SHOW_STATISTICS shows the header, histogram, 
	--	AND density vector based on data stored in the statistics object.

		DBCC SHOW_STATISTICS(FactSales, MyStats_01)
		;

		DBCC SHOW_STATISTICS(FactSales, MyStats_01)
		WITH STAT_HEADER
		;

		DBCC SHOW_STATISTICS(FactSales, MyStats_01)
		WITH HISTOGRAM
		;

		DBCC SHOW_STATISTICS(FactSales, MyStats_01)
		WITH DENSITY_VECTOR
		;

		DBCC SHOW_STATISTICS(FactSales, MyStats_01)
		WITH STATS_STREAM
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