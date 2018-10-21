		USE [AdventureWorks2016CTP3]
		GO

	--	plain subquery(1)
	-------------------------------
	
		-- zliczyæ linie zamówieñ na produktach o kolorze [Color] = 'Black'

		SELECT
			COUNT(*)
		FROM
			[Sales].[SalesOrderDetail] AS [sod]
		INNER JOIN [Production].[Product] AS [p] ON [p].[ProductID] = [sod].[ProductID]
		WHERE
			[p].[Color] = 'Black';

		SELECT
			COUNT(*)
		FROM
			[Sales].[SalesOrderDetail] AS [sod]
		WHERE
			[sod].[ProductID] IN 
			( 
				SELECT	[p].[ProductID]
				FROM	[Production].[Product] AS [p]
				WHERE	[p].[Color] = 'Black' 
				);

	--	plain subquery(2)
	-------------------------------
	
		-- zliczyæ sumê podatku na zamówieniach zawieraj¹cych produkt [Name] = 'Road-150 Red, 52'

		SELECT SUM([soh].[TaxAmt])
		FROM 
					[Sales].[SalesOrderHeader]	AS soh
		INNER JOIN	[Sales].[SalesOrderDetail]	AS sod ON [sod].[SalesOrderID]	= [soh].[SalesOrderID]
		INNER JOIN	[Production].[Product]		AS [p] ON [p].[ProductID]		= [sod].[ProductID]
		WHERE p.[Name] = 'Road-150 Red, 52'


		SELECT SUM([soh].[TaxAmt])
		FROM 
					[Sales].[SalesOrderHeader]	AS soh
		WHERE
			soh.[SalesOrderID] IN 
				(
					SELECT sod.SalesOrderID
					FROM
								[Sales].[SalesOrderDetail]	AS [sod]
					LEFT JOIN	[Production].[Product]		AS [p] ON [p].[ProductID]		= [sod].[ProductID]
					WHERE p.[Name] = 'Road-150 Red, 52'
				)

	--	plain subquery(3)
	-------------------------------

		-- zwróciæ [TerritoryID] 3 terytoriów z najwiêksz¹ sum¹ MAX(st.[TaxAmt]) oraz liczbê zamówieñ w ka¿dym z nich

		SELECT TOP 3
			st.[TerritoryID] ,
			COUNT(*)
		FROM
			[Sales].[SalesOrderHeader] AS st
		GROUP BY
			st.[TerritoryID]
		ORDER BY
			MAX(st.[TaxAmt]) DESC 

		SELECT
			[soh_outer].[TerritoryID] ,
			COUNT(*)
		FROM
			[Sales].[SalesOrderHeader] AS soh_outer
		WHERE
			[soh_outer].[TerritoryID] IN (	SELECT TOP 3
												[soh_inner].[TerritoryID]
											FROM
												[Sales].[SalesOrderHeader] AS [soh_inner]
											GROUP BY
												[soh_inner].[TerritoryID]
											ORDER BY
												MAX([soh_inner].[TaxAmt]) DESC 
												)
		GROUP BY
			[soh_outer].[TerritoryID]
		ORDER BY  
			[soh_outer].[TerritoryID];

	--	correlated subquery(4)
	-------------------------------
		--	dla ka¿dego [TerritoryID] zwróciæ dwa zamówienia o najwiêkszym [TaxAmt]

		SELECT 
			[soh].[TerritoryID],
			st.[Name],
			[soh].[SalesOrderID] ,
			[soh].[SalesOrderNumber] ,
			[soh].[OrderDate] ,		
			[soh].[TaxAmt]
		FROM [Sales].[SalesOrderHeader] AS [soh]
		INNER JOIN [Sales].[SalesTerritory] AS [st] ON [st].[TerritoryID] = [soh].[TerritoryID]

		WHERE [soh].[SalesOrderID] IN ( SELECT TOP 2	[soh2].[SalesOrderID]
										FROM			[Sales].[SalesOrderHeader] AS [soh2]
										WHERE			soh.[TerritoryID] = [soh2].[TerritoryID]
										ORDER BY		soh2.[TaxAmt] DESC
										)
		ORDER BY
			[soh].[TerritoryID]

	--	correlated subquery(5)
	-------------------------------
	
		--	zwróciæ pozycjê w których uœredniony kurs dzienny [AverageRate] jest wiêkszy ni¿ 
		--	uœredniony kurs za ca³y okres (tzn. œrednia AVG kolumny [AverageRate] dla danej waluty)

		SELECT
			[cr].[CurrencyRateDate] ,
			[cr].[FromCurrencyCode] ,
			[cr].[ToCurrencyCode]	,
			[cr].[AverageRate]		,
			(	SELECT AVG([cr2].[AverageRate])
				FROM [Sales].[CurrencyRate] AS [cr2]
				WHERE
					[cr].[FromCurrencyCode]	= [cr2].[FromCurrencyCode]
				AND [cr].[ToCurrencyCode]	= [cr2].[ToCurrencyCode]								
					)
		FROM
			[Sales].[CurrencyRate] AS [cr]
		WHERE 
			[cr].[AverageRate] > (	SELECT AVG([cr2].[AverageRate])
									FROM [Sales].[CurrencyRate] AS [cr2]
									WHERE
										[cr].[FromCurrencyCode]	= [cr2].[FromCurrencyCode]
									AND [cr].[ToCurrencyCode]	= [cr2].[ToCurrencyCode]								
										)