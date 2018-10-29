	USE [master]
	GO

	DROP DATABASE IF EXISTS [imoltp] 
	GO

	CREATE DATABASE [imoltp] 
	GO

	ALTER DATABASE	[imoltp]
	ADD FILEGROUP	[imoltp_FG]	CONTAINS MEMORY_OPTIMIZED_DATA
	;  

	ALTER DATABASE [imoltp] 
	ADD FILE  
	(
		NAME		= [imoltp_FL], 
		FILENAME	= 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\imoltp_dir'
	)  
	TO FILEGROUP [imoltp_FG]
	GO

	USE [imoltp]; 
	GO

	SELECT 
		fg.[name]
	,	fg.[type_desc]
	,	fl.[file_id]
	,	fl.[type_desc]
	,	fl.[name]
	FROM 
				sys.filegroups		AS fg
	INNER JOIN	sys.database_files	AS fl	ON fg.data_space_id = fl.data_space_id
	GO