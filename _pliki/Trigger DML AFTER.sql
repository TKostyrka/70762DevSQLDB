USE [master]
GO

DROP DATABASE IF EXISTS [Examples762]
GO

CREATE DATABASE [Examples762]
GO

USE [Examples762]
GO

--	AFTER TRIGGER
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
		ActionCode			CHAR(1)			NOT NULL
	,	EmployeeId			INT				NOT NULL
	,	OLD_EmployeeCode	VARCHAR(3)		
	,	NEW_EmployeeCode	VARCHAR(3)		
	,	OLD_EmployeeName	VARCHAR(100)	
	,	NEW_EmployeeName	VARCHAR(100)	
	)
	GO

	CREATE TRIGGER [Employee_AFT_INS_UPD]
	ON	[Employee]
	AFTER INSERT, UPDATE, DELETE 
	AS
	BEGIN
		
		INSERT INTO [dbo].[EmployeeLogs]
		( 
			[ActionCode]
		,	[EmployeeId]
		,	[OLD_EmployeeCode]
		,	[NEW_EmployeeCode]
		,	[OLD_EmployeeName]
		,	[NEW_EmployeeName]
		)
		SELECT 
				[ActionCode]		=	IIF([d].[EmployeeId] IS NULL, 'I', IIF([i].[EmployeeId] IS NULL, 'D', 'U'))
			,	[EmployeeId]		=	COALESCE([d].[EmployeeId], [i].[EmployeeId])
            ,	[OLD_EmployeeCode]	=	[d].[EmployeeCode]
            ,	[NEW_EmployeeCode]	=	[i].[EmployeeCode]
            ,	[OLD_EmployeeName]	=	[d].[EmployeeName]
            ,	[NEW_EmployeeName]	=	[i].[EmployeeName]
		FROM 
						[Deleted]	AS d
		FULL OUTER JOIN [Inserted]	AS i ON [i].[EmployeeId] = [d].[EmployeeId]
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