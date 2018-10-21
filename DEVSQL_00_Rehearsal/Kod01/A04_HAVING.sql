USE ContosoRetailDW
GO

	--	HAVING
	-------------------------------------------

	--	Specifies a search condition for a group or an aggregate. HAVING can be used only with the SELECT statement.
	--	HAVING is typically used in a GROUP BY clause. When GROUP BY is not used, HAVING behaves like a WHERE clause.

		--	(1)

		SELECT
			[Manufacturer]		AS [Manufacturer],
			COUNT(*)			AS [count],
			SUM([UnitCost])		AS [sum],
			MIN([UnitCost])		AS [min],
			MAX([UnitCost])		AS [max]
		FROM
			[dbo].[DimProduct]
		GROUP BY
			[Manufacturer]
		HAVING
			COUNT(*) > 200		

		--	(2)

		SELECT
			[Manufacturer]		AS [Manufacturer],
			COUNT(*)			AS [count],
			SUM([UnitCost])		AS [sum],
			MIN([UnitCost])		AS [min],
			MAX([UnitCost])		AS [max]
		FROM
			[dbo].[DimProduct]
		GROUP BY
			[Manufacturer]
		HAVING
			SUM([UnitCost]) > 50000		

		--	(3)

		SELECT
			[Manufacturer]		AS [Manufacturer],
			COUNT(*)			AS [count],
			SUM([UnitCost])		AS [sum],
			MIN([UnitCost])		AS [min],
			MAX([UnitCost])		AS [max]
		FROM
			[dbo].[DimProduct]
		GROUP BY
			[Manufacturer]
		HAVING
			MAX([UnitCost]) - MIN([UnitCost]) > 900