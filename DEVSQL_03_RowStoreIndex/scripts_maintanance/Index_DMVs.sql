--	INDEX STATS
--	----------------------------------------------------------------------------------------------------

	--	sys.dm_db_index_usage_stats 
	--	----------------------------------------------------------------------------------------------------
	--	Use this DMV to review the use of indexes to
	--	resolve queries.

	--	To get a quick overview of which indexes are being used, you can use the
	--	sys.dm_db_index_usage_stats DMV as shown in Listing 4-7. To appear in this DMV’s
	--	output, an index must be read or written to at least once by a user or system operation. In
	--	this example, the count of user seeks, scans, and lookups are aggregated as user_reads and
	--	sorted in descending order to make it clear which indexes are used more frequently than
	--	others. Counts in this DMV are reset when the server restarts or when an index is dropped
	--	and recreated.

	--	sys.dm_db_index_physical_stats 
	--	----------------------------------------------------------------------------------------------------
	--	Use this dynamic management function (DMF) to
	--	check the overall status of indexes in a database.

	--	In addition to reviewing usage of indexes, you should also review index health by using the
	--	sys.dm_db_index_physical_stats DMF. As inserts, updates, and deletes occur, an index
	--	becomes increasingly fragmented and IO increases as data is no longer efficiently stored on
	--	disk. Listing 4-10 shows how to review fragmentation. In general, you should focus on
	--	indexes for which fragmentation is greater than 15percent and the page count is greater than
	--	500. When fragmentation is between 15 percent and 30 percent, you should reorganize the
	--	index, and when its greater, you should rebuild it.

--	MISSING INDEX
--	----------------------------------------------------------------------------------------------------

	--	When the query optimizer compiles a T-SQL statement, it also tracks up to 500 indexes that
	--	could have been used if they had existed. The following DMVs help you review these
	--	missing indexes:

	--	sys.dm_db_missing_index_details 
	--	----------------------------------------------------------------------------------------------------
	--	Use this DMV to identify the columns used for
	--	equality and inequality predicates.

	--	sys.dm_db_missing_index_groups 
	--	----------------------------------------------------------------------------------------------------
	--	Use this DMV as an intermediary between
	--	sys.dm_db_index_details and sys.dm_db_missing_group_stats.

	--	sys.dm_db_missing_index_group_stats 
	--	----------------------------------------------------------------------------------------------------
	--	Use this DMV to retrieve metrics on a
	--	group of missing indexes.
