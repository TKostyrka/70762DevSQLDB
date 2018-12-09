
	USE [CCI]
	GO

-----------------------------------------------------------
	
	DROP VIEW IF EXISTS [dbo].[CSOverwiew_02]
	GO

	CREATE VIEW [dbo].[CSOverwiew_02]
	AS
	SELECT
		[TableName]						 = [s].[name] + '.' + [t].[name]
	,	[IndexName]						 = [i].[name]
	,	[ps_name]						 = [sh].[name]
	,	[partition_number]				 = [v].[partition_number]
	,	[leftValue]						 = [lv].[value]
	,	[rightValue]					 = [rv].[value]
	,	[row_group_id]					 = [v].[row_group_id]
	,	[delta_store_hobt_id]			 = [v].[delta_store_hobt_id]
	,	[state]							 = [v].[state_desc]
	,	[total_rows]					 = [v].[total_rows]
	,	[deleted_rows]					 = [v].[deleted_rows]
	,	[trim_reason]					 = [v].[trim_reason_desc]
	,	[transition_to_compressed_state] = [v].[transition_to_compressed_state_desc]

	FROM
		[sys].[schemas]											   AS [s]
	INNER JOIN [sys].[tables]									   AS [t] ON [t].[schema_id] = [s].[schema_id]
	INNER JOIN [sys].[indexes]									   AS [i] ON [i].[object_id] = [t].[object_id]
	INNER JOIN [sys].[partitions]								   AS [p] ON [p].[object_id] = [i].[object_id]
																			 AND [p].[index_id] = [i].[index_id]
	INNER JOIN [sys].[data_spaces]								   AS [ds] ON [i].[data_space_id] = [ds].[data_space_id]
	INNER JOIN [sys].[partition_schemes]						   AS [sh] ON [i].[data_space_id] = [sh].[data_space_id]
	INNER JOIN [sys].[partition_functions]						   AS [fc] ON [sh].[function_id] = [fc].[function_id]
	INNER JOIN [sys].[dm_db_column_store_row_group_physical_stats] AS [v] ON [t].[object_id] = [v].[object_id]
																			 AND [v].[index_id] = [i].[index_id]
																			 AND [v].[partition_number] = [p].[partition_number]
	LEFT JOIN [sys].[partition_range_values]					   AS [rv] ON [fc].[function_id] = [rv].[function_id]
																			  AND [p].[partition_number] = [rv].[boundary_id]
	LEFT JOIN [sys].[partition_range_values]					   AS [lv] ON [fc].[function_id] = [lv].[function_id]
																			  AND [p].[partition_number] - 1 = [lv].[boundary_id]
	GO

	SELECT *
	FROM [dbo].[CSOverwiew_02]
	WHERE [TableName] = 'dbo.FactSales_OnYR'
	GO