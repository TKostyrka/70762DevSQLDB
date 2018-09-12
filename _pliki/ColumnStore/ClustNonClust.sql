--	Clustered columnstore index
--	-----------------------------------------------------------------------------------------
--	A clustered columnstore index is the physical storage for the entire table.

--	To reduce fragmentation of the column segments and improve performance, 
--	the columnstore index might store some data temporarily into a clustered index called a deltastore and a btree list of IDs for deleted rows. 
--	The deltastore operations are handled behind the scenes. To return the correct query results, 
--	the clustered columnstore index combines query results from both the columnstore and the deltastore.

--	Nonclustered columnstore index
--	-----------------------------------------------------------------------------------------
--	A nonclustered columnstore index and a clustered columnstore index function the same. 
--	The difference is that a nonclustered index is a secondary index that's created on a rowstore table, 
--	but a clustered columnstore index is the primary storage for the entire table.

--	The nonclustered index contains a copy of part or all of the rows and columns in the underlying table. 
--	The index is defined as one or more columns of the table and has an optional condition that filters the rows.

--	A nonclustered columnstore index enables real-time operational analytics 
--	where the OLTP workload uses the underlying clustered index while analytics run concurrently on the columnstore index.