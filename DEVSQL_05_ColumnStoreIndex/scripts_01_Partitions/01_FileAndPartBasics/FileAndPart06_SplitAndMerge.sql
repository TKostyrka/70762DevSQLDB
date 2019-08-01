	USE [FileAndParts]
	GO

--	partition schema/function details + boundaries
-----------------------------------------------------------

	DROP VIEW IF EXISTS [dbo].[v_SplitMergePSTester]
	GO

	CREATE VIEW [dbo].[v_SplitMergePSTester]
	AS
	SELECT
		[ps].[name]		AS [PS_name]
	,	[ds].[name]		AS [FG_name]
	,	[pf].[name]		AS [PF_name]
	,	[pf].[type]
	,	[pf].[type_desc]
	,	[prv1].[value]	AS [value_FROM]
	,	[prv2].[value]	AS [value_TO]
	FROM
				[sys].[partition_schemes]			AS [ps]
	INNER JOIN	[sys].[destination_data_spaces]		AS [dds]	ON [ps].[data_space_id] = [dds].[partition_scheme_id]
	INNER JOIN	[sys].[data_spaces]					AS [ds]		ON [ds].[data_space_id] = [dds].[data_space_id]
	INNER JOIN	[sys].[partition_functions]			AS [pf]		ON [pf].[function_id] = [ps].[function_id]
	LEFT JOIN	[sys].[partition_range_values]		AS [prv1]	ON [prv1].[function_id] = [pf].[function_id]
																AND [dds].[destination_id] - 1 = [prv1].[boundary_id]
	LEFT JOIN	[sys].[partition_range_values]		AS [prv2]	ON [prv2].[function_id] = [pf].[function_id]
																AND [dds].[destination_id] = [prv2].[boundary_id]
	WHERE
		1 = 1
		AND [ps].[name] = 'PS_SplitMergeYR_OnFast';
	GO

	SELECT *
	FROM [dbo].[v_SplitMergePSTester]

--	DROP SplitMerge PARTITION SCHEME/FUNC 
-----------------------------------------------------------

	IF EXISTS (	SELECT 1
				FROM [sys].[partition_schemes] AS [ps]
				WHERE [ps].[name] = 'PS_SplitMergeYR_OnFast'
				)	
	DROP PARTITION SCHEME [PS_SplitMergeYR_OnFast]
	;

	IF EXISTS (	SELECT 1
				FROM [sys].[partition_functions] AS [pf]
				WHERE [pf].[name] = 'PF_SplitMergeYR'
				)
	DROP PARTITION FUNCTION [PF_SplitMergeYR]
	;

--	CREATE SplitMerge PARTITION SCHEME/FUNC 
-----------------------------------------------------------

	CREATE PARTITION FUNCTION [PF_SplitMergeYR] (int)  
	AS RANGE LEFT FOR VALUES (20070101, 20080101, 20090101);
	GO

	CREATE PARTITION SCHEME [PS_SplitMergeYR_OnFast] 
	AS PARTITION [PF_SplitMergeYR]  
	TO ([FastFG],[FastFG],[SlowFG],[SlowFG])
	GO

--	check details (4 partitions)
-----------------------------------------------------------

	SELECT *
	FROM [dbo].[v_SplitMergePSTester]
	;

--	SPLIT + check (5 pts)
-----------------------------------------------------------
	
	ALTER PARTITION SCHEME [PS_SplitMergeYR_OnFast]  
	NEXT USED [FastFG];  
	
	ALTER PARTITION FUNCTION  [PF_SplitMergeYR]() 
	SPLIT RANGE (20100101);

	SELECT *
	FROM [dbo].[v_SplitMergePSTester]
	;

--	SPLIT + check (6 pts), different FG
-----------------------------------------------------------
	
	ALTER PARTITION SCHEME [PS_SplitMergeYR_OnFast]  
	NEXT USED [FastFG];  
  	
	ALTER PARTITION FUNCTION  [PF_SplitMergeYR]() 
	SPLIT RANGE (20060101);

	SELECT *
	FROM [dbo].[v_SplitMergePSTester]
	;
	
--	MERGE + check (5 pts)
-----------------------------------------------------------

	ALTER PARTITION FUNCTION [PF_SplitMergeYR]() 
	MERGE RANGE (20100101);  

	SELECT *
	FROM [dbo].[v_SplitMergePSTester]
	;



