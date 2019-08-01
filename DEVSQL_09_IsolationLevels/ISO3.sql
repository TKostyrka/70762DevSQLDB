USE [ContosoRetailDW]
GO

--------------------------------------------------------

	SELECT *
	FROM sys.objects as o
	WHERE 1=1
	AND o.name = 'IsoTest'

	SELECT *
	FROM sys.dm_tran_locks

--------------------------------------------------------

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		--	READ UNCOMMITTED
		--	READ COMMITTED

	SELECT *
	FROM IsoTest