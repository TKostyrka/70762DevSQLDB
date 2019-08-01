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
	
	TRUNCATE TABLE IsoTest
	;

	INSERT INTO IsoTest
	VALUES(1,200),(2,200),(3,499)

	INSERT INTO IsoTest
	VALUES(4,500),(5,300),(6,499)	

	INSERT INTO IsoTest
	VALUES(4,200),(5,200),(6,200)

	--------------------------------------------------

	UPDATE IsoTest
	SET Val = 1000
	WHERE Id = 1

	UPDATE IsoTest
	SET Val = 1000
	WHERE Id = 2