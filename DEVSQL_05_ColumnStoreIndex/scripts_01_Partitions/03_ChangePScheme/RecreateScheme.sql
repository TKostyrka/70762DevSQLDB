USE [SaxoWarehouse]
GO

--	step:A01: drop CCI
--	step:A02: create CRI on [PRIMARY]
--	step:A03: drop CRI on [PRIMARY]

	--	recreate PS, PF

--	step:B04: create CRI on [PS]
--	step:B05: drop CRI on [PS]
--	step:B06: CREATE CCI on [PS]

-----------------------------------------------------------------------------------------------
	
	DROP TABLE IF EXISTS [#IndexSQLCmds];
	GO

	SELECT
		[s_name] = [s].[name]
	,	[t_name] = [t].[name]
	,	[i_name] = [i].[name]
	,	[p_name] = [ps].[name]
	,	[A01]	 = 'DROP INDEX ' + [i].[name] + ' ON ' + [s].[name] + '.' + [t].[name]
	,	[A02]	 = 'CREATE CLUSTERED INDEX ' + [i].[name] + ' ON ' + [s].[name] + '.' + [t].[name] + '(' + [c].[name]
				   + ') ON [PRIMARY]'
	,	[A03]	 = 'DROP INDEX ' + [i].[name] + ' ON ' + [s].[name] + '.' + [t].[name]

	,	[B01]	 = 'CREATE CLUSTERED INDEX ' + [i].[name] + ' ON ' + [s].[name] + '.' + [t].[name] + '(' + [c].[name] + ')'
				   + ' ON ' + [ps].[name] + '(' + [c].[name] + ')'
	,	[B02]	 = 'DROP INDEX ' + [i].[name] + ' ON ' + [s].[name] + '.' + [t].[name]
	,	[B03]	 = 'CREATE CLUSTERED COLUMNSTORE INDEX ' + [i].[name] + ' ON ' + [s].[name] + '.' + [t].[name] + ' ON '
				   + [ps].[name] + '(' + [c].[name] + ')'
	INTO
		[#IndexSQLCmds]
	FROM
		[sys].[partition_schemes]	 AS [ps]
	INNER JOIN [sys].[indexes]		 AS [i] ON [ps].[data_space_id] = [i].[data_space_id]
	INNER JOIN [sys].[index_columns] AS [ic] ON [ic].[index_id] = [i].[index_id]
												AND [ic].[object_id] = [i].[object_id]
	INNER JOIN [sys].[columns]		 AS [c] ON [ic].[object_id] = [c].[object_id]
											   AND [ic].[column_id] = [c].[column_id]
	INNER JOIN [sys].[tables]		 AS [t] ON [t].[object_id] = [i].[object_id]
	INNER JOIN [sys].[schemas]		 AS [s] ON [s].[schema_id] = [t].[schema_id]
	WHERE
		1 = 1
		AND [ps].[name] IN ( 'PS_SCHEME_B' )
		AND [ic].[partition_ordinal] = 1
	ORDER BY
		[t].[name];
	GO

-----------------------------------------------------------------------------------------------
	
	DROP TABLE IF EXISTS [#IndexSQLCmdsAggs];
	GO

	SELECT
		[s_name]
	,	[t_name]
	,	[i_name]
	,	[p_name]
	,	[sqlA] = [isc].[A01] + ';' + CHAR(10) + [isc].[A02] + ';' + CHAR(10) + [isc].[A03] + ';' + CHAR(10)
	,	[sqlB] = [isc].[B01] + ';' + CHAR(10) + [isc].[B02] + ';' + CHAR(10) + [isc].[B03] + ';' + CHAR(10)
	INTO [#IndexSQLCmdsAggs]
	FROM
		[#IndexSQLCmds] AS [isc];
	GO

-----------------------------------------------------------------------------------------------
	
	DECLARE @sqlcmd NVARCHAR(MAX)
	;

	DECLARE crs CURSOR FOR   
	SELECT [sqlA] 
	FROM [#IndexSQLCmdsAggs]

		OPEN crs  
		FETCH NEXT FROM crs 
		INTO @sqlcmd  

		WHILE @@FETCH_STATUS = 0  
		BEGIN  

			EXEC(@sqlcmd)

			FETCH NEXT FROM crs 
			INTO @sqlcmd  

		END  

	CLOSE crs  
	DEALLOCATE crs	
	GO

-----------------------------------------------------------------------------------------------

	SELECT
		[ps].[name]
	,	COUNT(*)
	FROM
		[sys].[partition_schemes] AS [ps]
	INNER JOIN [sys].[indexes]	  AS [i] ON [ps].[data_space_id] = [i].[data_space_id]
	WHERE
		1 = 1
		AND [ps].[name] IN ( 'PS_SCHEME_B' )
	GROUP BY
		[ps].[name];

-----------------------------------------------------------------------------------------------

	DROP PARTITION SCHEME [PS_SCHEME_B]

	DROP PARTITION FUNCTION [PF_SCHEME]

	------------

	CREATE PARTITION FUNCTION [PF_SCHEME] (INT)
	AS RANGE LEFT FOR VALUES
	(
		20160101
	,	20160401
	,	20160701
	,	20161001

	,	20170101
	,	20170401
	,	20170701
	,	20171001

	,	20180101
	,	20180401
	,	20180701
	,	20181001

	,	20190101
	,	20190401
	,	20190701
	,	20191001
	);
	GO

	CREATE PARTITION SCHEME [PS_SCHEME_B]
	AS PARTITION [PF_SCHEME]
	TO
	(	
		[PRIMARY]
	,	[PRIMARY]
	,	[PRIMARY]
	,	[PRIMARY]

	,	[PRIMARY]
	,	[PRIMARY]
	,	[PRIMARY]
	,	[PRIMARY]

	,	[PRIMARY]
	,	[PRIMARY]
	,	[PRIMARY]
	,	[PRIMARY]

	,	[PRIMARY]
	,	[PRIMARY]
	,	[PRIMARY]
	,	[PRIMARY]

	,	[PRIMARY]
	);

-----------------------------------------------------------------------------------------------
	
	DECLARE @sqlcmd NVARCHAR(MAX)
	;

	DECLARE crs CURSOR FOR   
	SELECT [sqlB] 
	FROM [#IndexSQLCmdsAggs]

		OPEN crs  
		FETCH NEXT FROM crs 
		INTO @sqlcmd  

		WHILE @@FETCH_STATUS = 0  
		BEGIN  

			EXEC(@sqlcmd)

			FETCH NEXT FROM crs 
			INTO @sqlcmd  

		END  

	CLOSE crs  
	DEALLOCATE crs	
	GO

-----------------------------------------------------------------------------------------------

	SELECT
		[ps].[name]
	,	COUNT(*)
	FROM
		[sys].[partition_schemes] AS [ps]
	INNER JOIN [sys].[indexes]	  AS [i] ON [ps].[data_space_id] = [i].[data_space_id]
	WHERE
		1 = 1
		AND [ps].[name] IN ( 'PS_SCHEME_B' )
	GROUP BY
		[ps].[name];
	GO

-----------------------------------------------------------------------------------------------

	SELECT
		[s_name]  = [s].[name]
	,	[t_name]  = [t].[name]
	,	[i_name]  = [i].[name]
	,	[ps_name] = [ps].[name]
	,	[pc_name] = [c].[name]
	,	[p_count] = COUNT(*)
	,	[rows]	  = SUM([p].[rows])

	FROM
		[sys].[partition_schemes]	 AS [ps]
	INNER JOIN [sys].[indexes]		 AS [i] ON [ps].[data_space_id] = [i].[data_space_id]
	INNER JOIN [sys].[index_columns] AS [ic] ON [ic].[index_id] = [i].[index_id]
												AND [ic].[object_id] = [i].[object_id]
	INNER JOIN [sys].[columns]		 AS [c] ON [ic].[object_id] = [c].[object_id]
											   AND [ic].[column_id] = [c].[column_id]
	INNER JOIN [sys].[tables]		 AS [t] ON [t].[object_id] = [i].[object_id]
	INNER JOIN [sys].[schemas]		 AS [s] ON [s].[schema_id] = [t].[schema_id]
	INNER JOIN [sys].[partitions]	 AS [p] ON [p].[object_id] = [i].[object_id]
											   AND [p].[index_id] = [i].[index_id]
	WHERE
		1 = 1
		AND [ps].[name] IN ( 'PS_SCHEME_B' )
		AND [ic].[partition_ordinal] = 1
	GROUP BY
		[s].[name]
	,	[t].[name]
	,	[i].[name]
	,	[ps].[name]
	,	[c].[name]
	ORDER BY
		[t].[name];
	GO



