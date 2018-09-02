--	Deterministic functions always return the same result any time they are called with a specific set of input values and given the same state of the database. 
--	Nondeterministic functions may return different results each time they are called with a specific set of input values 
--	even if the database state that they access remains the same. 

--	For example, the function AVG always returns the same result given the qualifications stated above, but the GETDATE function, 
--	which returns the current datetime value, always returns a different result.
----------------------------------------------------------------------------------------------------------------------------------

--	The following functions are not always deterministic, 
--	but can be used in indexed views or indexes on computed columns when they are specified in a deterministic manner.

--	Function						Comments
----------------------------------------------------------------------------------------------------------------------------------
--	all aggregate functions			All aggregate functions are deterministic unless they are specified with the OVER and ORDER BY clauses. 
--									For a list of these functions, see Aggregate Functions (Transact-SQL).

--	CAST							Deterministic unless used with datetime, smalldatetime, or sql_variant.

--	CONVERT							Deterministic unless one of these conditions exists:
--									Source type is sql_variant.
--									Target type is sql_variant and its source type is nondeterministic.
--									Source or target type is datetime or smalldatetime, the other source or target type is a character string, 
--									and a nondeterministic style is specified. To be deterministic, the style parameter must be a constant. 
--									Additionally, styles less than or equal to 100 are nondeterministic, except for styles 20 and 21. 
--									Styles greater than 100 are deterministic, except for styles 106, 107, 109 and 113.

--	CHECKSUM						Deterministic, with the exception of CHECKSUM(*).
--	ISDATE							Deterministic only if used with the CONVERT function, the CONVERT style parameter is specified and style is not equal to 0, 100, 9, or 109.
--	RAND							RAND is deterministic only when a seed parameter is specified.


--	The following built-in functions from other categories are always nondeterministic.
----------------------------------------------------------------------------------------------------------------------------------

	--	@@CONNECTIONS			GETDATE
	--	@@CPU_BUSY				GETUTCDATE
	--	@@DBTS					GET_TRANSMISSION_STATUS
	--	@@IDLE					LAG
	--	@@IO_BUSY				LAST_VALUE
	--	@@MAX_CONNECTIONS		LEAD
	--	@@PACK_RECEIVED			MIN_ACTIVE_ROWVERSION
	--	@@PACK_SENT				NEWID
	--	@@PACKET_ERRORS			NEWSEQUENTIALID
	--	@@TIMETICKS				NEXT VALUE FOR
	--	@@TOTAL_ERRORS			NTILE
	--	@@TOTAL_READ			PARSENAME
	--	@@TOTAL_WRITE			PERCENTILE_CONT
	--	AT TIME ZONE			PERCENTILE_DISC
	--	CUME_DIST				PERCENT_RANK
	--	CURRENT_TIMESTAMP		RAND
	--	DENSE_RANK				RANK
	--	FIRST_VALUE				ROW_NUMBER
	--	FORMAT					TEXTPTR
	
----------------------------------------------------------------------------------------------------------------------------------

--	Functions that call extended stored procedures are nondeterministic, 
--	because the extended stored procedures can cause side effects on the database. 
--	Side effects are changes to a global state of the database, such as an update to a table, or to an external resource, such as a file or the network; 
--	for example, modifying a file or sending an e-mail message. 
--	Do not rely on returning a consistent result set when executing an extended stored procedure from a user-defined function. 
--	User-defined functions that create side effects on the database are not recommended.