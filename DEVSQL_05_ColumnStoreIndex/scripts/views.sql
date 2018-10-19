USE [ContosoRetailDW]
GO

	DROP TABLE IF EXISTS [dbo].[FactOnlineSalesCS]
	GO

--------------------------------------------------------------

	CREATE TABLE [dbo].[FactOnlineSalesCS]
	(
		[OnlineSalesKey]	[int]		NOT NULL
	,	[DateKey]			[datetime]	NOT NULL
	,	[StoreKey]			[int]		NOT NULL
	,	[ProductKey]		[int]		NOT NULL
	,	[PromotionKey]		[int]		NOT NULL
	,	[CurrencyKey]		[int]		NOT NULL
	,	[CustomerKey]		[int]		NOT NULL
	,	[SalesQuantity]		[int]		NOT NULL
	,	[SalesAmount]		[money]		NOT NULL
	,	[ReturnQuantity]	[int]		NOT NULL
	,	[ReturnAmount]		[money]		NULL
	,	[DiscountQuantity]	[int]		NULL
	,	[DiscountAmount]	[money]		NULL
	,	[TotalCost]			[money]		NOT NULL
	)
	GO

--------------------------------------------------------------

	CREATE CLUSTERED COLUMNSTORE INDEX [CCIX_FactOnlineSalesCS] 
	ON [dbo].[FactOnlineSalesCS];
	GO

--------------------------------------------------------------

	INSERT INTO [dbo].[FactOnlineSalesCS] WITH (TABLOCK) 
	(
		[OnlineSalesKey]	
	,	[DateKey]			
	,	[StoreKey]			
	,	[ProductKey]		
	,	[PromotionKey]		
	,	[CurrencyKey]		
	,	[CustomerKey]		
	,	[SalesQuantity]		
	,	[SalesAmount]		
	,	[ReturnQuantity]	
	,	[ReturnAmount]		
	,	[DiscountQuantity]	
	,	[DiscountAmount]	
	,	[TotalCost]			
	)
	SELECT TOP (2100000)
		[OnlineSalesKey]	
	,	[DateKey]			
	,	[StoreKey]			
	,	[ProductKey]		
	,	[PromotionKey]		
	,	[CurrencyKey]		
	,	[CustomerKey]		
	,	[SalesQuantity]		
	,	[SalesAmount]		
	,	[ReturnQuantity]	
	,	[ReturnAmount]		
	,	[DiscountQuantity]	
	,	[DiscountAmount]	
	,	[TotalCost]		
	FROM [dbo].[FactOnlineSales]
	ORDER BY [CustomerKey]
	GO

--------------------------------------------------------------
	
	CREATE PROC #CheckStats
	AS
	BEGIN
		SELECT 
			o.[name]
		,	v.[row_group_id]
		,	v.[state_desc]
		,	v.[total_rows]
		,	v.[deleted_rows]
		FROM 
					[sys].[objects] AS o
		INNER JOIN	[sys].[dm_db_column_store_row_group_physical_stats] AS v ON o.[object_id] = v.[object_id]
		WHERE 1=1
		AND o.[name] = 'FactOnlineSalesCS'
		ORDER BY v.row_group_id
	END

	EXEC #CheckStats

--------------------------------------------------------------

	SELECT CustomerKey, COUNT(*)
	FROM [dbo].[FactOnlineSalesCS]
	WHERE 1=1
	AND CustomerKey IN (10, 11, 12)
	GROUP BY CustomerKey
	ORDER BY [CustomerKey]

	DELETE 
	FROM [dbo].[FactOnlineSalesCS]
	WHERE 1=1
	AND CustomerKey = 10

	EXEC #CheckStats

	DELETE 
	FROM [dbo].[FactOnlineSalesCS]
	WHERE 1=1
	AND DateKey BETWEEN '20070101' AND '20070110'

	EXEC #CheckStats

	ALTER INDEX [CCIX_FactOnlineSalesCS] 
	ON [dbo].[FactOnlineSalesCS]
	REORGANIZE WITH (COMPRESS_ALL_ROW_GROUPS = ON);

	EXEC #CheckStats

	UPDATE [dbo].[FactOnlineSalesCS]
	SET DateKey = '19000101'
	WHERE 1=1
	AND DateKey BETWEEN '20070111' AND '20070112'

	EXEC #CheckStats

	ALTER INDEX [CCIX_FactOnlineSalesCS] 
	ON [dbo].[FactOnlineSalesCS]
	REBUILD;

	EXEC #CheckStats

--------------------------------------------------------------

	UPDATE [dbo].[FactOnlineSalesCS]
	SET DateKey = '19000101'
	WHERE 1=1
	AND DateKey BETWEEN '20070113' AND '20070120'

	EXEC #CheckStats

--------------------------------------------------------------

	SELECT COUNT(*)
	FROM [dbo].[FactOnlineSalesCS]

	SELECT SUM(total_rows), SUM(deleted_rows)
	FROM 
				[sys].[objects] AS o
	INNER JOIN	[sys].[dm_db_column_store_row_group_physical_stats] AS v ON o.[object_id] = v.[object_id]
	WHERE 1=1
	AND o.[name] = 'FactOnlineSalesCS'


--	If you want force a delta rowgroup closed and compressed, you can execute the following command. You may want run this command if you are done loading the rows and don't expect any new rows. By explicitly closing and compressing the delta rowgroup, you can save storage further and improve the analytics query performance. A best practice is to invoke this command if you don't expect new rows to be inserted.

--SQL

--Copy
--ALTER INDEX <index-name> on <table-name> REORGANIZE with (COMPRESS_ALL_ROW_GROUPS = ON) 


--	state_desc

--	INVISIBLE
--	A row group that is being built. For example: 
--	A row group in the columnstore is INVISIBLE while the data is being compressed. 
--	When the compression is finished a metadata switch changes the state of the columnstore row group from INVISIBLE to COMPRESSED, 
--	and the state of the deltastore row group from CLOSED to TOMBSTONE.

--	OPEN
--	A deltastore row group that is accepting new rows. 
--	An open row group is still in rowstore format and has not been compressed to columnstore format.

--	CLOSED
--	A row group in the delta store that contains the maximum number of rows, 
--	and is waiting for the tuple mover process to compress it into the columnstore.

--	COMPRESSED
--	A row group that is compressed with columnstore compression and stored in the columnstore.

--	TOMBSTONE
--	A row group that was formerly in the deltastore and is no longer used.