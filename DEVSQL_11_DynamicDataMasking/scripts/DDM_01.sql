USE [master]
GO

DROP DATABASE IF EXISTS [Examples762]
GO

CREATE DATABASE [Examples762]
GO

USE [Examples762]
GO

--	Dynamic data masking lets you mask data in a column from the view of the user. So while the
--	user may have all rights to a column, (INSERT, UPDATE, DELETE, SELECT), when they use the
--	column in a SELECT statement, instead of showing them the actual data, it masks it from their
--	view.

	DROP TABLE IF EXISTS [dbo].[DataMasking]
	;

	CREATE TABLE [dbo].[DataMasking]
	(
		[FirstName]		NVARCHAR(50)	NULL
	,	[LastName]		NVARCHAR(50)	NOT NULL
	,	[PersonNumber]	CHAR(10)		NOT NULL
	,	[Status]		VARCHAR(10)		NULL		
	,	[EmailAddress]	NVARCHAR(50)	NULL		
	,	[BirthDate]		DATE			NOT NULL	
	,	[CarCount]		TINYINT			NOT NULL	
	);
	GO

	INSERT INTO [dbo].[DataMasking]
	(
		[FirstName]		
	,	[LastName]		
	,	[PersonNumber]	
	,	[Status]		
	,	[EmailAddress]	
	,	[BirthDate]		
	,	[CarCount]		
	)
	VALUES
		('Jay',		'Hamlin',	'0000000014',	'Active',	'jay@litwareinc.com',		'1979-01-12',	0)
	,	('Darya',	'Popkova',	'0000000032',	'Active',	'darya.p@proseware.net',	'1980-05-22',	1)
	,	('Tomasz',	'Bochenek',	'0000000102',	'Active',	NULL,						'1959-03-30',	1)
	GO

	SELECT *
	FROM [dbo].[DataMasking]
	GO

--	There are four types of data mask functions that we can apply:
--	Default :	Takes the default mask of the data type (not of the DEFAULT constraint OF the column, but the data type).
--	Email	:	Masks the email so you only see a few meaningful characters.
--	Random	:	Masks any of the numeric data types (int, smallint, decimal, etc) with a random value within a range.
--	Partial :	Allows you to take values from the front and back of a value, replacing the center with a fixed string value.

	ALTER TABLE [dbo].[DataMasking]
	ALTER COLUMN [FirstName]
	ADD MASKED WITH (FUNCTION = 'default()');

	ALTER TABLE [dbo].[DataMasking]
	ALTER COLUMN [LastName]
	ADD MASKED WITH (FUNCTION = 'partial(3,"_____",2)');

	ALTER TABLE [dbo].[DataMasking]
	ALTER COLUMN [PersonNumber]
	ADD MASKED WITH (FUNCTION = 'partial(2,"*******",1)');

	ALTER TABLE [dbo].[DataMasking]
	ALTER COLUMN [Status]
	ADD MASKED WITH (FUNCTION = 'partial(0,"Unknown",0)');

	ALTER TABLE [dbo].[DataMasking]
	ALTER COLUMN [EmailAddress]
	ADD MASKED WITH (FUNCTION = 'email()');

	ALTER TABLE [dbo].[DataMasking]
	ALTER COLUMN [BirthDate]
	ADD MASKED WITH (FUNCTION = 'default()');

	ALTER TABLE [dbo].[DataMasking]
	ALTER COLUMN [CarCount]
	ADD MASKED WITH (FUNCTION = 'random(1,3)');
	GO

-------------------------------------------------------------------

	SELECT *
	FROM [dbo].[DataMasking]
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

--	
-------------------------------------------------------------------

	EXECUTE AS USER = 'TestowyUserSQL';
	SELECT *
	FROM [dbo].[DataMasking];
	REVERT;

--	GRANT UNMASK
-------------------------------------------------------------------
	
	GRANT UNMASK 
	TO [TestowyUserSQL];	

	EXECUTE AS USER = 'TestowyUserSQL';
	SELECT *
	FROM [dbo].[DataMasking];
	REVERT;

--	REVOKE UNMASK
-------------------------------------------------------------------

	REVOKE UNMASK 
	TO [TestowyUserSQL];	

	EXECUTE AS USER = 'TestowyUserSQL';
	SELECT *
	FROM [dbo].[DataMasking];
	REVERT;

--	Simplified syntax
-------------------------------------------------------------------

	CREATE TABLE [dbo].[DataMasking2]
	(
		[FirstName]		NVARCHAR(50)	MASKED WITH (FUNCTION = 'default()')				NULL		
	,	[BirthDate]		DATE			MASKED WITH (FUNCTION = 'default()')				NOT NULL		
	,	[EmailAddress]	NVARCHAR(50)	MASKED WITH (FUNCTION = 'email()')					NULL
	,	[PersonNumber]	CHAR(10)		MASKED WITH (FUNCTION = 'partial(2,"*******",1)')	NOT NULL
	);
	GO

	INSERT INTO [dbo].[DataMasking2]
	(
		[FirstName]		
	,	[PersonNumber]	
	,	[EmailAddress]	
	,	[BirthDate]		
	)
	VALUES
		('Jay',		'0000000014',	'jay@litwareinc.com',		'1979-01-12')
	,	('Darya',	'0000000032',	'darya.p@proseware.net',	'1980-05-22')
	,	('Tomasz',	'0000000102',	NULL,						'1959-03-30')
	GO

--	
-------------------------------------------------------------------

	EXECUTE AS USER = 'TestowyUserSQL';
	SELECT *
	FROM [dbo].[DataMasking2];
	REVERT;

	SELECT *
	FROM [dbo].[DataMasking2];