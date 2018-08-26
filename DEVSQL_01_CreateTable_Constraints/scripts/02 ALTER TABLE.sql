USE [TestTSQL] 
GO

CREATE TABLE [dbo].[Employee6]
(
		EmpKey			INT				NOT NULL	IDENTITY(1,1)
	,	EmpID			VARCHAR(10)		NOT NULL
	,	EmpFirstName	VARCHAR(100)	NOT NULL 
	,	EmpLastName		VARCHAR(100)	NOT NULL 
	,	EmpJobPosition	VARCHAR(100)	NOT NULL
)
GO

ALTER TABLE [dbo].[Employee6] ADD CONSTRAINT PK_Employee	PRIMARY KEY (EmpKey)
ALTER TABLE [dbo].[Employee6] ADD CONSTRAINT UQ_Employee	UNIQUE		(EmpID)
GO

ALTER TABLE [dbo].[Employee6] ADD BaseSalary	NUMERIC(10,2)	NOT NULL
ALTER TABLE [dbo].[Employee6] ADD BonusRate		INT				NOT NULL
GO

ALTER TABLE [dbo].[Employee6] ADD CONSTRAINT [df_EmpJobPosition]	DEFAULT 'NewEmployee'	FOR EmpJobPosition
ALTER TABLE [dbo].[Employee6] ADD CONSTRAINT [df_BaseSalary]		DEFAULT 0				FOR BaseSalary
ALTER TABLE [dbo].[Employee6] ADD CONSTRAINT [df_BonusRate]			DEFAULT 0				FOR BonusRate	
GO

ALTER TABLE [dbo].[Employee6] ADD CONSTRAINT CheckBaseSalary	CHECK (BaseSalary >= 0)
ALTER TABLE [dbo].[Employee6] ADD CONSTRAINT CheckBonus			CHECK (BonusRate BETWEEN 0 AND 100)
GO