Enable collection of execution statistics for natively compiled stored
procedures
The goal of using memory-optimized tables is to execute processes as quickly as possible.
Consequently, you could be surprised that some statistics, such as worker_time and
elapsed_time, do not get collected by DMVs such as sys.dm_exec_query_stats and
sys.dm_exec_procedure_stats. In fact, these DMVs include no information about natively
compiled stored procedures.
Instead, you need to specifically enable the collection of execution statistics by using
one of the following system stored procedures:
sys.sp_xtp_control_proc_exec_stats Use this system stored procedure to enable
statistics collection for your SQL Server instance at the procedure level.
sys.sp_xtp_control_query_exec_stats Use this system stored procedure to enable
statistics collection at the query level for selected natively compiled stored
procedures.

sys.sp_xtp_control_proc_exec_stats
Use the sys.sp_xtp_control_proc_exec_stats system stored procedure to enable and disable
procedure-level statistics collection on your SQL Server instance, as shown in Listing 3-
16. When SQL Server or a database starts, statistics collection is automatically disabled.
Note that you must be a member of the sysadmin role to execute this stored procedure.

sys.sp_xtp_control_query_exec_stats
Listing 3-17 shows an example of using the sys.sp_xtp_control_query_exec_stats system
procedure to enable and disable query-level statistics collection. You can even use it to
enable statistics collection for a specific natively compiled stored procedure, but it must
have been executed at least once before you enable statistics collection. When SQL Server
starts, query-level statistics collection is automatically disabled. Note that disabling
statistics collection at the procedure level does not disable any statistics collection that you
have configured at the query level. As with the previous system stored procedure, you must
be a member of the sysadmin role to execute sys.sp_xtp_control_query_exec_stats.
