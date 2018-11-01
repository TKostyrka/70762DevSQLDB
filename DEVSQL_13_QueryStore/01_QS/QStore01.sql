USE [master]
GO

DROP DATABASE IF EXISTS [QStoreTEST]
GO

CREATE DATABASE [QStoreTEST]
GO

USE [QStoreTEST]
GO

DROP TABLE IF EXISTS [dbo].[DimProduct]	
DROP TABLE IF EXISTS [dbo].[DimStore]		
DROP TABLE IF EXISTS [dbo].[DimCurrency]	
DROP TABLE IF EXISTS [dbo].[FactSales]

SELECT * INTO [dbo].[DimProduct]	FROM [ContosoRetailDW].[dbo].[DimProduct]
SELECT * INTO [dbo].[DimStore]		FROM [ContosoRetailDW].[dbo].[DimStore]
SELECT * INTO [dbo].[DimCurrency]	FROM [ContosoRetailDW].[dbo].[DimCurrency]
SELECT * INTO [dbo].[FactSales]		FROM [ContosoRetailDW].[dbo].[FactSales]
GO



