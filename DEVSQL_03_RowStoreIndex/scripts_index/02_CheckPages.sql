--SELECT * FROM sys.[partitions]
--SELECT * FROM sys.[allocation_units]
--SELECT * FROM sys.[system_internals_allocation_units]

USE [AdventureworksDW2016CTP3]
GO

---------------------------------------------

	SELECT *
	FROM sys.[database_files]

---------------------------------------------

	IF OBJECT_ID('dbo.test1') IS NOT NULL DROP TABLE dbo.test1
	IF OBJECT_ID('dbo.test2') IS NOT NULL DROP TABLE dbo.test2

	CREATE TABLE dbo.test1(
		kol1 INT, 
		kol2 VARCHAR(100)
		)

	CREATE TABLE dbo.test2(
		kol1 INT, 
		kol2 VARCHAR(1000), 
		kol3 VARBINARY(MAX)
		)

---------------------------------------------

	SELECT
		[s].[name]
	,	[t].[name]
	,	[p].[rows]
	,	[p].[data_compression_desc]
	,	[a].[type]
	,	[a].[type_desc]
	,	[a].[total_pages]
	,	[a].[used_pages]
	,	[a].[data_pages]
	FROM 
				sys.[tables]			AS t
	INNER JOIN	sys.[schemas]			AS s ON [s].[schema_id] = [t].[schema_id]
	INNER JOIN	sys.[partitions]		AS p ON [p].[object_id] = [t].[object_id]
	INNER JOIN	sys.[allocation_units]  AS a ON a.[container_id] = p.[partition_id]

	WHERE 1=1
	AND s.name = 'dbo'
	AND t.name IN ('FactFinance_Indeksy', 'test1', 'test2')

---------------------------------------------

	SELECT
		[s].[name]
	,	[t].[name]
	,	[p].[rows]
	,	[p].[data_compression_desc]
	,	[a].[allocation_unit_id]
	,	[a].[type]
	,	[a].[type_desc]
	,	[a].[total_pages]
	,	[a].[used_pages]
	,	[a].[data_pages]
	,	[a].[first_page]
	,	[a].[root_page]
	,	[a].[first_iam_page]
	FROM 
				sys.[tables]								AS t
	INNER JOIN	sys.[schemas]								AS s ON [s].[schema_id] = [t].[schema_id]
	INNER JOIN	sys.[partitions]							AS p ON [p].[object_id] = [t].[object_id]
	INNER JOIN	sys.[system_internals_allocation_units]		AS a ON a.[container_id] = p.[partition_id]

	WHERE 1=1
	AND s.name = 'dbo'
	AND t.name = 'FactFinance_Indeksy'

---------------------------------------------

	DBCC IND(0,'dbo.FactFinance_Indeksy',1)

	DBCC TRACEON(3604)
	DBCC PAGE('AdventureworksDW2016CTP3', 1, 459, 3)

---------------------------------------------

-- DBCC IND Page Type

	--	1			– data page
	--	2			– index page
	--	3 and 4		– text pages
	--	8			– GAM page
	--	9			– SGAM page
	--	10			– IAM page
	--	11			– PFS page

-- DBCC IND columns

	--	PageFID			– the file ID of the page
	--	PagePID			– the page number in the file
	--	IAMFID			– the file ID of the IAM page that maps this page (this will be NULL for IAM pages themselves as they’re not self-referential)
	--	IAMPID			– the page number in the file of the IAM page that maps this page
	--	ObjectID			– the ID of the object this page is part of
	--	IndexID			– the ID of the index this page is part of
	--	PartitionNumber	– the partition number (as defined by the partitioning scheme for the index) of the partition this page is part of
	--	PartitionID		– the internal ID of the partition this page is part of

--	DBCC PAGE last parameter:

	--0 – print just the page header 
	--1 – page header plus per-row hex dumps and a dump of the page slot array (unless its a page that doesn’t have one, like allocation bitmaps) 
	--2 – page header plus whole page hex dump 
	--3 – page header plus detailed per-row interpretation