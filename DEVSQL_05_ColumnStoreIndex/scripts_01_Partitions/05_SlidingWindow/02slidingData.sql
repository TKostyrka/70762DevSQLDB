
	USE [PartsSlideW]
	GO

------------------------------------------------------
	
	DROP PROC IF EXISTS #tmp_details
	GO

	CREATE PROC #tmp_details
	AS
	BEGIN
		SELECT
			s.[name]
		,	t.[name]
		,	i.[index_id]
		,	p.[partition_id]
		,	p.[partition_number]
		,	p.[rows]
		,	[ds].[name]				AS [ps_name]
		,	[lv].[value]			AS [leftValue]
		,	[rv].[value]			AS [rightValue]
		FROM
					sys.schemas						AS s
		INNER JOIN	sys.tables						AS t	ON	s.schema_id = t.schema_id
		INNER JOIN	sys.indexes						AS i	ON	t.object_id = i.object_id
		INNER JOIN	sys.partitions					AS p	ON	p.object_id = t.object_id
															AND	p.index_id	= i.index_id
		INNER JOIN	[sys].[data_spaces]				AS [ds] ON	[i].[data_space_id]			= [ds].[data_space_id]
		LEFT JOIN	[sys].[partition_schemes]		AS [sh] ON	[i].[data_space_id]			= [sh].[data_space_id]
		LEFT JOIN	[sys].[partition_functions]		AS [fc] ON	[sh].[function_id]			= [fc].[function_id]
		LEFT JOIN	[sys].[partition_range_values]	AS [rv] ON	[fc].[function_id]			= [rv].[function_id]
															AND [p].[partition_number]		= [rv].[boundary_id]
		LEFT JOIN	[sys].[partition_range_values]	AS [lv] ON	[fc].[function_id]			= [lv].[function_id]
															AND [p].[partition_number] - 1	= [lv].[boundary_id]
		ORDER BY 
			t.[object_id]
		,	p.[partition_number]	
	END
	GO

------------------------------------------------------	

	EXEC #tmp_details

--	SWITCH ARCH
------------------------------------------------------	

	ALTER TABLE [dbo].[FactSales]
	SWITCH PARTITION 1
	TO [dbo].[FactSalesArch]

	EXEC #tmp_details

--	MERGE/SPLIT
------------------------------------------------------	

	ALTER PARTITION FUNCTION [PF_DatesYR]()
	MERGE RANGE ('20070701')

	ALTER PARTITION FUNCTION [PF_DatesYR]()
	SPLIT RANGE ('20100101')

	EXEC #tmp_details

--	SWITCH TEMP
------------------------------------------------------	
	
	ALTER TABLE [dbo].[FactSalesTemp]
	ADD CONSTRAINT CHK_DateKey CHECK([DateKey] >= 20100101 AND [DateKey] < 20100701)

	ALTER TABLE [dbo].[FactSalesTemp]
	SWITCH
	TO [dbo].[FactSales] PARTITION 6

	EXEC #tmp_details

------------------------------------------------------	

	TRUNCATE TABLE [dbo].[FactSalesArch];
	TRUNCATE TABLE [dbo].[FactSalesTemp];

	EXEC #tmp_details

------------------------------------------------------	