USE [TestDB]
GO

IF OBJECT_ID('TestowaProcedura1') IS NOT NULL DROP PROC [dbo].[TestowaProcedura1]
GO

	CREATE PROC [dbo].[TestowaProcedura1]
	AS
	BEGIN

		PRINT 'host: ' + HOST_NAME()
		;

		PRINT 'user: ' + SUSER_SNAME()
		;

		PRINT 'data: ' + CAST(GETDATE() AS VARCHAR(100))
		;

	END

---------------------------------------------------------

	EXEC [dbo].[TestowaProcedura1]

---------------------------------------------------------
