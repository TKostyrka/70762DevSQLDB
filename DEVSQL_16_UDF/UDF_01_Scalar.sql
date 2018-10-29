USE ContosoRetailDW
GO

--	CREATE Scalar
---------------------------------------------------------------------

	DROP FUNCTION IF EXISTS udf_ScalarExample;  
	GO  

	CREATE FUNCTION dbo.udf_ScalarExample(@ProductKey INT)  
	RETURNS INT   
	AS   

	BEGIN  
		DECLARE @ret int;  

		SELECT @ret = SUM(f.[SalesQuantity])   
		FROM [dbo].[FactOnlineSales] AS f 
		WHERE 1=1
		AND f.[ProductKey] = @ProductKey   

		IF (@ret IS NULL) SET @ret = 0;
		  
		RETURN @ret;  
	END;
	GO

--	USE Scalar #1
---------------------------------------------------------------------

	SELECT TOP 5
		p.ProductKey
	,	p.ProductLabel
	,	dbo.udf_ScalarExample(p.ProductKey)	AS [fun_ScalarExample]
	FROM [dbo].[DimProduct] AS p
	GO

--	USE Scalar #2
---------------------------------------------------------------------

	SELECT TOP 5
		p.ProductKey
	,	p.ProductLabel
	,	GETDATE()			AS [sysfun_GETDATE]
	,	RAND()				AS [sysfun_RAND]
	,	NEWID()				AS [sysfun_NEWID]
	,	EOMONTH(GETDATE())	AS [sysfun_EOMONTH]
	FROM [dbo].[DimProduct] AS p
	GO