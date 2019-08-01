USE [ContosoRetailDW]
GO

	INSERT INTO IsoTest
	VALUES(1,200),(2,300),(3,499)

	INSERT INTO IsoTest
	VALUES(4,200),(5,300),(6,499)

	--------------------------------------------------

	UPDATE IsoTest
	SET Val = 1000
	WHERE Id = 1

	UPDATE IsoTest
	SET Val = 1000
	WHERE Id = 2