--	Review automatic statistics updates
--	----------------------------------------------------------------------------------------------------
--	Statistics are generated when you add an index to a table that contains data or when you run
--	the UPDATE STATISTICS command. In most cases, as illustrated by the previous example,
--	you should allow SQL Server to create and update statistics automatically by setting one of
--	the following database options, each of which is enabled by default:

--	AUTO_UPDATE_STATISTICS 
--	----------------------------------------------------------------------------------------------------
--	SQL Server updates statistics automatically as
--	needed. It determines an update is necessary by using a counter on modifications to
--	column values. This counter is incremented when a row is inserted or deleted or
--	when an indexed column is updated. The counter is reset to 0 when the statistics are
--	generated. When it does this, it acquires compile locks and query plans might require
--	recompilation. You can disable this option by using the sp_autostats system stored
--	procedure.

--	AUTO_UPDATE_STATISTICS_ASYNC 
--	----------------------------------------------------------------------------------------------------
--	When it is enabled, SQL Server updates
--	338
--	statistics asynchronously. That is, SQL Server uses a background thread so as not to
--	block query execution. In this case, the query optimizer might choose a less than
--	optimal query execution plan until the statistics are updated. Use the ALTER
--	DATABASE T-SQL command to disable this option.

--	AUTO_CREATE_STATISTICS 
--	----------------------------------------------------------------------------------------------------
--	During query execution, SQL Server creates
--	statistics on individual columns in query predicates to help the query optimizer
--	improve query plans. Use the ALTER DATABASE T-SQL command to disable this
--	option.

--	----------------------------------------------------------------------------------------------------

--	Even when statistics are set to update automatically, SQL Server does not update
--	statistics unless one of the following thresholds is met:
--	One or more rows is added to an empty table.
--	More than 500 rows are added to a table having fewer than 500 rows.
--	More than 500 rows are added to a table having more than 500 rows and the number
--	of rows added is more than a dynamic percentage of total rows. With a small table
--	under 25,000 rows, this percentage is around 20 percent. As the number of rows in
--	the table increases, the percentage rate that triggers a statistics update is lower. For
--	example, SQL Server updates statistics for a table with 1 billion rows when more
--	than 1 million changes occur, or 0.1 percent. Prior to SQL Server 2016, this
--	threshold was fixed at 20 percent of the original total number of rows in the table
--	which means that 200 million rows were required to trigger an update of statistics.

--	----------------------------------------------------------------------------------------------------

--	You can add any of the following options when using the UPDATE
--	STATISTICS statement.

--	No FULLSCAN or SAMPLE option If you omit the FULLSCAN or
--	SAMPLE option, 
--	SQL Server calculates statistics by computing an
--	appropriate sample size and performing a sample scan.

--	FULLSCAN 
--	SQL Server performs a full scan of the table data or the index
--	to generate more accurate statistics, although this option takes more time
--	and more IO.

--	SAMPLE 
--	With this option, you specify the number or percentage of rows
--	that SQL Server samples when generating the statistics.

--	RESAMPLE 
--	SQL Server generates the statistics using the same sampling
--	ratio that was defined during the previous statistics generation.