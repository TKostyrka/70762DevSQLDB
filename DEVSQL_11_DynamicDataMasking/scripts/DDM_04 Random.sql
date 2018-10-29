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
			[FirstName]		NVARCHAR(50)	NULL
		,	[PersonNumber]	CHAR(10)		NOT NULL
		,	[Number1]		INT				MASKED WITH (FUNCTION = 'random(1,3)')		NOT NULL	
		,	[Number2]		FLOAT			MASKED WITH (FUNCTION = 'random(10,20)')		NOT NULL
		,	[Number3]		NUMERIC(10,5)	MASKED WITH (FUNCTION = 'random(1,100)')	NOT NULL
		);
		GO

		INSERT INTO [dbo].[DataMasking]
		(
			[FirstName]		
		,	[PersonNumber]	
		,	[Number1]
		,	[Number2]
		,	[Number3]
		)
		VALUES
			('Jay'		,'0000000014'	, 12345, 12345.1234, 12345.99)
		,	('Darya'	,'0000000032'	, 12345, 12345.1234, 12345.99)
		,	('Tomasz'	,'0000000102'	, 12345, 12345.1234, 12345.99)
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
