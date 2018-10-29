USE ContosoRetailDW
GO

--	CREATE Multiline
---------------------------------------------------------------------

	DROP FUNCTION IF EXISTS udf_MultilineExample;  
	GO  

	CREATE FUNCTION dbo.udf_MultilineExample(@BrandName NVARCHAR(50))  
	RETURNS @MTVFTable TABLE   
	(
			[Position]			NVARCHAR(10)	NOT NULL
		,	[BrandName]			NVARCHAR(50)	NOT NULL
		,	[ProductKey]		INT				NOT NULL
		,	[ProductLabel]		NVARCHAR(255)	NOT NULL
		,	[ProductName]   	NVARCHAR(500)	NOT NULL
		,	[SalesQuantity]		INT				NOT NULL
		,	[SalesAmount]		MONEY			NOT NULL
		,	[TotalCost]			MONEY			NOT NULL
	)
	AS
	BEGIN
		
		INSERT INTO @MTVFTable
		SELECT TOP 1
			[Position]		=	'TOP'
		,	p.BrandName
		,	p.ProductKey
		,	p.ProductLabel
		,	p.ProductName   
		,	[SalesQuantity]	=	SUM(f.[SalesQuantity]	)
		,	[SalesAmount]	=	SUM(f.[SalesAmount]		)
		,	[TotalCost]		=	SUM(f.[TotalCost]		)
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
		ORDER BY 
			[SalesQuantity] DESC
		;
		
		INSERT INTO @MTVFTable
		SELECT TOP 1
			[Position]		=	'BOTTOM'
		,	p.BrandName
		,	p.ProductKey
		,	p.ProductLabel
		,	p.ProductName   
		,	[SalesQuantity]	=	SUM(f.[SalesQuantity]	)
		,	[SalesAmount]	=	SUM(f.[SalesAmount]		)
		,	[TotalCost]		=	SUM(f.[TotalCost]		)
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
		ORDER BY 
			[SalesQuantity] ASC
		;

		RETURN
		;

	END
	GO

--	USE Multiline
---------------------------------------------------------------------

	SELECT *
	FROM dbo.udf_MultilineExample('Adventure Works')
	GO

	SELECT *
	FROM dbo.udf_MultilineExample('Southridge Video')
	GO

	SELECT *
	FROM dbo.udf_MultilineExample('Northwind Traders')
	GO

--	USE Multiline - OUTER APPLY
---------------------------------------------------------------------

	SELECT oa.*
	FROM 
		(	VALUES 
				('Adventure Works')
			,	('Southridge Video')
			,	('Northwind Traders')
		) AS B(BrandName)
	OUTER APPLY dbo.udf_MultilineExample(B.BrandName) AS oa
	GO