USE [master]
GO

DROP DATABASE IF EXISTS [Examples762]
GO

CREATE DATABASE [Examples762]
GO

USE [Examples762]
GO

--	INSTEAD OF TRIGGER
---------------------------------------------------------------------------------------------------

	CREATE TABLE [Employee]
	(
		EmployeeId		INT				NOT NULL IDENTITY(1,1) PRIMARY KEY
	,	EmployeeCode	VARCHAR(3)		NOT NULL 
	,	EmployeeName	VARCHAR(100)	NOT NULL 
	)
	GO

	CREATE TABLE [EmployeeLogs]
	(
		EmployeeId			INT				NOT NULL
	,	EmployeeCode		VARCHAR(3)		
	,	EmployeeName		VARCHAR(100)	
	,	DeleteAttemptDate	DATETIME		NOT NULL DEFAULT GETDATE()
	,	DeleteAttemptUser	VARCHAR(100)	NOT NULL DEFAULT SUSER_SNAME()
	,	DeleteAttemptHost	VARCHAR(100)	NOT NULL DEFAULT HOST_NAME()
	)
	GO

	CREATE TRIGGER [Employee_AFT_INS_UPD]
	ON	[Employee]
	INSTEAD OF DELETE 
	AS
	BEGIN
		
		INSERT INTO [dbo].[EmployeeLogs]
		( 
			[EmployeeId]
		,	[EmployeeCode]
		,	[EmployeeName]
		)
		SELECT 
				[EmployeeId]		=	[d].[EmployeeId]
            ,	[OLD_EmployeeCode]	=	[d].[EmployeeCode]
            ,	[OLD_EmployeeName]	=	[d].[EmployeeName]
		FROM 
			[Deleted]	AS d
	END
	GO

--	DML Actions
---------------------------------------------------------------------------------------------------
	
	SET NOCOUNT ON;

	INSERT INTO [dbo].[Employee]( [EmployeeCode], [EmployeeName] )
	VALUES	('ABC','KOWALSKI'), ('DEF', 'KOWALSKA')
	;

	UPDATE [dbo].[Employee]
	SET [EmployeeName] = 'NOWAK'
	WHERE [EmployeeCode] = 'ABC'
	;

	DELETE
	FROM [dbo].[Employee]

--	Check Logs
---------------------------------------------------------------------------------------------------

	SELECT *
	FROM [EmployeeLogs]

	SELECT *
	FROM [dbo].[Employee]