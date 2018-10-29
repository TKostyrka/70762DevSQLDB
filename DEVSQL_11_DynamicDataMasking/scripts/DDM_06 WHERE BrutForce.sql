USE [master]
GO

DROP DATABASE IF EXISTS [Examples762]
GO

CREATE DATABASE [Examples762]
GO

USE [Examples762]
GO

	--	Login
	-------------------------------------------------------------------
	
		IF EXISTS
		(
			SELECT 1
			FROM sys.[sql_logins] AS l
			WHERE l.[name] = 'TestowyUserSQL'
		)
		BEGIN
			DROP LOGIN [TestowyUserSQL]
		END

		CREATE LOGIN [TestowyUserSQL] 
		WITH PASSWORD		=	N'abc123!@#$', 
		DEFAULT_DATABASE	=	[master]

	--	User
	-------------------------------------------------------------------

		IF EXISTS
		(
			SELECT 1
			FROM sys.[sysusers] AS s
			WHERE s.[name] = 'TestowyUserSQL'
		)
		BEGIN
			DROP USER [TestowyUserSQL]
		END

		CREATE USER [TestowyUserSQL] FOR LOGIN [TestowyUserSQL]
		ALTER ROLE [db_datareader] ADD MEMBER [TestowyUserSQL]
		GO
		DROP TABLE IF EXISTS [dbo].[DataMasking]
		;

	--	Data
	-------------------------------------------------------------------

		CREATE TABLE [dbo].[DataMasking]
		(
			[Id]		NVARCHAR(50)	NULL
		,	[Salary]	INT	MASKED WITH (FUNCTION = 'default()')	NOT NULL	
		);
		GO

		INSERT INTO [dbo].[DataMasking]
		(
			[Id]		
		,	[Salary]	
		)
		VALUES
			('A', 100)
		,	('B', 109)
		,	('C', 120)
		GO

		SELECT *
		FROM [dbo].[DataMasking]
		GO

	--	SELECT MASKED
	-------------------------------------------------------------------

		EXECUTE AS USER = 'TestowyUserSQL';
		SELECT *
		FROM [dbo].[DataMasking];
		REVERT;

		EXECUTE AS USER = 'TestowyUserSQL';
		SELECT *
		FROM [dbo].[DataMasking]
		WHERE 1=1
		AND [Salary] BETWEEN 100 AND 120
		REVERT;

		EXECUTE AS USER = 'TestowyUserSQL';
		SELECT *
		FROM [dbo].[DataMasking]
		WHERE 1=1
		AND [Salary] BETWEEN 100 AND 110
		REVERT;

		EXECUTE AS USER = 'TestowyUserSQL';
		SELECT *
		FROM [dbo].[DataMasking]
		WHERE 1=1
		AND [Salary] BETWEEN 105 AND 110
		REVERT;

		EXECUTE AS USER = 'TestowyUserSQL';
		SELECT *
		FROM [dbo].[DataMasking]
		WHERE 1=1
		AND [Salary] BETWEEN 108 AND 110
		REVERT;

		EXECUTE AS USER = 'TestowyUserSQL';
		SELECT *
		FROM [dbo].[DataMasking]
		WHERE 1=1
		AND [Salary] = 109
		REVERT;