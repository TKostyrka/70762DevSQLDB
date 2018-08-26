USE [TestTSQL]
GO

SET NOCOUNT ON 
;


	CREATE TABLE Orders1
	(
			OrderNum	INT IDENTITY(1,1) NOT NULL PRIMARY KEY
		,	Quantity	INT				
		,	UnitCost	NUMERIC(10,2)	
		,	UnitPrice	NUMERIC(10,2)	
		,	TotalCost	AS Quantity	* UnitCost
		,	TotalPrice	AS Quantity	* UnitPrice
		,	UnitMargin	AS UnitPrice - UnitCost 
		,	TotalMargin	AS Quantity * (UnitPrice - UnitCost )
	)
	GO

-----------------------------------------------------------

	CREATE TABLE Orders2
	(
			OrderNum	INT IDENTITY(1,1) NOT NULL PRIMARY KEY
		,	Quantity	INT				
		,	UnitCost	NUMERIC(10,2)	
		,	UnitPrice	NUMERIC(10,2)	
		,	TotalCost	AS Quantity	* UnitCost						PERSISTED
		,	TotalPrice	AS Quantity	* UnitPrice						PERSISTED
		,	UnitMargin	AS UnitPrice - UnitCost 					PERSISTED
		,	TotalMargin	AS Quantity * (UnitPrice - UnitCost )		PERSISTED
	)
	GO

---------------------------------------------------------------------------------

	DECLARE @i INT = 0
	DECLARE @Quantity	INT
	DECLARE @UnitCost	NUMERIC(10,2)
	DECLARE @Margin		NUMERIC(10,2)

	WHILE @i < 100000
	BEGIN
	
		SET @Quantity	=	CAST(RAND() * 100 AS INT)
		SET @UnitCost	=	CAST(RAND() * 50 AS NUMERIC(10,2))
		SET @Margin		=	CAST(RAND() * 10 AS NUMERIC(10,2))

		INSERT INTO [Orders1]
		SELECT 
			@Quantity	
		,	@UnitCost	
		,	@UnitCost	+ @Margin

		INSERT INTO [Orders2]
		SELECT 
			@Quantity	
		,	@UnitCost	
		,	@UnitCost	+ @Margin
	
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
		AND [t].[name] IN ('Orders1', 'Orders2')
		AND [s].[name] =	'dbo'
	GROUP BY
		[t].[name]
	,   [s].[name]
	ORDER BY
		[t].[name];

---------------------------------------------------------------------------------