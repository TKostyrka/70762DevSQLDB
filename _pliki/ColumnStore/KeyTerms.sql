--	Columnstore
--	-----------------------------------------------------------------------------------------
--	A columnstore is data that's logically organized as a table with rows and columns, 
--	and physically stored in a column-wise data format.

--	Rowstore
--	-----------------------------------------------------------------------------------------
--	A rowstore is data that's logically organized as a table with rows and columns, and physically stored in a row-wise data format. 
--	This format is the traditional way to store relational table data. In SQL Server, rowstore refers to a table where the underlying data storage format is a heap, 
--	a clustered index, or a memory-optimized table.


--	Rowgroup
--	-----------------------------------------------------------------------------------------
--	A rowgroup is a group of rows that are compressed into columnstore format at the same time. 
--	A rowgroup usually contains the maximum number of rows per rowgroup, which is 1,048,576 rows.

--	For high performance and high compression rates, the columnstore index slices the table into rowgroups, 
--	and then compresses each rowgroup in a column-wise manner. The number of rows in the rowgroup must be large enough to improve compression rates, 
--	and small enough to benefit from in-memory operations.

--	Column segment
--	-----------------------------------------------------------------------------------------
--	A column segment is a column of data from within the rowgroup.

--	Each rowgroup contains one column segment for every column in the table.
--	Each column segment is compressed together and stored on physical media.

--	Delta rowgroup
--	-----------------------------------------------------------------------------------------
--	A delta rowgroup is a clustered index that's used only with columnstore indexes. 
--	It improves columnstore compression and performance by storing rows until the number of rows reaches a threshold and are then moved into the columnstore.

--	When a delta rowgroup reaches the maximum number of rows, it becomes closed. A tuple-mover process checks for closed row groups. 
--	If the process finds a closed rowgroup, it compresses the rowgroup and stores it into the columnstore.

--	Deltastore
--	-----------------------------------------------------------------------------------------
--	A columnstore index can have more than one delta rowgroup. All of the delta rowgroups are collectively called the deltastore.

--	During a large bulk load, most of the rows go directly to the columnstore without passing through the deltastore. 
--	Some rows at the end of the bulk load might be too few in number to meet the minimum size of a rowgroup, which is 102,400 rows.
--	As a result, the final rows go to the deltastore instead of the columnstore. 
--	For small bulk loads with less than 102,400 rows, all of the rows go directly to the deltastore.

--	Batch mode execution
--	-----------------------------------------------------------------------------------------
--	Batch mode execution is a query processing method that's used to process multiple rows together. 
--	Batch mode execution is closely integrated with, and optimized around, the columnstore storage format. 
--	Batch mode execution is sometimes known as vector-based or vectorized execution. Queries on columnstore indexes use batch mode execution, 
--	which improves query performance typically by two to four times. For more information, see the Query processing architecture guide.
