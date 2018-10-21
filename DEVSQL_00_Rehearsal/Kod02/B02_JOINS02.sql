USE [AdventureWorks2016CTP3]
GO

	--	Dla wszystkich klientów z tabeli [Sales].[Customer]	wyci¹gn¹æ informacjê na temat 
	--	[CountryRegionCode] oraz [Group] znajduj¹c¹ siê w [Sales].[SalesTerritory] (³¹czenie po [TerritoryID])
	--	
	----------------------------------------------------------------
		
		SELECT 
				[c].[CustomerID]		,
				[t].[CountryRegionCode] ,
				[t].[Group]
		FROM 
					[Sales].[Customer]			AS [c]
		INNER JOIN	[Sales].[SalesTerritory]	AS [t] ON [t].[TerritoryID] = [c].[TerritoryID]

	--	Do nag³ówków zamówieñ ([Sales].[SalesOrderHeader]) do³¹czyæ szeczó³y ([Sales].[SalesOrderDetail]) ³¹cz¹c po kolumnie [SalesOrderID]
	--	w [SalesOrderHeader] znajduj¹ siê ID adresu dostawy ([ShipToAddressID]) - u¿yæ do po³¹czenia z tabel¹ [Person].[Address]
	--	w [SalesOrderDetail] znajduje siê ID produktu z konkretnej linii zamówienia ([ProductID]) - u¿yæ do po³¹czenia z tabel¹ [Production].[Product]
	--	
	--	po³¹czyæ ze sob¹ tabele, wybraæ nastêpuj¹ce kolumny:

		--	[a].[City]
		--	[a].[PostalCode]
		--	[soh].[SalesOrderID]
		--	[sod].[SalesOrderDetailID]
		--	[sod].[OrderQty]
		--	[p].[ProductID]
		--	[p].[Name]

		-- gdzie:
		--	[soh]	: tabela [Sales].[SalesOrderHeader]
		--	[sod]	: tabela [Sales].[SalesOrderDetail]
		--	[p]		: tabela [Production].[Product]	
		--	[a]		: tabela [Person].[Address]		

		--	posortowaæ wed³ug: [a].[City] , [a].[PostalCode]

	----------------------------------------------------------------

		SELECT
			[a].[City] ,
			[a].[PostalCode] ,
			[soh].[SalesOrderID] ,
			[sod].[SalesOrderDetailID] ,
			[sod].[OrderQty] ,
			[p].[ProductID] ,
			[p].[Name]
		FROM
					[Sales].[SalesOrderHeader]	AS [soh]
		INNER JOIN	[Sales].[SalesOrderDetail]	AS [sod]	ON [sod].[SalesOrderID] = [soh].[SalesOrderID]
		INNER JOIN	[Production].[Product]		AS [p]		ON [p].[ProductID] = [sod].[ProductID]
		INNER JOIN	[Person].[Address]			AS [a]		ON [a].[AddressID] = [soh].[ShipToAddressID]
		ORDER BY
			[a].[City] ,
			[a].[PostalCode]


	--	Do nag³ówków zamówieñ ([Sales].[SalesOrderHeader]) do³¹czyæ szeczó³y ([Sales].[SalesOrderDetail]) ³¹cz¹c po kolumnie [SalesOrderID]
	--	w [SalesOrderHeader] znajduj¹ siê ID Terytorium ([TerritoryID]) - u¿yæ do po³¹czenia z tabel¹ [Sales].[SalesTerritory]
	--
	--	zafiltrowaæ daty [OrderDate] z drugiej po³owy roku 2011 (miêdzy: '20110701' a '20111231')
	--	w SELECT wybraæ dwie kolumny:
	--	[Name]			->	nazwa terytorium
	--	[OrderPrice]	->	suma mno¿enia [OrderQty] * [UnitPrice]
	--	pogrupowaæ wg [Name], posortowaæ wg [Name]
	--	otrzymamy raport prezentuj¹cy sumê wartoœci zamówieñ H2_2011 w podziale na terytorium sprzeda¿owe
	----------------------------------------------------------------
		
		SELECT
			[st].[Name] ,
			SUM([sod].[OrderQty] * [sod].[UnitPrice]) AS [OrderPrice]
		FROM
					[Sales].[SalesOrderHeader]	AS [soh]
		INNER JOIN	[Sales].[SalesOrderDetail]	AS [sod] ON [sod].[SalesOrderID] = [soh].[SalesOrderID]
		INNER JOIN	[Sales].[SalesTerritory]	AS [st] ON [st].[TerritoryID] = [soh].[TerritoryID]
		WHERE
			[soh].[OrderDate] BETWEEN '20110701'
								AND		'20111231'
		GROUP BY
			[st].[Name]
		ORDER BY
			[st].[Name];