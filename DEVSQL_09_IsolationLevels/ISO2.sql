USE [ContosoRetailDW]
GO

DROP TABLE IF EXISTS IsoTest
;

CREATE TABLE IsoTest
(
		Id	INT		PRIMARY KEY
	,	Val	FLOAT
)
;

BEGIN TRAN
	
	INSERT INTO IsoTest
	VALUES(1, 100)
	
	SELECT @@TRANCOUNT

--	COMMIT
--	ROLLBACK