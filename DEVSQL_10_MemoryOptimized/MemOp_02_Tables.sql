	USE [imoltp]; 
	GO

-----------------------------------------------------------------------------------------------------------------------------------------

	DROP TABLE		IF EXISTS [Table_Disc]
	DROP TABLE		IF EXISTS [Table_Memory_Sch] 
	DROP TABLE		IF EXISTS [Table_Memory_SchAndData]
	GO 
	 
-----------------------------------------------------------------------------------------------------------------------------------------

	CREATE TABLE [dbo].[Table_Disc] 
	(  
	  c1 INT		NOT NULL PRIMARY KEY,  
	  c2 NCHAR(48)	NOT NULL  
	)
	GO  

	CREATE TABLE [dbo].[Table_Memory_Sch]
	(  
		c1 INT			NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),  
		c2 NCHAR(48)	NOT NULL  
	) 
	WITH (	MEMORY_OPTIMIZED	=	ON, 
			DURABILITY			=	SCHEMA_ONLY
			);  
	GO 	 

	CREATE TABLE [dbo].[Table_Memory_SchAndData]
	(  
		c1 INT			NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT=1000000),  
		c2 NCHAR(48)	NOT NULL  
	) 
	WITH (	MEMORY_OPTIMIZED	=	ON, 
			DURABILITY			=	SCHEMA_AND_DATA
			);  
	GO  

-----------------------------------------------------------------------------------------------------------------------------------------

	SELECT
		t.[object_id]
	,	t.[name]
	,	t.[is_memory_optimized]
	,	t.[durability]
	,	t.[durability_desc]
	FROM sys.tables AS t
	ORDER BY t.name

	

