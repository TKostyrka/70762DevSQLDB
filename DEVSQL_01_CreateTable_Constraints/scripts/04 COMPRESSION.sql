USE [TestTSQL] 
GO

SET NOCOUNT ON	
;

CREATE TABLE [dbo].[LargeTbl]
(
		LargeTblKey		INT				NOT NULL	IDENTITY(1,1) PRIMARY KEY
	,	LargeTblNum		NUMERIC(10,2)	NULL
	,	LargeTblColVC	VARCHAR(50)		NULL
	,	LargeTblBigInt1	BIGINT			NULL
	,	LargeTblBigInt2	BIGINT			NULL
	,	RandomTextCase	VARCHAR(50)
)
WITH (DATA_COMPRESSION = NONE)
GO

---------------------------------------------------------------------------------

DECLARE @i INT = 0

WHILE @i < 100000
BEGIN
	
	INSERT INTO [LargeTbl]
	SELECT 
		RAND() * 100
	,	CAST(NEWID() AS VARCHAR(50))
	,	CHECKSUM(RAND())
	,	CHECKSUM(NEWID())
	,	CASE CAST(RAND() * 5 AS INT)
			WHEN 0 THEN	'afjksdhfbsjdhfbjsaSasADASDDAS'
			WHEN 1 THEN	'afjksdhfbsjdhfbjsASDAFEERHBGDFG'
			WHEN 2 THEN	'afjksdhfbsjdhfbjs11243TBDJRJBR'
			WHEN 3 THEN	'afjksdhfbsjdhfbjs657W46EIUXVYGZ'
			WHEN 4 THEN	'afjksdhfbsjdhfbjs42	6YW4VRVZEVZVR 3'
			END
	
	SET @i = @i + 1

END

---------------------------------------------------------------------------------

	SELECT
		[TableName]		=	[t].[name]
	,   [SchemaName]	=	[s].[name]
	,   [RowCounts]		=	SUM([p].[rows])
	,   [TotalSpaceMB]	=	CAST(ROUND(( ( SUM([a].[total_pages]) * 8 ) / 1024.00 ), 2) AS NUMERIC(36, 2))
	,   [UsedSpaceMB]	=	CAST(ROUND(( ( SUM([a].[used_pages]) * 8 ) / 1024.00 ), 2) AS NUMERIC(36, 2))
	FROM
				[sys].[tables]				AS [t]
	INNER JOIN	[sys].[schemas]				AS [s]    ON [t].[schema_id]	= [s].[schema_id]
	INNER JOIN	[sys].[indexes]				AS [i]    ON [t].[object_id]	= [i].[object_id]
	INNER JOIN	[sys].[partitions]			AS [p]    ON [i].[object_id]	= [p].[object_id]       AND [i].[index_id] = [p].[index_id]
	INNER JOIN	[sys].[allocation_units]	AS [a]    ON [p].[partition_id] = [a].[container_id]

	WHERE 1=1
		AND [t].[name] LIKE 'LargeTbl'
		AND [s].[name] =	'dbo'
	GROUP BY
		[t].[name]
	,   [s].[name]
	ORDER BY
		[t].[name];

---------------------------------------------------------------------------------

	ALTER TABLE [dbo].[LargeTbl]
	REBUILD PARTITION = ALL
	WITH (DATA_COMPRESSION = NONE)
	GO

---------------------------------------------------------------------------------

	ALTER TABLE [dbo].[LargeTbl]
	REBUILD PARTITION = ALL
	WITH (DATA_COMPRESSION = ROW)
	GO

---------------------------------------------------------------------------------

	ALTER TABLE [dbo].[LargeTbl]
	REBUILD PARTITION = ALL
	WITH (DATA_COMPRESSION = PAGE)
	GO



