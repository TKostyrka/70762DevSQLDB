USE [AdventureworksDW2016CTP3]
GO

DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
GO

SET STATISTICS IO	OFF;
SET STATISTICS TIME OFF;
GO

--------------------------------------------------

--CREATE CLUSTERED INDEX IX_FactFinance
--ON [dbo].[FactFinance_Indeksy](Date)

--SELECT i.*
--FROM	
--			sys.[tables]	AS t
--INNER JOIN	sys.[schemas]	AS s	ON [s].[schema_id] = [t].[schema_id]
--INNER JOIN	sys.[indexes]	AS i	ON	[i].[object_id] = [t].[object_id]
--WHERE
--	s.name =	'dbo'
--AND t.name = 'FactFinance_Indeksy'

--------------------------------------------------

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

SELECT
    [a].[AccountDescription]
,   [a].[AccountType]
,   [o].[OrganizationName]
,	[d].[DepartmentGroupName]
,   [f].[Date]
,	COUNT(*)			AS [RowNum]
,   SUM([f].[Amount])	AS [Amount]

FROM
			[dbo].[FactFinance_Indeksy]		AS [f]
INNER JOIN	[dbo].[DimAccount]				AS [a]	ON	[a].[AccountKey]			= [f].[AccountKey]
INNER JOIN	[dbo].[DimDepartmentGroup]		AS [d]	ON	[d].[DepartmentGroupKey]	= [f].[DepartmentGroupKey]
INNER JOIN	[dbo].[DimOrganization]			AS [o]	ON	[o].[OrganizationKey]		= [f].[OrganizationKey]
WHERE
    [a].[AccountDescription]	= 'Cash'
AND [d].[DepartmentGroupName]	= 'Sales and Marketing'
AND [o].[OrganizationName]		= 'France'
AND [f].[Date]					= '2012-04-30'
GROUP BY
	[a].[AccountDescription]
,   [a].[AccountType]
,   [o].[OrganizationName]
,	[d].[DepartmentGroupName]
,   [f].[Date]