--	READ COMMITTED
-----------------------------------------------------------------------------------------------------------
--	READ COMMITTED is the default isolation level for SQL Server. It uses pessimistic
--	locking to protect data. With this isolation level set, a transaction cannot read uncommitted
--	data that is being added or changed by another transaction. A transaction attempting to read
--	data that is currently being changed is blocked until the transaction changing the data
--	releases the lock. 

--	A transaction running under this isolation level issues shared locks, but
--	releases row or page locks after reading a row. If your query scans an index while another
--	transactions changes the index key column of a row, that row could appear twice in the
--	query results if that key change moved the row to a new position ahead of the scan. Another
--	option is that it might not appear at all if the row moved to a position already read by the
--	scan.

--	READ UNCOMMITTED
-----------------------------------------------------------------------------------------------------------
--	The READ UNCOMMITTED isolation level is the least restrictive setting. It allows a
--	transaction to read data that has not yet been committed by other transactions. SQL Server
--	ignores any locks and reads data from memory. 

--	Furthermore, transactions running under
--	this isolation level do not acquire shared (S) locks to prevent other transactions from
--	changing the data being read. Last, if a transaction is reading rows using an allocation
--	order scan when another transaction causes a page split, your query can miss rows. For
--	these reasons, READ UNCOMMITTED is never a good choice for line of business
--	applications where accuracy matters most, but might be acceptable for a reporting
--	application where the performance benefit outweighs the need for a precise value.

--	REPEATABLE READ
-----------------------------------------------------------------------------------------------------------
--	When you set the REPEATABLE READ isolation level, you ensure that any data read by
--	one transaction is not changed by another transaction. That way, the transaction can repeat a
--	query and get identical results each time. In this case, the data is protected by shared (S)
--	locks. 

--	It is important to note that the only data protected is the existing data that has been
--	read. If another transaction inserts a new row, the first transaction’s repeat of its query
--	could return this row as a phantom read.

--	SERIALIZABLE
-----------------------------------------------------------------------------------------------------------
--	The most pessimistic isolation level is SERIALIZABLE, which uses range locks on the
--	data to not only prevent changes but also insertions. Therefore, phantom reads are not
--	possible when you set this isolation level. Each transaction is completely isolated from one
--	another even when they execute in parallel or overlap.

--	SNAPSHOT
-----------------------------------------------------------------------------------------------------------
--	The SNAPSHOT isolation level is optimistic and allows read and write operations to run
--	concurrently without blocking one another. Unlike the other isolation levels, you must first
--	configure the database to allow it, and then you can set the isolation level for a transaction.
--	As long as a transaction is open, SQL Server preserves the state of committed data at the
--	start of the transaction and stores any changes to the data by other transactions in tempdb. It
--	increases concurrency by eliminating the need for locks for read operations.
--	Note SNAPSHOT isolation and distributed transactions
--	You cannot use SNAPSHOT isolation with distributed transactions. In
--	addition, you cannot use enable it in the following databases: master, msdb,
--	and tempdb.

--	Read Committed Snapshot
-----------------------------------------------------------------------------------------------------------
--	The READ_COMMITTED_SNAPSHOT isolation level is an optimistic alternative to
--	READ COMMITTED. Like the SNAPSHOT isolation level, you must first enable it at the
--	database level before setting it for a transaction. Unlike SNAPSHOT isolation, you can use
--	the READ_COMMITTED_SNAPSHOT isolation level with distributed transactions. The
--	key difference between the two isolation levels is the ability with
--	READ_COMMITTED_SNAPSHOT for a transaction to repeatedly read data as it was at
--	the start of the read statement rather than at the start of the transaction. When each statement
--	executes within a transaction, SQL Server takes a new snapshot that remains consistent
--	until the next statement executes.