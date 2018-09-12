--	LOCKS
--	----------------------------------------------------------------------------------------------------
--	You can use the following dynamic management views (DMVs) to view information
--	about locks:

--	sys.dm_tran_locks 
--	----------------------------------------------------------------------------------------------------
--	Use this DMV to view all current locks, the lock resources, lock
--	mode, and other related information.

--	The sys.dm_tran_locks DMV provides you with information about existing locks and locks
--	that have been requested but not yet granted in addition to details about the resource for
--	which the lock is requested. You can use this DMV only to view information at the current
--	point in time. It does not provide access to historical information about locks. Table 3-2
--	describes each column in sys.dm_tran_locks.

--	sys.dm_os_waiting_tasks 
--	----------------------------------------------------------------------------------------------------
--	Use this DMV to see which tasks are waiting for a
--	resource.

--	Another useful DMV is sys.dm_os_waiting_tasks. Whenever a user asks you why a query
--	is taking longer to run than usual, a review of this DMV should be one of your standard
--	troubleshooting steps.

--	sys.dm_os_wait_stats 
--	----------------------------------------------------------------------------------------------------
--	Use this DMV to see how often processes are waiting while
--	locks are taken.

--	The sys.dm_os_wait_stats DMV is an aggregate view of all waits that occur when a
--	requested resource is not available, a worker thread is idle typically due to background
--	tasks, or an external event must complete first.



