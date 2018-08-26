USE [AdventureworksDW2016CTP3]
GO

DBCC DROPCLEANBUFFERS
DBCC FREEPROCCACHE
GO

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
			[dbo].[FactFinance_Indeksy]	AS [f]
INNER JOIN	[dbo].[DimAccount]			AS [a]	ON	[a].[AccountKey]			= [f].[AccountKey]
INNER JOIN	[dbo].[DimDepartmentGroup]	AS [d]	ON	[d].[DepartmentGroupKey]	= [f].[DepartmentGroupKey]
INNER JOIN	[dbo].[DimOrganization]		AS [o]	ON	[o].[OrganizationKey]		= [f].[OrganizationKey]
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