USE [master]
GO

DROP TRIGGER IF EXISTS [LogonTrigger] ON ALL SERVER
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

	CREATE TABLE [Examples762]..[LogsLogin]
	(
		LoginLogId		INT				NOT NULL IDENTITY(1,1) PRIMARY KEY,
		LoginName		NVARCHAR(200)	NOT NULL,
		LoggerName		NVARCHAR(200)	NOT NULL,
		AppName			NVARCHAR(200)	NOT NULL,
		LoginTime		DATETIME2(0)	NOT NULL DEFAULT SYSDATETIME()
	)
	GO

---------------------------------------------------------------------------------------------------

	CREATE TRIGGER [LogonTrigger]
	ON ALL SERVER
	WITH EXECUTE AS 'TestowyUserSQL'
	FOR LOGON
	AS
	BEGIN
		INSERT INTO [Examples762]..[LogsLogin]
			(
				LoginName	,
				LoggerName	,
				AppName
			)
		VALUES 
			(
				ORIGINAL_LOGIN(),
				SUSER_SNAME(),
				APP_NAME()
				);
	END
	GO

--	Check Logs:
---------------------------------------------------------------------------------------------------

	SELECT *
	FROM [Examples762]..[LogsLogin]

--	DROP	TRIGGER !!!!!!!!!!!!!
---------------------------------------------------------------------------------------------------

	DROP TRIGGER IF EXISTS [LogonTrigger] ON ALL SERVER
	GO