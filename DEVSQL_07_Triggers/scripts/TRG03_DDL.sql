USE [master]
GO

DROP TRIGGER IF EXISTS [DDLTestTrigger] ON ALL SERVER
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
	WITH PASSWORD		=	N'abc123!@#', 
	DEFAULT_DATABASE	=	[master]

	ALTER SERVER ROLE [sysadmin] 
	ADD MEMBER [TestowyUserSQL]
	GO

--	DDL Trigger
---------------------------------------------------------------------------------------------------

	CREATE TABLE [Examples762]..[LogsDDL]
	(
		Id				INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
		LogTime			DATETIME2(0)	NOT NULL,
		DDLStatement	NVARCHAR(max)	NOT NULL,
		LoginName		NVARCHAR(100)	NOT NULL
	);
	GO

	CREATE TRIGGER DDLTestTrigger
	ON ALL SERVER
	WITH EXECUTE AS 'TestowyUserSQL'
	FOR CREATE_DATABASE, ALTER_DATABASE, DROP_DATABASE
	AS
	BEGIN
		SET NOCOUNT ON;

		INSERT INTO [Examples762]..[LogsDDL]
		(
				LogTime
			,	DDLStatement
			,	LoginName
		)
		SELECT 
			[LogTime]		=	SYSDATETIME(),
			[DDLStatement]	=	EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)'),
			[LoginName]		=	ORIGINAL_LOGIN()
		;
	END

	--	https://docs.microsoft.com/en-us/sql/t-sql/functions/eventdata-transact-sql?view=sql-server-2017
	--	https://docs.microsoft.com/en-us/sql/relational-databases/triggers/use-the-eventdata-function?view=sql-server-2017
	--	https://docs.microsoft.com/en-us/sql/relational-databases/triggers/ddl-events?view=sql-server-2017

--	Check Logs:
---------------------------------------------------------------------------------------------------

	CREATE DATABASE Example
	GO

	ALTER DATABASE Example SET RECOVERY SIMPLE;
	GO

	DROP DATABASE Example;
	GO

--	Check Logs:
---------------------------------------------------------------------------------------------------

	SELECT *
	FROM [Examples762]..[LogsDDL]


--	DROP TRIGGER !!!!
---------------------------------------------------------------------------------------------------

	DROP TRIGGER IF EXISTS [DDLTestTrigger] ON ALL SERVER
	GO