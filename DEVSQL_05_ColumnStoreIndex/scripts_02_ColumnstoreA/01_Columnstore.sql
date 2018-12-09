USE [AdventureworksDW2016CTP3]
GO
	
	DROP PROC IF EXISTS #CheckIndexes
	DROP PROC IF EXISTS #CheckStorage
	DROP PROC IF EXISTS #DropIndexes
	GO

	--	#CheckIndexes TEMP PROC
	-----------------------------------------------------------------------------

		CREATE PROC #CheckIndexes
		AS
		BEGIN

			SELECT i.*
			FROM	
						sys.[tables]	AS t
			INNER JOIN	sys.[schemas]	AS s	ON [s].[schema_id] = [t].[schema_id]
			INNER JOIN	sys.[indexes]	AS i	ON	[i].[object_id] = [t].[object_id]
			WHERE
				s.name =	'dbo'
			AND t.name =	'FactFinance_Indeksy'

		END
		GO	

	--	#CheckStorage TEMP PROC
	-----------------------------------------------------------------------------

		CREATE PROC #CheckStorage
		AS
		BEGIN

			SELECT
				[TableName]		= [t].[name]
			,	[SchemaName]	= [s].[name]
			,	[IndexName]		= [i].[name]
			,	[a].[type_desc]
			,	[RowCounts]		= SUM([p].[rows])
			,	[TotalSpaceMB]	= CAST(ROUND((( SUM([a].[total_pages]) * 8 ) / 1024.00 ), 2) AS NUMERIC(36, 2))
			,	[UsedSpaceMB]	= CAST(ROUND((( SUM([a].[used_pages]) * 8 ) / 1024.00 ), 2) AS NUMERIC(36, 2))
			FROM
				[sys].[tables]					AS [t]
			INNER JOIN [sys].[schemas]	AS [s] ON [t].[schema_id]		= [s].[schema_id]
			INNER JOIN [sys].[indexes]	AS [i] ON [t].[object_id]		= [i].[object_id]
			INNER JOIN [sys].[partitions] AS [p] ON [i].[object_id]		= [p].[object_id]
														AND [i].[index_id]	= [p].[index_id]
			INNER JOIN [sys].[allocation_units] AS [a] ON [p].[partition_id] = [a].[container_id]
			WHERE
				1				= 1
				AND [t].[name] LIKE 'FactFinance_Indeksy'
				AND [s].[name]	= 'dbo'
			GROUP BY
				[t].[name]
			,	[s].[name]
			,	[i].[name]
			,	[a].[type_desc]
			ORDER BY
				[t].[name];

		END
		GO

	--	#DropIndexes TEMP PROC
	-----------------------------------------------------------------------------

		CREATE PROC #DropIndexes
		AS
		BEGIN

			DROP INDEX IF EXISTS [IX_FactFinance] 
			ON [dbo].[FactFinance_Indeksy]
			;

			DROP INDEX IF EXISTS [CIX_FactFinance] 
			ON [dbo].[FactFinance_Indeksy]
			;

		END
		GO

	--	RECREATE CLUSTERED INDEX
	--------------------------------------------------

		EXEC [dbo].[#DropIndexes]
		GO

		CREATE CLUSTERED INDEX [IX_FactFinance]
		ON [dbo].[FactFinance_Indeksy] 
		(
			[AccountKey]
		,	[OrganizationKey]
		)
		GO

		EXEC #CheckIndexes
		EXEC #CheckStorage		
		GO

	--	QUERY tbl
	--------------------------------------------------

		DBCC DROPCLEANBUFFERS
		DBCC FREEPROCCACHE
		GO

		SET STATISTICS IO	ON;
		SET STATISTICS TIME ON;
		GO

		----------

		SELECT
			[a].[AccountDescription]
		,   [a].[AccountType]
		,	COUNT(*)			AS [RowNum]
		,   SUM([f].[Amount])	AS [Amount]
		FROM
					[dbo].[FactFinance_Indeksy]	AS [f]
		INNER JOIN	[dbo].[DimAccount]			AS [a]	ON	[a].[AccountKey]			= [f].[AccountKey]
		GROUP BY
			[a].[AccountDescription]
		,   [a].[AccountType]

	--	RECREATE CLUSTERED COLUMNSTORE INDEX
	--------------------------------------------------

		SET STATISTICS IO	OFF;
		SET STATISTICS TIME OFF;
		GO

		EXEC [dbo].[#DropIndexes]
		GO

		CREATE CLUSTERED COLUMNSTORE INDEX [CIX_FactFinance]
		ON [dbo].[FactFinance_Indeksy]
		;

		EXEC #CheckIndexes
		EXEC #CheckStorage		
		GO
		;

	--	QUERY tbl
	--------------------------------------------------

		DBCC DROPCLEANBUFFERS
		DBCC FREEPROCCACHE
		GO

		SET STATISTICS IO	ON;
		SET STATISTICS TIME ON;
		GO

		----------

		SELECT
			[a].[AccountDescription]
		,   [a].[AccountType]
		,	COUNT(*)			AS [RowNum]
		,   SUM([f].[Amount])	AS [Amount]
		FROM
					[dbo].[FactFinance_Indeksy]	AS [f]
		INNER JOIN	[dbo].[DimAccount]			AS [a]	ON	[a].[AccountKey]			= [f].[AccountKey]
		GROUP BY
			[a].[AccountDescription]
		,   [a].[AccountType]


	--------------------------------------------------

		DBCC DROPCLEANBUFFERS
		DBCC FREEPROCCACHE
		GO

		SET STATISTICS IO	ON;
		SET STATISTICS TIME ON;
		GO

		SELECT
			[a].[AccountDescription]
		,   [a].[AccountType]
		,   [o].[OrganizationName]
		,	[d].[DepartmentGroupName]
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
		GROUP BY
			[a].[AccountDescription]
		,   [a].[AccountType]
		,   [o].[OrganizationName]
		,	[d].[DepartmentGroupName]
		OPTION (MAXDOP 1)