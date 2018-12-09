
	USE [CCI]
	GO

-----------------------------------------------------------

	DROP VIEW IF EXISTS [dbo].[CSOverwiew_00]
	GO

	CREATE VIEW [dbo].[CSOverwiew_00]
	AS
	SELECT
		[TableName]						 = [t].[name]
	,	[SchemaName]					 = [s].[name]
	,	[partition_number]				 = [v].[partition_number]
	,	[row_group_id]					 = [v].[row_group_id]
	,	[state]							 = [v].[state_desc]
	,	[total_rows]					 = [v].[total_rows]
	,	[total_rows_in_partition]		 = SUM([v].[total_rows]) OVER (PARTITION BY [v].[object_id], [v].[partition_number])
	,	[deleted_rows]					 = [v].[deleted_rows]

	FROM
		[sys].[schemas]											   AS [s]
	INNER JOIN [sys].[tables]									   AS [t] ON [t].[schema_id] = [s].[schema_id]
	INNER JOIN [sys].[dm_db_column_store_row_group_physical_stats] AS [v] ON [t].[object_id] = [v].[object_id]
	GO

	SELECT *
	FROM [dbo].[CSOverwiew_00]
	WHERE [TableName] = 'FactSales'
	GO

-----------------------------------------------------------
	
	DROP VIEW IF EXISTS [dbo].[CSOverwiew_01]
	GO

	CREATE VIEW [dbo].[CSOverwiew_01]
	AS
	SELECT
		[TableName]						 = [t].[name]
	,	[SchemaName]					 = [s].[name]
	,	[IndexName]						 = [i].[name]
	,	[IndexType]						 = [i].[type_desc]
	,	[partition_number]				 = [v].[partition_number]
	,	[row_group_id]					 = [v].[row_group_id]
	,	[delta_store_hobt_id]			 = [v].[delta_store_hobt_id]
	,	[state]							 = [v].[state_desc]
	,	[total_rows]					 = [v].[total_rows]
	,	[deleted_rows]					 = [v].[deleted_rows]
	,	[trim_reason]					 = [v].[trim_reason_desc]
	,	[transition_to_compressed_state] = [v].[transition_to_compressed_state_desc]
	,	[has_vertipaq_optimization]		 = [v].[has_vertipaq_optimization]
	,	[generation]					 = [v].[generation]

	FROM
		[sys].[schemas]											   AS [s]
	INNER JOIN [sys].[tables]									   AS [t] ON [t].[schema_id] = [s].[schema_id]
	INNER JOIN [sys].[indexes]									   AS [i] ON [i].[object_id] = [t].[object_id]
	INNER JOIN [sys].[partitions]								   AS [p] ON [p].[object_id] = [i].[object_id]
																			 AND [p].[index_id] = [i].[index_id]
	INNER JOIN [sys].[dm_db_column_store_row_group_physical_stats] AS [v] ON [t].[object_id] = [v].[object_id]
																			 AND [v].[index_id] = [i].[index_id]
																			 AND [v].[partition_number] = [p].[partition_number]
	GO

	SELECT *
	FROM [dbo].[CSOverwiew_01]
	WHERE [TableName] = 'FactSales'
	GO

-----------------------------------------------------------

	--	state:
	-----------------------------------------------------------

		--	0 = INVISIBLE
		--	1 = OPEN
		--	2 = CLOSED
		--	3 = COMPRESSED
		--	4 = TOMBSTONE

		--	INVISIBLE	–	A row group that is being built. For example:  A row group in the columnstore is INVISIBLE while the data is being compressed. 
		--					When the compression is finished a metadata switch changes the state of the columnstore row group from INVISIBLE to COMPRESSED, 
		--					and the state of the deltastore row group from CLOSED to TOMBSTONE.
		--	OPEN		–	A deltastore row group that is accepting new rows. An open row group is still in rowstore format and has not been compressed to columnstore format.
		--	CLOSED		–	A row group in the delta store that contains the maximum number of rows, and is waiting for the tuple mover process to compress it into the columnstore.
		--	COMPRESSED	–	A row group that is compressed with columnstore compression and stored in the columnstore.
		--	TOMBSTONE	–	A row group that was formerly in the deltastore and is no longer used.

	--	trim_reason:
	--	Reason that triggered the COMPRESSED row group to have less than the maximum number of rows.
	-----------------------------------------------------------

		--	0 – UNKNOWN_UPGRADED_FROM_PREVIOUS_VERSION
		--	1 - NO_TRIM
		--	2 - BULKLOAD
		--	3 – REORG
		--	4 – DICTIONARY_SIZE
		--	5 – MEMORY_LIMITATION
		--	6 – RESIDUAL_ROW_GROUP
		--	7 - STATS_MISMATCH
		--	8 - SPILLOVER

		--	0 –	UNKNOWN_UPGRADED_FROM_PREVIOUS_VERSION: Occurred when upgrading from the previous version of SQL Server.
		--	1 -	NO_TRIM: The row group was not trimmed. The row group was compressed with the maximum of 1,048,476 rows. 
		--		The number of rows could be less if a subsset of rows was deleted after delta rowgroup was closed
		--	2 –	BULKLOAD: The bulk load batch size limited the number of rows.
		--	3 –	REORG: Forced compression as part of REORG command.
		--	4 –	DICTIONARY_SIZE: Dictionary size grew too big to compress all of the rows together.
		--	5 –	MEMORY_LIMITATION: Not enough available memory to compress all the rows together.
		--	6 –	RESIDUAL_ROW_GROUP: Closed as part of last row group with rows < 1 million during index build operation
		--	7 - STATS_MISMATCH: Only for columnstore on in-memory table. 
		--		IF stats incorrectly indicated >= 1 million qualified rows in the tail but we found fewer, 
		--		the compressed rowgroup will have < 1 million rows
		--	8 - SPILLOVER: Only for columnstore on in-memory table. If tail has > 1 million qualified rows, 
		--		the last batch remaining rows are compressed if the count is between 100k and 1 million

	--	transition_to_compressed_state:
	--	Shows how this rowgroup got moved from the deltastore to a compressed state in the columnstore.
	-----------------------------------------------------------

		--	1 -	NOT_APPLICABLE
		--	2 -	INDEX_BUILD
		--	3 -	TUPLE_MOVER
		--	4 -	REORG_NORMAL
		--	5 -	REORG_FORCED
		--	6 -	BULKLOAD
		--	7 -	MERGE

		--	NOT_APPLICABLE	-	the operation does not apply to the deltastore. 
		--						Or, the rowgroup was compressed prior to upgrading to SQL Server 2016 (13.x) in which case the history is not preserved.
		--	INDEX_BUILD		-	An index create or index rebuild compressed the rowgroup.
		--	TUPLE_MOVER		-	The tuple mover running in the background compressed the rowgroup. 
		--						This happens after the rowgroup changes state from OPEN to CLOSED.
		--	REORG_NORMAL	-	The reorganization operation, ALTER INDEX … REORG, moved the CLOSED rowgroup from the deltastore to the columnstore. 
		--						This occurred before the tuple-mover had time to move the rowgroup.
		--	REORG_FORCED	-	This rowgroup was open in the deltastore and was forced into the columnstore before it had a full number of rows.
		--	BULKLOAD		-	A bulk load operation compressed the rowgroup directly without using the deltastore.
		--	MERGE			-	A merge operation consolidated one or more rowgroups into this rowgroup and then performed the columnstore compression.

	--	has_vertipaq_optimization:
	-----------------------------------------------------------
	--	Vertipaq optimization improves columnstore compression by rearranging the order of the rows in the rowgroup to achieve higher compression. 
	--	This optimization occurs automatically in most cases. 
	--	There are two cases Vertipaq optimization is not used:
		--	a.	when a delta rowgroup moves into the columnstore and there are one or more nonclustered indexes on the columnstore index - 
		--		in this case Vertipaq optimization is skipped to minimizes changes to the mapping index;
		--	b.	for columnstore indexes on memory-optimized tables. 