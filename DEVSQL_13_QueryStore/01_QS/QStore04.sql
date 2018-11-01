USE [QStoreTEST]
GO

-----------------------------------------------------------

	DROP PROC IF EXISTS [dbo].[usp_GetFactSalesData]
	GO

	DROP TABLE IF EXISTS [dbo].[tbl_FactSalesData]
	GO

-----------------------------------------------------------

	CREATE TABLE [dbo].[tbl_FactSalesData]
	(
			[GUID]				[UNIQUEIDENTIFIER]	NOT NULL
		,	[DateKey]			[datetime]			NOT NULL
		,	[ProductName]		[nvarchar](500)		NULL
		,	[StoreName]			[nvarchar](100)		NOT NULL
		,	[CurrencyName]		[nvarchar](20)		NOT NULL
		,	[SalesQuantity]		[int]				NULL
		,	[SalesAmount]		[money]				NULL
		,	[ReturnQuantity]	[int]				NULL
		,	[ReturnAmount]		[money]				NULL
	)
	GO

-----------------------------------------------------------


	CREATE PROC	[dbo].[usp_GetFactSalesData]
		@DimPName NVARCHAR(200)
	,	@DimSName NVARCHAR(200)
	AS
	BEGIN

		SET NOCOUNT ON

		INSERT INTO [dbo].[tbl_FactSalesData]
		(
				[GUID]				
			,	[DateKey]			
			,	[ProductName]		
			,	[StoreName]			
			,	[CurrencyName]		
			,	[SalesQuantity]		
			,	[SalesAmount]		
			,	[ReturnQuantity]	
			,	[ReturnAmount]		
		)
		SELECT
			NEWID()
		,	f.DateKey
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

	END
	GO

-----------------------------------------------------------

	DECLARE @DimP INT = (SELECT CEILING(RAND() * COUNT(*)) FROM [dbo].[DimProduct]	)
	DECLARE @DimS INT = (SELECT CEILING(RAND() * COUNT(*)) FROM [dbo].[DimStore]	)

	DECLARE @DimPName NVARCHAR(200) = (SELECT y.ProductName		FROM (SELECT x.*, [rn] = ROW_NUMBER() OVER (ORDER BY ProductKey		) FROM  [dbo].[DimProduct]	 AS x) AS y WHERE [rn] = @DimP)
	DECLARE @DimSName NVARCHAR(200) = (SELECT y.StoreName		FROM (SELECT x.*, [rn] = ROW_NUMBER() OVER (ORDER BY StoreKey		) FROM  [dbo].[DimStore]	 AS x) AS y WHERE [rn] = @DimS)

	PRINT @DimPName
	PRINT @DimSName

	EXEC [dbo].[usp_GetFactSalesData]
		@DimPName
	,	@DimSName	

-----------------------------------------------------------