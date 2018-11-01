USE [QStoreTEST]
GO

DECLARE @DimP INT = (SELECT CEILING(RAND() * COUNT(*)) FROM [dbo].[DimProduct]	)
DECLARE @DimS INT = (SELECT CEILING(RAND() * COUNT(*)) FROM [dbo].[DimStore]	)

DECLARE @DimPName NVARCHAR(200) = (SELECT y.ProductName		FROM (SELECT x.*, [rn] = ROW_NUMBER() OVER (ORDER BY ProductKey		) FROM  [dbo].[DimProduct]	 AS x) AS y WHERE [rn] = @DimP)
DECLARE @DimSName NVARCHAR(200) = (SELECT y.StoreName		FROM (SELECT x.*, [rn] = ROW_NUMBER() OVER (ORDER BY StoreKey		) FROM  [dbo].[DimStore]	 AS x) AS y WHERE [rn] = @DimS)

PRINT @DimPName
PRINT @DimSName

-----------------------------------------------------------

SELECT
	f.DateKey
,	p.ProductName	
,	s.StoreName	
,	c.CurrencyName	
,	SUM(f.SalesQuantity)	AS SalesQuantity
,	SUM(f.SalesAmount)		AS SalesAmount
,	SUM(f.ReturnQuantity)	AS ReturnQuantity
,	SUM(f.ReturnAmount)		AS ReturnAmount
FROM		[dbo].[FactSales]	AS f
INNER JOIN	[dbo].[DimProduct]	AS p	ON f.[ProductKey]	=	p.[ProductKey]
INNER JOIN	[dbo].[DimStore]	AS s	ON f.[StoreKey]		=	s.[StoreKey]
INNER JOIN	[dbo].[DimCurrency]	AS c	ON f.[CurrencyKey]	=	c.[CurrencyKey]
WHERE 1=1
AND p.ProductName	= @DimPName
AND s.StoreName		= @DimSName
GROUP BY
	f.DateKey
,	p.ProductName	
,	s.StoreName	
,	c.CurrencyName	
