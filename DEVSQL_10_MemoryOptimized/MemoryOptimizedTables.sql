--	https://docs.microsoft.com/en-us/sql/relational-databases/in-memory-oltp/memory-optimized-tables?view=sql-server-2017
--	https://docs.microsoft.com/en-us/sql/relational-databases/in-memory-oltp/creating-and-managing-storage-for-memory-optimized-objects?view=sql-server-2017
--	https://docs.microsoft.com/en-us/sql/relational-databases/in-memory-oltp/in-memory-oltp-in-memory-optimization?view=sql-server-2017
-----------------------------------------------------------------------------------------------------------------------------------------

--	Memory-optimized tables are fully durable by default, and, like transactions on (traditional) disk-based tables, 
--	transactions on memory-optimized tables are fully atomic, consistent, isolated, and durable (ACID). 
--	Memory-optimized tables and natively compiled stored procedures support only a subset of Transact-SQL features.

--	For even greater performance gains, In-Memory OLTP supports durable tables with transaction durability delayed. 
--	Delayed durable transactions are saved to disk soon after the transaction has committed and control was returned to the client. 
--	In exchange for the increased performance, 
--	committed transactions that have not saved to disk are lost in a server crash or fail over.

--	Besides the default durable memory-optimized tables, SQL Server also supports non-durable memory-optimized tables, 
--	which are not logged and their data is not persisted on disk. This means that transactions on these tables do not require any disk IO, 
--	but the data will not be recovered if there is a server crash or failover.


	CREATE DATABASE [imoltp] 
	GO

	ALTER DATABASE	[imoltp]
	ADD FILEGROUP	[imoltp_mod]	CONTAINS MEMORY_OPTIMIZED_DATA
	;  

	ALTER DATABASE [imoltp] 
	ADD FILE  
	(
		NAME		= [imoltp_dir], 
		FILENAME	= 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\imoltp_dir'
	)  
	TO FILEGROUP [imoltp_mod]
	GO

	USE [imoltp]; 
	GO

-----------------------------------------------------------------------------------------------------------------------------------------

	DROP PROCEDURE	IF EXISTS [ncsp]  
	DROP TABLE		IF EXISTS [sql]
	DROP TABLE		IF EXISTS [hash_i]
	DROP TABLE		IF EXISTS [hash_c] 
	GO 
	 
-----------------------------------------------------------------------------------------------------------------------------------------

	CREATE TABLE [dbo].[sql] 
	(  
	  c1 INT		NOT NULL PRIMARY KEY,  
	  c2 NCHAR(48)	NOT NULL  
	)
	GO  

	CREATE TABLE [dbo].[hash_i]
	(  
		c1 INT			NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),  
		c2 NCHAR(48)	NOT NULL  
	) 
	WITH (	MEMORY_OPTIMIZED	=	ON, 
			DURABILITY			=	SCHEMA_AND_DATA
			);  
	GO  

	CREATE TABLE [dbo].[hash_c]
	(  
		c1 INT			NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),  
		c2 NCHAR(48)	NOT NULL  
	) 
	WITH (	MEMORY_OPTIMIZED	=	ON, 
			DURABILITY			=	SCHEMA_AND_DATA
			);  
	GO 
	 
-----------------------------------------------------------------------------------------------------------------------------------------

	CREATE PROCEDURE [ncsp]  
			@rowcount	INT,  
			@c			NCHAR(48)  
		WITH NATIVE_COMPILATION, 
		SCHEMABINDING, 
		EXECUTE AS OWNER  
	AS   
	BEGIN ATOMIC   
	WITH (	TRANSACTION ISOLATION LEVEL = SNAPSHOT, 
			LANGUAGE = N'us_english'
			)  
		
		DECLARE @i INT = 1;  

		WHILE @i <= @rowcount  
			BEGIN;  
			INSERT INTO [dbo].[hash_c] VALUES (@i, @c);  
			SET @i += 1;  
		END;  
	END;  
	GO
	 
-----------------------------------------------------------------------------------------------------------------------------------------


	SET STATISTICS TIME OFF;  
	SET NOCOUNT ON;  

	-- Inserts, one at a time.  

		DECLARE @starttime	DATETIME2 = sysdatetime();  
		DECLARE @timems		INT;  
		DECLARE @i			INT = 1;  
		DECLARE @rowcount	INT = 100000;  
		DECLARE @c			NCHAR(48) = N'12345678901234567890123456789012345678';  

	-- Harddrive-based table and interpreted Transact-SQL.  

		BEGIN TRAN;  
			WHILE @i <= @rowcount  
			BEGIN;  
				INSERT INTO [dbo].[sql] VALUES (@i, @c);  
				SET @i += 1;  
			END;  
		COMMIT;  

		SET @timems = datediff(ms, @starttime, sysdatetime());  
		PRINT 'A: Disk-based table and interpreted Transact-SQL: ' + cast(@timems AS VARCHAR(10)) + ' ms';  

	-- Interop Hash.  

		SET @i = 1;  
		SET @starttime = sysdatetime();  

		BEGIN TRAN;  
			WHILE @i <= @rowcount  
			BEGIN;  
				INSERT INTO [dbo].[hash_i] VALUES (@i, @c);  
				SET @i += 1;  
			END;  
		COMMIT;  

		SET @timems = datediff(ms, @starttime, sysdatetime());  
		PRINT 'B: memory-optimized table with hash index and interpreted Transact-SQL: ' + cast(@timems as VARCHAR(10)) + ' ms';  

	-- Compiled Hash.  

		SET @starttime = sysdatetime();  

		EXECUTE ncsp @rowcount, @c;  

		SET @timems = datediff(ms, @starttime, sysdatetime());  
		PRINT 'C: memory-optimized table with hash index and native SP:' + cast(@timems as varchar(10)) + ' ms';  
		GO  

		DELETE [sql];  
		DELETE [hash_i];  
		DELETE [hash_c];  
		GO