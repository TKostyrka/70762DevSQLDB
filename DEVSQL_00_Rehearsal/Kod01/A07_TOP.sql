USE ContosoRetailDW
GO

	--	TOP
	-------------------------------------------		

	--	TOP (expression ) [ PERCENT ] [ WITH TIES ]
	--	Indicates that only a specified first set or percent of rows will be returned from the query result set. 
	--	expression can be either a number or a percent of the rows.


		SELECT *
		FROM [dbo].[DimEmployee]

		SELECT TOP (5) *
		FROM [dbo].[DimEmployee]

		SELECT TOP (5) PERCENT *
		FROM [dbo].[DimEmployee]

		---------

		SELECT *
		FROM [dbo].[DimEmployee]
		ORDER BY [HireDate]

		SELECT TOP 7 *
		FROM [dbo].[DimEmployee]
		ORDER BY [HireDate]

		SELECT TOP 7 WITH TIES *
		FROM [dbo].[DimEmployee]
		ORDER BY [HireDate]