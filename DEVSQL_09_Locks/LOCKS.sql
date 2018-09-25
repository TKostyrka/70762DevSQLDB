--	Resource locks
-----------------------------------------------------------------------------------------------------------
--	SQL Server locks the minimum number of resources required to complete a transaction. It
--	uses different types of locks to support as much concurrency as possible while maintaining
--	data consistency and transaction isolation. The SQL Server Lock Manager chooses the lock
--	mode and resources to lock based on the operation to be performed, the amount of data to
--	be affected by the operation, and the isolation level type (described in Skill 3.2). It also
--	manages the compatibility of locks on the same resources, resolves deadlocks when
--	possible, and escalates locks when necessary (as described in Skill 3.3).

--	SQL Server takes locks on resources at several levels to provide the necessary
--	protection for a transaction. This group of locks at varying levels of granularity is known
--	as a lock hierarchy and consists of one or more of the following lock modes:

--	Shared (S) 
-----------------------------------------------------------------------------------------------------------
--	This lock mode, also known as a read lock, is used for SELECT,
--	INSERT, UPDATE, and DELETE operations and is released as soon as data has
--	been read from the locked resource. While the resource is locked, other transactions
--	cannot change its data. However, in theory, an unlimited number of shared (s) locks
--	can exist on a resource simultaneously. You can force SQL Server to hold the lock for
--	the duration of the transaction by adding the HOLDLOCK table hint.

--	Update (U)
-----------------------------------------------------------------------------------------------------------
--	SQL Server takes this lock on a resource that might be updated in order
--	to prevent a common type of deadlocking, which we describe further in Skill 3.3.
--	Only one update (U) lock can exist on a resource at a time. When a transaction
--	modifies the resource, SQL Server converts the update (U) lock to an exclusive (X)
--	lock.

--	Exclusive (X)
-----------------------------------------------------------------------------------------------------------
--	This lock mode protects a resource during INSERT, UPDATE, or
--	DELETE operations to prevent that resource from multiple concurrent changes.
--	While the lock is held, no other transaction can read or modify the data, unless a
--	statement uses the NOLOCK hint or a transaction runs under the read uncommitted
--	isolation level as we describe in Skill 3.2

--	Intent 
-----------------------------------------------------------------------------------------------------------
--	An intent lock establishes a lock hierarchy to protect a resource at a lower
--	level from getting a shared (S) lock or exclusive (X) lock. Technically speaking,
--	intent locks are not true locks, but rather serve as an indicator that actual locks exist
--	at a lower level. That way, another transaction cannot try to acquire a lock at the
--	higher level that is incompatible with the existing lock at the lower level. There are
--	six types of intent locks:

--	Intent shared (IS) With this lock mode, SQL Server protects requested or
--	acquired shared (S) locks on some resources lower in the lock hierarchy.

--	Intent exclusive (IX) This lock mode is a superset of intent shared (IS) locks that
--	not only protects locks on resources lower in the hierarchy, but also protects
--	requested or acquired exclusive (X) locks on some resources lower in the
--	hierarchy.

--	Shared with intent exclusive (SIX) This lock mode protects requested or acquired
--	shared (S) locks on all resources lower in the hierarchy and intent exclusive (IX)
--	locks on some resources lower in the hierarchy. Only one shared with intent
--	exclusive (SIX) lock can exist at a time for a resource to prevent other transactions
--	from modifying it. However, lower level resources can have intent shared (IS)
--	locks and can be read by other transactions.

--	Intent update (IU) SQL Server uses this lock mode on page resources only to
--	protect requested or acquired update (U) locks on all lower-level resources and
--	converts it to an intent exclusive (IX) lock if a transaction performs an update
--	operation.

--	Shared intent update (SIU) This lock mode is a combination of shared (S) and
--	intent update (IU) locks and occurs when a transaction acquires each lock
--	separately but holds them at the same time.

--	Update intent exclusive (UIX) This lock mode results from a combination of
--	update (U) and intent exclusive (IX) locks that a transaction acquires separately but
--	holds at the same time.

--	Schema 
-----------------------------------------------------------------------------------------------------------
--	SQL Server acquires this lock when an operation depends the table’s
--	schema. There are two types of schema locks:

--	Schema modification (Sch-M) This lock mode prevents other transactions from
--	reading from or writing to a table during a Data Definition Language (DDL)
--	operation, such as removing a column. Some Data Manipulation Language (DML)
--	operations, such as truncating a table, also require a schema modification (Sch-M)
--	lock.

--	Schema stability (Sch-S) SQL Server uses this lock mode during query
--	compilation and execution to block concurrent DDL operations and concurrent
--	DML operations requiring a schema modification (Sch-M) lock from accessing a
--	table.

--	Bulk Update (BU) 
-----------------------------------------------------------------------------------------------------------
--	This lock mode is used for bulk copy operations to allow
--	multiple threads to bulk load data into the same table at the same time and to prevent
--	other transactions that are not bulk loading data from accessing the table. SQL Server
--	acquires it when the table lock on bulk load table option is set by using
--	sp_tableoption or when you use a TABLOCK.

--	Key-range 
-----------------------------------------------------------------------------------------------------------
--	A key-range lock is applied to a range of rows that is read by a query
--	with the SERIALIZABLE isolation level to prevent other transactions from inserting
--	rows that would be returned in the serializable transaction if the same query executes
--	again. In other words, this lock mode prevents phantom reads within the set of rows
--	that the transaction reads.

--	RangeS-S 
-----------------------------------------------------------------------------------------------------------
--	This lock mode is a shared range, shared resource lock used for a
--	serializable range scan.

--	RangeS-U 
-----------------------------------------------------------------------------------------------------------
--	This lock mode is a shared range, update resource lock used for a
--	serializable update scan.

--	RangeI-N 
-----------------------------------------------------------------------------------------------------------
--	This lock mode is an insert range, null resource lock that SQL Server
--	acquires to test a range before inserting a new key into an index.

--	RangeX-X 
-----------------------------------------------------------------------------------------------------------
--	This lock mode is an exclusive range, exclusive resource lock used
--	when updating a key in a range.


-----------------------------------------------------------------------------------------------------------
--	SQL Server can acquire a lock on any of the following resources to ensure that the user
--	of that resource has a consistent view of the data throughout a transaction:

--	RID 
-----------------------------------------------------------------------------------------------------------
--	A row identifier for the single row to lock within a heap and is acquired when
--	possible to provide the highest possible concurrency.

--	KEY 
-----------------------------------------------------------------------------------------------------------
--	A key or range of keys in an index for a serializable transaction can be locked
--	in one of two ways depending on the isolation level. If a transaction runs in the
--	READ COMMITTED or REPEATABLE READ isolation level, the index keys of the
--	accessed rows are locked. If the table has a clustered index, SQL Server acquires
--	key locks instead of row locks because the data rows are the leaf-level of the index.
--	If a transaction runs in the SERIALIZABLE isolation mode, SQL Server acquires
--	key-range locks to prevent phantom reads.

--	PAGE 
-----------------------------------------------------------------------------------------------------------
--	An 8-kilobyte (KB) data or index page gets locked when a transaction reads
--	all rows on a page or when page-level maintenance, such as updating page pointers
--	after a page-split, is performed.

--	EXTENT 
-----------------------------------------------------------------------------------------------------------
--	A contiguous block of eight data or index pages gets a shared (S) or
--	exclusive (X) locks typically during space allocation and de-allocation.

--	HoBT 
-----------------------------------------------------------------------------------------------------------
--	A heap or B-Tree lock can be an entire index or all data pages of a heap.
--	Table An entire table, including both data and indexes, can be locked for SELECT,
--	UPDATE, or DELETE operations.

--	File 
-----------------------------------------------------------------------------------------------------------
--	A database file can be locked individually.

--	Application 
-----------------------------------------------------------------------------------------------------------
--	A resource defined by your application can be locked by using
--	sp_getapplock so that you can lock any resource you want with a specified lock
--	mode.

--	Metadata 
-----------------------------------------------------------------------------------------------------------
--	Any system metadata can be locked to protect system catalog information.

--	Allocation unit 
-----------------------------------------------------------------------------------------------------------
--	An database allocation unit used for storage of data can be locked.

--	Database 
-----------------------------------------------------------------------------------------------------------
--	An entire database gets a shared (S) lock to indicate it is currently in use
--	so that another process cannot drop it, take it offline, or restore it.