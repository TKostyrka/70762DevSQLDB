USE ContosoRetailDW
GO

--	CREATE Inline
---------------------------------------------------------------------

	DROP FUNCTION IF EXISTS udf_InlineExample;  
	GO  

	CREATE FUNCTION dbo.udf_InlineExample(@BrandName NVARCHAR(50))  
	RETURNS TABLE   
	AS
	RETURN  
		SELECT
			p.BrandName
		,	p.ProductKey
		,	p.ProductLabel
		,	p.ProductName   
		,	SUM(f.[SalesQuantity]	)	AS [SalesQuantity]	
		,	SUM(f.[SalesAmount]		)	AS [SalesAmount]		
		,	SUM(f.[TotalCost]		)	AS [TotalCost]		
		FROM 
					[dbo].[DimProduct]		AS p 
		INNER JOIN	[dbo].[FactOnlineSales] AS f ON p.ProductKey = f.ProductKey
		WHERE 1=1
		AND p.[BrandName] = @BrandName
		GROUP BY 
			p.BrandName
		,	p.ProductKey
		,	p.ProductLabel
		,	p.ProductName
	GO

--	USE Inline
---------------------------------------------------------------------

	SELECT *
	FROM dbo.udf_InlineExample('Adventure Works')
	GO

	SELECT *
	FROM dbo.udf_InlineExample('Southridge Video')
	GO

	SELECT *
	FROM dbo.udf_InlineExample('Northwind Traders')
	GO

--	USE Inline - OUTER APPLY
---------------------------------------------------------------------

	SELECT oa.*
	FROM 
		(	VALUES 
				('Adventure Works')
			,	('Southridge Video')
			,	('Northwind Traders')
		) AS B(BrandName)
	OUTER APPLY dbo.udf_InlineExample(B.BrandName) AS oa
	GO