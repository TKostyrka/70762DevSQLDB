
--	Recreate DATABASE
-----------------------------------------------------------

	USE [master];
	GO

	DROP DATABASE IF EXISTS [FileAndParts]
	GO

	CREATE DATABASE [FileAndParts]
	GO

	USE [FileAndParts]
	GO


--	list files and filegroups
-----------------------------------------------------------
	
	DROP VIEW IF EXISTS [v_FilesAndGroups];
	GO

	CREATE	VIEW [v_FilesAndGroups]
	AS
	SELECT
		[fg].[data_space_id]
	,	[fg].[name]			AS [fg_name]
	,	[fg].[type_desc]	AS [fg_type]
	,	[fg].[is_default]
	,	[f].[file_id]
	,	[f].[type_desc]		AS [f_type]
	,	[f].[name]			AS [f_name]
	,	[f].[physical_name]
	,	[f].[state_desc]
	,	[f].[size]
	FROM
		[sys].[filegroups]				AS [fg]
	INNER JOIN [sys].[database_files] AS [f] ON [f].[data_space_id] = [fg].[data_space_id];
	GO

	SELECT	*
	FROM
		[v_FilesAndGroups];
	GO

--	Add Filegroups
-----------------------------------------------------------

	ALTER DATABASE [FileAndParts] ADD FILEGROUP [FastFG];
	ALTER DATABASE [FileAndParts] ADD FILEGROUP [SlowFG];

	SELECT
		[fg].[name]
	,	[fg].[data_space_id]
	FROM
		[sys].[filegroups] AS [fg];
	GO

--	CREATE AddFile Procedure
-----------------------------------------------------------
	
	DROP PROC IF EXISTS AddFileToFG
	GO

	CREATE PROC [AddFileToFG]
		@FileGroup	NVARCHAR(100)
	,	@FileName	NVARCHAR(100)
	AS
	BEGIN

		DECLARE
			@fDataPath	NVARCHAR(255)
		,	@sqlcmd		NVARCHAR(MAX);
		SELECT
			@fDataPath	= CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(255));

		SELECT
			@sqlcmd = N'
				ALTER DATABASE [FileAndParts] 
				ADD FILE (	NAME		=	''' + @FileName + N''', 
							FILENAME	=	''' + @fDataPath + @FileName + N'.ndf'' 
							) 
							TO FILEGROUP ' + @FileGroup + N';
			';

		EXEC(@sqlcmd);

	END;
	GO

--	ADD Files to Filegroups
-----------------------------------------------------------

	EXEC AddFileToFG '[FastFG]','FastFile01'
	EXEC AddFileToFG '[FastFG]','FastFile02'
	EXEC AddFileToFG '[FastFG]','FastFile03'

	EXEC AddFileToFG '[SlowFG]','SlowFile01'
	EXEC AddFileToFG '[SlowFG]','SlowFile02'
	EXEC AddFileToFG '[SlowFG]','SlowFile03'

--	list files and filegroups
-----------------------------------------------------------

	SELECT *
	FROM [dbo].[v_FilesAndGroups]