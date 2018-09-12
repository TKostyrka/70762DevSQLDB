SELECT *
FROM sys.dm_os_wait_stats
ORDER BY 2 desc

SELECT *
FROM sys.dm_os_waiting_tasks

SELECT *
FROM sys.dm_exec_session_wait_stats

--------------------------------------------------------

SELECT *
FROM sys.dm_io_virtual_file_stats

SELECT *
FROM sys.dm_os_performance_counters

---------------------------------------------------------

SELECT * FROM sys.dm_os_memory_cache_counters
SELECT * FROM sys.dm_os_sys_memory
SELECT * FROM sys.dm_os_memory_clerks

---------------------------------------------------------

SELECT * FROM sys.dm_db_index_usage_stats
SELECT * FROM sys.dm_db_index_physical_stats

SELECT * FROM sys.dm_db_missing_index_details
SELECT * FROM sys.dm_db_missing_index_groups
SELECT * FROM sys.dm_db_missing_index_group_stats


