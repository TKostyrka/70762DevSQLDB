		USE [ContosoRetailDW]				
		GO

	--	odpytanie tabeli
	-------------------------------------------

		SELECT *
		FROM [dbo].[DimProduct]

		---------------------------------------------

        SELECT
            [ProductKey]
        ,   [ProductLabel]
        ,   [ProductName]
        ,   [ProductDescription]
        FROM
            [dbo].[DimProduct];

		---------------------------------------------

        SELECT
            [CustomerKey]
        ,   [CustomerLabel]
        ,   [FirstName]
        ,   [LastName]
        ,   [BirthDate]
        ,   [MaritalStatus]
        FROM
            [dbo].[DimCustomer]

		---------------------------------------------

        SELECT
			[StoreKey]
		,   [StoreType]
		,   [StoreName]
		,   [StoreDescription]
		,   [StorePhone]
		,   [StoreFax]
		,   [AddressLine1]
		,   [AddressLine2]
		FROM
			[dbo].[DimStore];

		---------------------------------------------

        SELECT
			[StoreKey]
		,   [StoreKey]
		,   [StoreKey]
		,   [StoreKey]
		FROM
			[dbo].[DimStore];

	--	filtrowanie
	-------------------------------------------

		--	=,<,>,<=,>=, <>, !=

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE [ProductKey] < 3

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE [ProductKey] <= 3

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE 
				[ProductKey]	> 5
			AND	[ProductKey]	<= 15

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE [ProductKey] != 3

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE [ProductKey] <> 3

		--	IN

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE [ProductKey] IN (1,3,5,7)

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE [AvailableForSaleDate] IN ('2005-05-03','2006-12-16','2006-12-19')

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE [AvailableForSaleDate] IN ('2005-05-03','2005-05-03','2005-05-03')

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE [AvailableForSaleDate] IN ('2005-05-03')

		
		--	BETWEEN 

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE [AvailableForSaleDate] BETWEEN '2005-05-03'AND '2006-12-16'

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE [Weight] BETWEEN 0.4 AND 0.6

		--	LIKE

			--	https://msdn.microsoft.com/en-us/library/ms179859.aspx

			--	%		Any string of zero or more characters.
			--	_		Any single character.
			--	[ ]		Any single character within the specified range ([a-f]) or set ([abcdef]).
			--	[^]		Any single character not within the specified range ([^a-f]) or set ([^abcdef]).

				SELECT *
				FROM [dbo].[DimProduct]
				WHERE [ProductName] LIKE '%Clock%'

				SELECT *
				FROM [dbo].[DimProduct]
				WHERE [ProductName] LIKE 'Contoso Air conditioner 1%'

				SELECT *
				FROM [dbo].[DimProduct]
				WHERE [ProductName] LIKE '%Silver'

				SELECT *
				FROM [dbo].[DimProduct]
				WHERE [ProductName] LIKE 'Contoso%Silver'

				SELECT *
				FROM [dbo].[DimProduct]
				WHERE [ProductDescription] LIKE '%MB%'

				SELECT *
				FROM [dbo].[DimProduct]
				WHERE [ProductDescription] LIKE '___MB%'

				SELECT *
				FROM [dbo].[DimProduct]
				WHERE [ProductName] LIKE '[ABC]%'

				SELECT *
				FROM [dbo].[DimProduct]
				WHERE [ProductName] LIKE '[^ABC]%'

		--	NOT

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE [ProductName] NOT LIKE '%Silver'

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE NOT [ProductKey] <= 3

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE NOT [ProductKey] <= 3

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE [AvailableForSaleDate] NOT BETWEEN '2005-05-03'AND '2006-12-16'

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE NOT [AvailableForSaleDate] BETWEEN '2005-05-03'AND '2006-12-16'

			SELECT *
			FROM [dbo].[DimProduct]
			WHERE NOT NOT NOT [AvailableForSaleDate] NOT BETWEEN '2005-05-03'AND '2006-12-16'