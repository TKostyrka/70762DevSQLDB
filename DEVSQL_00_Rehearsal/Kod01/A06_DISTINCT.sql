USE ContosoRetailDW
GO

	--	DISTINCT
	-------------------------------------------		

	--	Specifies that only unique rows can appear in the result set. 
	--	Null values are considered equal for the purposes of the DISTINCT keyword.

        SELECT
            [SalesTerritoryLabel]
        ,   [SalesTerritoryName]
        ,   [SalesTerritoryRegion]
        ,   [SalesTerritoryCountry]
        FROM
            [dbo].[DimSalesTerritory];

        SELECT
            [SalesTerritoryRegion]
        FROM
            [dbo].[DimSalesTerritory];

        SELECT DISTINCT
            [SalesTerritoryRegion]
        FROM
            [dbo].[DimSalesTerritory];

        SELECT DISTINCT
            [SalesTerritoryCountry]
        FROM
            [dbo].[DimSalesTerritory];