USE [QStoreTEST]
GO

-----------------------------------------------------------

	TRUNCATE TABLE [dbo].[tbl_FactSalesData]
	GO

-----------------------------------------------------------

	DECLARE @i INT = 1

	WHILE @i <= 100
	BEGIN

		DECLARE @DimP INT = (SELECT CEILING(RAND() * COUNT(*)) FROM [dbo].[DimProduct]	)
		DECLARE @DimS INT = (SELECT CEILING(RAND() * COUNT(*)) FROM [dbo].[DimStore]	)

		DECLARE @DimPName NVARCHAR(200) = (SELECT y.ProductName		FROM (SELECT x.*, [rn] = ROW_NUMBER() OVER (ORDER BY ProductKey		) FROM  [dbo].[DimProduct]	 AS x) AS y WHERE [rn] = @DimP)
		DECLARE @DimSName NVARCHAR(200) = (SELECT y.StoreName		FROM (SELECT x.*, [rn] = ROW_NUMBER() OVER (ORDER BY StoreKey		) FROM  [dbo].[DimStore]	 AS x) AS y WHERE [rn] = @DimS)

		PRINT CAST(@i AS NVARCHAR(5)) + '; ' + @DimPName + '; ' + @DimSName

		EXEC [dbo].[usp_GetFactSalesData]
			@DimPName
		,	@DimSName	

		SET @i = @i + 1

	END

-----------------------------------------------------------

	SELECT *
	FROM [dbo].[tbl_FactSalesData]