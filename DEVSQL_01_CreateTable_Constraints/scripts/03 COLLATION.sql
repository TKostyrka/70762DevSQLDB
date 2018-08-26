USE [TestTSQL] 
GO

CREATE TABLE [dbo].[Names]
(
		NameKey		INT				NOT NULL	IDENTITY(1,1) PRIMARY KEY
	,	NameColCI	VARCHAR(10)		COLLATE Polish_CI_AS
	,	NameColCS	VARCHAR(10)		COLLATE Polish_CS_AS
)
GO


INSERT INTO [dbo].[Names]
VALUES ('Adam', 'Adam'),('ADAM', 'ADAM'),('AdAM', 'AdAM'),('adaM','adaM')
GO


SELECT * 
FROM [dbo].[Names] 
WHERE NameColCI = 'Adam' 
;

SELECT * 
FROM [dbo].[Names] 
WHERE NameColCS = 'Adam' 
;

SELECT * 
FROM [dbo].[Names] 
WHERE NameColCI = NameColCS
;

SELECT * 
FROM [dbo].[Names] 
WHERE NameColCI COLLATE Polish_CS_AS = NameColCS
;