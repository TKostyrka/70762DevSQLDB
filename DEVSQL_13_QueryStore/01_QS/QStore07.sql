USE [master]
GO

DROP DATABASE IF EXISTS [QStoreTEST]
GO

CREATE DATABASE [QStoreTEST]
GO

USE [QStoreTEST]
GO

----------------------------------------------------------------------------------------------

	DROP TABLE IF EXISTS [dbo].[DimProduct]	
	DROP TABLE IF EXISTS [dbo].[DimStore]		
	DROP TABLE IF EXISTS [dbo].[DimCurrency]	
	DROP TABLE IF EXISTS [dbo].[FactSales]

	SELECT * INTO [dbo].[DimProduct]	FROM [ContosoRetailDW].[dbo].[DimProduct]
	SELECT * INTO [dbo].[DimStore]		FROM [ContosoRetailDW].[dbo].[DimStore]
	SELECT * INTO [dbo].[DimCurrency]	FROM [ContosoRetailDW].[dbo].[DimCurrency]
	SELECT * INTO [dbo].[FactSales]		FROM [ContosoRetailDW].[dbo].[FactSales]
	GO

----------------------------------------------------------------------------------------------

	DROP TABLE IF EXISTS [dbo].[tbl_FactSalesData]
	GO

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

----------------------------------------------------------------------------------------------

	ALTER DATABASE [QStoreTEST]
	SET QUERY_STORE = ON
	GO

----------------------------------------------------------------------------------------------

	DROP PROC IF EXISTS [dbo].[usp_GetFactSalesData]
	GO

	CREATE PROC	[dbo].[usp_GetFactSalesData]
		@DimPName NVARCHAR(200)
	,	@DimSName NVARCHAR(200)
	WITH RECOMPILE
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
		SELECT TOP 10
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
		AND (p.ProductName		= @DimPName OR @DimPName IS NULL)
		AND (s.StoreName		= @DimSName OR @DimSName IS NULL)
		GROUP BY
			f.DateKey
		,	p.ProductName	
		,	s.StoreName	
		,	c.CurrencyName	

	END
	GO

-----------------------------------------------------------

	TRUNCATE TABLE [dbo].[tbl_FactSalesData]
	GO

-----------------------------------------------------------

	DECLARE @i INT = 1

	WHILE @i <= 1000
	BEGIN

		DECLARE @DimP INT = (SELECT CEILING(RAND() * COUNT(*)) FROM [dbo].[DimProduct]	)
		DECLARE @DimS INT = (SELECT CEILING(RAND() * COUNT(*)) FROM [dbo].[DimStore]	)

		DECLARE @DimPName NVARCHAR(200) = (SELECT y.ProductName		FROM (SELECT x.*, [rn] = ROW_NUMBER() OVER (ORDER BY ProductKey		) FROM  [dbo].[DimProduct]	 AS x) AS y WHERE [rn] = @DimP)
		DECLARE @DimSName NVARCHAR(200) = (SELECT y.StoreName		FROM (SELECT x.*, [rn] = ROW_NUMBER() OVER (ORDER BY StoreKey		) FROM  [dbo].[DimStore]	 AS x) AS y WHERE [rn] = @DimS)

		IF RAND() < 0.2 SET @DimPName = NULL
		IF RAND() < 0.2 SET @DimSName = NULL


		PRINT CAST(@i AS NVARCHAR(5)) + '; ' + 
			ISNULL(@DimPName, '---') + '; ' + 
			ISNULL(@DimSName, '---')

		EXEC [dbo].[usp_GetFactSalesData]
			@DimPName
		,	@DimSName	

		SET @i = @i + 1

	END

-----------------------------------------------------------
