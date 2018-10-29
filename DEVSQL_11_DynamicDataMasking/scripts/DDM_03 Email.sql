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
			[FirstName]		NVARCHAR(50)	MASKED WITH (FUNCTION = 'email()')	NULL
		,	[PersonNumber]	CHAR(10)		MASKED WITH (FUNCTION = 'email()')	NOT NULL	
		,	[EmailAddress]	NVARCHAR(50)	MASKED WITH (FUNCTION = 'email()')	NULL		
		,	[BirthDate]		DATE			NOT NULL	
		,	[CarCount]		TINYINT			NOT NULL	
		);
		GO

		INSERT INTO [dbo].[DataMasking]
		(
			[FirstName]		
		,	[PersonNumber]	
		,	[EmailAddress]	
		,	[BirthDate]		
		,	[CarCount]		
		)
		VALUES
			('Jay'		,'0000000014'	,'jay@litwareinc.com'		,'1979-01-12',	0)
		,	('Darya'	,'0000000032'	,'darya.p@proseware.net'	,'1980-05-22',	1)
		,	('Tomasz'	,'0000000102'	,NULL						,'1959-03-30',	2)
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
