--	https://docs.microsoft.com/en-us/sql/relational-databases/performance/how-query-store-collects-data?view=sql-server-2017
--	----------------------------------------------------------------------------------------------------

	SELECT 
		Txt.query_text_id, 
		Txt.query_sql_text, 
		Pl.plan_id, 
		Qry.*  
	FROM 
				sys.query_store_plan		AS Pl  
	INNER JOIN	sys.query_store_query		AS Qry  ON Pl.query_id			= Qry.query_id 
	INNER JOIN	sys.query_store_query_text	AS Txt  ON Qry.query_text_id	= Txt.query_text_id

--	The following options are available to configure query store parameters.
--	----------------------------------------------------------------------------------------------------

--	OPERATION_MODE
--	----------------------------------------------------------------------------------------------------
--	Can be READ_WRITE (default) or READ_ONLY.

--	CLEANUP_POLICY (STALE_QUERY_THRESHOLD_DAYS)
--	----------------------------------------------------------------------------------------------------
--	Configure the STALE_QUERY_THRESHOLD_DAYS argument to specify the number of days to retain data in the query store. 
--	The default value is 30. For SQL Database Basic edition, default is 7 days.

--	DATA_FLUSH_INTERVAL_SECONDS
--	----------------------------------------------------------------------------------------------------
--	Determines the frequency at which data written to the query store is persisted to disk.
--	To optimize for performance, data collected by the query store is asynchronously written to the disk. 
--	The frequency at which this asynchronous transfer occurs is configured via DATA_FLUSH_INTERVAL_SECONDS. 
--	The default value is 900 (15 min).

--	MAX_STORAGE_SIZE_MB
--	----------------------------------------------------------------------------------------------------
--	Configures the maximum size of the query store. 
--	If the data in the query store hits the MAX_STORAGE_SIZE_MB limit, the query store automatically changes the state from read-write to read-only and stops collecting new data. The default value is 100 MB. For SQL Database Premium edition, default is 1 GB and for SQL Database Basic edition, default is 10 MB.

--	INTERVAL_LENGTH_MINUTES
--	----------------------------------------------------------------------------------------------------
--	Determines the time interval at which runtime execution statistics data is aggregated into the query store. 
--	To optimize for space usage, the runtime execution statistics in the Runtime Stats Store are aggregated over a fixed time window. 
--	This fixed time window is configured via INTERVAL_LENGTH_MINUTES. The default value is 60.

--	SIZE_BASED_CLEANUP_MODE
--	----------------------------------------------------------------------------------------------------
--	Controls whether the cleanup process will be automatically activated when total amount of data gets close to maximum size. 
--	Can be AUTO (default) or OFF.

--	QUERY_CAPTURE_MODE
--	----------------------------------------------------------------------------------------------------
--	Designates if the Query Store captures all queries, or relevant queries based on execution count and resource consumption, 
--	or stops adding new queries and just tracks current queries. 
--	Can be ALL (capture all queries), AUTO (ignore infrequent and queries with insignificant compile and execution duration) or NONE (stop capturing new queries). 
--	The default value on SQL Server (from SQL Server 2016 (13.x) to SQL Server 2017) is ALL, while on Azure SQL Database is AUTO.

--	MAX_PLANS_PER_QUERY
--	----------------------------------------------------------------------------------------------------
--	An integer representing the maximum number of plans maintained for each query. The default value is 200.

--	WAIT_STATS_CAPTURE_MODE
--	----------------------------------------------------------------------------------------------------
--	Controls if Query Store captures wait statistics information. Can be OFF or ON (default).

SELECT *
FROM sys.database_query_store_options