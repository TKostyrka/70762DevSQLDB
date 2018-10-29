
	USE [imoltp]; 
	GO

	--	DROP SP IF EXIST
	-----------------------------------------------------------------------------------------------------------------------------------------

		DROP PROCEDURE	IF EXISTS [NativeCompSP_OnTableSchema]  
		DROP PROCEDURE	IF EXISTS [NativeCompSP_OnTableSchemaAndData] 
		GO 

	--	DROP TABLES IF EXIST 
	-----------------------------------------------------------------------------------------------------------------------------------------

		DROP TABLE		IF EXISTS [dbo].[Table_Disc]
		DROP TABLE		IF EXISTS [dbo].[Table_Memory_Schema_TestA]
		DROP TABLE		IF EXISTS [dbo].[Table_Memory_Schema_TestB]
		DROP TABLE		IF EXISTS [dbo].[Table_Memory_SchemaAndData_TestA]
		DROP TABLE		IF EXISTS [dbo].[Table_Memory_SchemaAndData_TestB]
		GO

	--	CREATE TABLES
	-----------------------------------------------------------------------------------------------------------------------------------------
		
		CREATE TABLE [dbo].[Table_Disc] 
		(  
		  c1 INT		NOT NULL PRIMARY KEY,  
		  c2 NCHAR(48)	NOT NULL  
		)
		GO

		--------------------------

		CREATE TABLE [dbo].[Table_Memory_Schema_TestA]
		(  
			c1 INT			NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),  
			c2 NCHAR(48)	NOT NULL  
		) 
		WITH (	MEMORY_OPTIMIZED	=	ON, 
				DURABILITY			=	SCHEMA_ONLY
				);  
		GO 
		
		-------------------------- 

		CREATE TABLE [dbo].[Table_Memory_Schema_TestB]
		(  
			c1 INT			NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),  
			c2 NCHAR(48)	NOT NULL  
		) 
		WITH (	MEMORY_OPTIMIZED	=	ON, 
				DURABILITY			=	SCHEMA_ONLY
				);  
		GO  

		--------------------------

		CREATE TABLE [dbo].[Table_Memory_SchemaAndData_TestA]
		(  
			c1 INT			NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),  
			c2 NCHAR(48)	NOT NULL  
		) 
		WITH (	MEMORY_OPTIMIZED	=	ON, 
				DURABILITY			=	SCHEMA_AND_DATA
				);  
		GO  

		--------------------------

		CREATE TABLE [dbo].[Table_Memory_SchemaAndData_TestB]
		(  
			c1 INT			NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),  
			c2 NCHAR(48)	NOT NULL  
		) 
		WITH (	MEMORY_OPTIMIZED	=	ON, 
				DURABILITY			=	SCHEMA_AND_DATA
				);  
		GO  

	--	CREATE SPs
	-----------------------------------------------------------------------------------------------------------------------------------------

		CREATE PROCEDURE [dbo].[NativeCompSP_OnTableSchema]  
				@rowcount	INT,  
				@c			NCHAR(48)  
		WITH 
			NATIVE_COMPILATION
		,	SCHEMABINDING 
		AS   
		BEGIN ATOMIC   
		WITH (	TRANSACTION ISOLATION LEVEL = SNAPSHOT, 
				LANGUAGE = N'us_english'
				)  
		
			DECLARE @i INT = 1;  

			WHILE @i <= @rowcount  
				BEGIN;  
				INSERT INTO [dbo].[Table_Memory_Schema_TestA] VALUES (@i, @c);  
				SET @i += 1;  
			END;  
		END;  
		GO

		--------------------------
	
		CREATE PROCEDURE [dbo].[NativeCompSP_OnTableSchemaAndData]   
				@rowcount	INT,  
				@c			NCHAR(48)  
		WITH 
			NATIVE_COMPILATION
		,	SCHEMABINDING 
		AS   
		BEGIN ATOMIC   
		WITH (	TRANSACTION ISOLATION LEVEL = SNAPSHOT, 
				LANGUAGE = N'us_english'
				)  
		
			DECLARE @i INT = 1;  

			WHILE @i <= @rowcount  
				BEGIN;  
				INSERT INTO [dbo].[Table_Memory_SchemaAndData_TestA] VALUES (@i, @c);  
				SET @i += 1;  
			END;  
		END;  
		GO
	 
-----------------------------------------------------------------------------------------------------------------------------------------


	SET STATISTICS TIME OFF;  
	SET NOCOUNT ON;  

	-- Inserts, one at a time.  
	--------------------------------------------------------------------------------------------

		DECLARE @starttime	DATETIME2 = sysdatetime();  
		DECLARE @timems		INT;  
		DECLARE @i			INT = 1;  
		DECLARE @rowcount	INT = 10000;  
		DECLARE @c			NCHAR(48) = N'12345678901234567890123456789012345678';  

	-- (A)	Harddrive-based table and interpreted Transact-SQL.  
	--------------------------------------------------------------------------------------------

		BEGIN TRAN;  
			WHILE @i <= @rowcount  
			BEGIN;  
				INSERT INTO [dbo].[Table_Disc] VALUES (@i, @c);  
				SET @i += 1;  
			END;  
		COMMIT;  

		SET @timems = datediff(ms, @starttime, sysdatetime());  
		PRINT 'A: Disk-based table and interpreted Transact-SQL: ' + cast(@timems AS VARCHAR(10)) + ' ms'
		;

	-- (B)	MemoryOpt table and interpreted Transact-SQL. (SchemaAndData)
	--------------------------------------------------------------------------------------------

		SET @i = 1;  
		SET @starttime = sysdatetime();  

		BEGIN TRAN;  
			WHILE @i <= @rowcount  
			BEGIN;  
				INSERT INTO [dbo].[Table_Memory_SchemaAndData_TestB] VALUES (@i, @c);  
				SET @i += 1;  
			END;  
		COMMIT;  

		SET @timems = datediff(ms, @starttime, sysdatetime());  
		PRINT 'B: memory-optimized table with hash index and interpreted Transact-SQL (SchemaAndData): ' 
			+ cast(@timems as VARCHAR(10)) + ' ms'
		; 

	-- (C)	MemoryOpt table and interpreted Transact-SQL. (SchemaOnly)
	--------------------------------------------------------------------------------------------

		SET @i = 1;  
		SET @starttime = sysdatetime();  

		BEGIN TRAN;  
			WHILE @i <= @rowcount  
			BEGIN;  
				INSERT INTO [dbo].[Table_Memory_Schema_TestB] VALUES (@i, @c);  
				SET @i += 1;  
			END;  
		COMMIT;  

		SET @timems = datediff(ms, @starttime, sysdatetime());  
		PRINT 'C: memory-optimized table with hash index and interpreted Transact-SQL (SchemaOnly): ' 
			+ cast(@timems as VARCHAR(10)) + ' ms'
		;   

	-- (D)	MemoryOpt + NativeComp SP (SchemaAndData)
	--------------------------------------------------------------------------------------------

		SET @starttime = sysdatetime();  

		EXECUTE [dbo].[NativeCompSP_OnTableSchemaAndData]  @rowcount, @c;  

		SET @timems = datediff(ms, @starttime, sysdatetime());  
		PRINT 'C: memory-optimized table with hash index and native SP (SchemaAndData):' 
			+ cast(@timems as varchar(10)) + ' ms';  
		;   

	-- (E)	MemoryOpt + NativeComp SP (SchemaOnly)
	--------------------------------------------------------------------------------------------

		SET @starttime = sysdatetime();  

		EXECUTE [dbo].[NativeCompSP_OnTableSchema] @rowcount, @c;  

		SET @timems = datediff(ms, @starttime, sysdatetime());  
		PRINT 'C: memory-optimized table with hash index and native SP (SchemaOnly):' 
			+ cast(@timems as varchar(10)) + ' ms';  
		GO  
