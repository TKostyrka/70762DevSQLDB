USE [AdventureworksDW2016CTP3]
GO

SELECT TOP 5 *
FROM [dbo].[FactFinance] AS [f]
;

-----------------------------------------------

SELECT
	COUNT(*)													AS [Rownum]

,	COUNT(	DISTINCT [f].[OrganizationKey]		)				AS DistCnt_OrganizationKey
,   COUNT(	DISTINCT [f].[DepartmentGroupKey]	)				AS DistCnt_DepartmentGroupKey
,   COUNT(	DISTINCT [f].[ScenarioKey]			)				AS DistCnt_ScenarioKey	
,   COUNT(	DISTINCT [f].[AccountKey]			)				AS DistCnt_AccountKey		
,	COUNT(	DISTINCT [f].[Date]					)				AS DistCnt_Date

,	COUNT(*) /	COUNT(	DISTINCT [f].[OrganizationKey]		)	AS AvgCntPerMember_OrganizationKey
,   COUNT(*) /	COUNT(	DISTINCT [f].[DepartmentGroupKey]	)	AS AvgCntPerMember_DepartmentGroupKey
,   COUNT(*) /	COUNT(	DISTINCT [f].[ScenarioKey]			)	AS AvgCntPerMember_ScenarioKey	
,   COUNT(*) /	COUNT(	DISTINCT [f].[AccountKey]			)	AS AvgCntPerMember_AccountKey		
,	COUNT(*) /	COUNT(	DISTINCT [f].[Date]					)	AS AvgCntPerMember_Date
FROM
    [dbo].[FactFinance_Indeksy] AS [f]
;

-----------------------------------------------
	
	IF INDEXPROPERTY(OBJECT_ID('dbo.FactFinance_Indeksy'), 'IX_FactFinance', 'IndexId') IS NOT NULL 
	DROP INDEX IX_FactFinance ON [dbo].[FactFinance_Indeksy]

	SELECT i.*
	FROM	
				sys.[tables]	AS t
	INNER JOIN	sys.[schemas]	AS s	ON [s].[schema_id] = [t].[schema_id]
	INNER JOIN	sys.[indexes]	AS i	ON	[i].[object_id] = [t].[object_id]
	WHERE
		s.name =	'dbo'
	AND t.name = 'FactFinance_Indeksy'


-----------------------------------------------
	
	SELECT
		[TableName]		=	[t].[name]
	,   [SchemaName]	=	[s].[name]
	,   [RowCounts]		=	SUM([p].[rows])
	,   [TotalSpaceMB]	=	CAST(ROUND(( ( SUM([a].[total_pages]) * 8 ) / 1024.00 ), 2) AS NUMERIC(36, 2))
	,   [UsedSpaceMB]	=	CAST(ROUND(( ( SUM([a].[used_pages]) * 8 ) / 1024.00 ), 2) AS NUMERIC(36, 2))
	FROM
				[sys].[tables]				AS [t]
	INNER JOIN	[sys].[schemas]				AS [s]    ON [t].[schema_id]	= [s].[schema_id]
	INNER JOIN	[sys].[indexes]				AS [i]    ON [t].[object_id]	= [i].[object_id]
	INNER JOIN	[sys].[partitions]			AS [p]    ON [i].[object_id]	= [p].[object_id]       AND [i].[index_id] = [p].[index_id]
	INNER JOIN	[sys].[allocation_units]	AS [a]    ON [p].[partition_id] = [a].[container_id]

	WHERE 1=1
		AND [t].[name] LIKE 'FactFinance_Indeksy'
		AND [s].[name] =	'dbo'
	GROUP BY
		[t].[name]
	,   [s].[name]
	ORDER BY
		[t].[name];