		USE [ContosoRetailDW]				
		GO

	--	GROUP BY
	-------------------------------------------

	--	A SELECT statement clause that divides the query result into groups of rows, usually for the purpose of performing one or more aggregations on each group. 
	--	The SELECT statement returns one row per group.

	--	Aggregate functions perform a calculation on a set of values and return a single value. 
	--	Except for COUNT, aggregate functions ignore null values. 
	--	Aggregate functions are frequently used with the GROUP BY clause of the SELECT statement.

	--	All aggregate functions are deterministic. 
	--	This means aggregate functions return the same value any time that they are called by using a specific set of input values.

	--	Aggregate functions can be used as expressions only in the following:
	--		-	The select list of a SELECT statement (either a subquery or an outer query).
	--		-	A HAVING clause.
	
	--	COUNT	-	Returns the number of items in a group. COUNT works like the COUNT_BIG function.
	--	MAX		-	Returns the maximum value in the expression.
	--	MIN		-	Returns the minimum value in the expression.
	--	AVG		-	Returns the average of the values in a group. Null values are ignored.	
	--	SUM		-	Returns the sum of all the values, or only the DISTINCT values, in the expression. SUM can be used with numeric columns only. Null values are ignored.

		--	(1)

		SELECT
			COUNT(*)
		FROM
			[dbo].[DimProduct];

		--	(2)

		SELECT
			SUM([UnitCost])
		FROM
			[dbo].[DimProduct];

		--	(3)

		SELECT
			COUNT(*)			,
			SUM([UnitCost])		,
			MIN([UnitCost])		,
			MAX([UnitCost])		
		FROM
			[dbo].[DimProduct];

		SELECT
			COUNT(*)			AS [count],
			SUM([UnitCost])		AS [sum],
			MIN([UnitCost])		AS [min],
			MAX([UnitCost])		AS [max]
		FROM
			[dbo].[DimProduct];

		--	(4)

		SELECT
			COUNT(*)			AS [count],
			SUM([UnitCost])		AS [sum],
			MIN([UnitCost])		AS [min],
			MAX([UnitCost])		AS [max]
		FROM
			[dbo].[DimProduct]
		GROUP BY
			[Manufacturer]

		--	(5)

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

		--	(6)

		SELECT
			[Manufacturer]		AS [Manufacturer],
			COUNT(*)			AS [count],
			SUM([UnitCost])		AS [sum],
			MIN([UnitCost])		AS [min],
			MAX([UnitCost])		AS [max]
		FROM
			[dbo].[DimProduct]
		WHERE
			[Manufacturer] LIKE '[ABC]%'
		GROUP BY
			[Manufacturer]

