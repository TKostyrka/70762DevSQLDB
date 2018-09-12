USE [AdventureworksDW2016CTP3]
GO

DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
GO

SET STATISTICS IO	ON;
SET STATISTICS TIME ON;
GO

--------------------------------------------------


	--IF INDEXPROPERTY(OBJECT_ID('dbo.FactFinance_Indeksy'), 'NIX_FactFinance', 'IndexId') IS NOT NULL 
	--DROP INDEX NIX_FactFinance ON [dbo].[FactFinance_Indeksy]

	--CREATE NONCLUSTERED INDEX NIX_FactFinance
	--ON [dbo].[FactFinance_Indeksy](		[AccountKey]		,
	--							[OrganizationKey]
	--						)
	--INCLUDE ([DepartmentGroupKey], [Amount])

	--SELECT i.*
	--FROM	
	--			sys.[tables]	AS t
	--INNER JOIN	sys.[schemas]	AS s	ON [s].[schema_id] = [t].[schema_id]
	--INNER JOIN	sys.[indexes]	AS i	ON	[i].[object_id] = [t].[object_id]
	--WHERE
	--	s.name =	'dbo'
	--AND t.name = 'FactFinance_Indeksy'

--------------------------------------------------

	SELECT
		[a].[AccountDescription]
	,   [a].[AccountType]
	,   [o].[OrganizationName]
	,	[d].[DepartmentGroupName]
	,	COUNT(*)			AS [RowNum]
	,   SUM([f].[Amount])	AS [Amount]

	FROM
				[dbo].[FactFinance_Indeksy]	AS [f]
	INNER JOIN	[dbo].[DimAccount]			AS [a]	ON	[a].[AccountKey]			= [f].[AccountKey]
	INNER JOIN	[dbo].[DimDepartmentGroup]	AS [d]	ON	[d].[DepartmentGroupKey]	= [f].[DepartmentGroupKey]
	INNER JOIN	[dbo].[DimOrganization]		AS [o]	ON	[o].[OrganizationKey]		= [f].[OrganizationKey]
	WHERE
		[a].[AccountDescription]	= 'Cash'
	AND [d].[DepartmentGroupName]	= 'Sales and Marketing'
	AND [o].[OrganizationName]		= 'France'
	GROUP BY
		[a].[AccountDescription]
	,   [a].[AccountType]
	,   [o].[OrganizationName]
	,	[d].[DepartmentGroupName]
	OPTION (MAXDOP 1)