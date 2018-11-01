USE [ExEvTEST]
GO

	--------------------------------------------------------------------------------

		IF EXISTS(	SELECT * 
					FROM sys.server_event_sessions 
					WHERE [name] = 'MyLongQueries'
					)
		BEGIN
			DROP EVENT SESSION MyLongQueries 
			ON SERVER
		END
		GO

	--------------------------------------------------------------------------------
		
		CREATE EVENT SESSION MyLongQueries
		ON SERVER
		ADD EVENT sqlserver.sql_statement_completed 
		( 
			ACTION (sqlserver.sql_text)
			WHERE duration > 20000
		)
		GO

		ALTER EVENT SESSION MyLongQueries
		ON SERVER
		ADD TARGET package0.synchronous_bucketizer 
		( 
			SET 
				filtering_event_name	=	'sqlserver.sql_statement_completed' 
			,	source_type				=	1
			,	source					=	'sqlserver.sql_text'
		)
		GO

	--------------------------------------------------------------------------------

		DECLARE @sessname NVARCHAR(100) = 'MyLongQueries'
		
		SELECT s.* 
		FROM 
			sys.server_event_sessions			AS s
		WHERE 1=1
		AND s.[name] = @sessname

		---------------------------

		SELECT 
			e.*
		,	a.*  
		FROM 
					sys.server_event_sessions			AS s
		LEFT JOIN	sys.server_event_session_events		AS e ON s.[event_session_id] =	e.[event_session_id]
		LEFT JOIN	sys.server_event_session_actions	AS a ON s.[event_session_id] =	a.[event_session_id]
		WHERE 1=1
		AND s.[name] = @sessname

		---------------------------

		SELECT t.*, f.* 
		FROM 
					sys.server_event_sessions			AS s
		LEFT JOIN	sys.server_event_session_targets	AS t ON s.[event_session_id]	= t.[event_session_id]
		LEFT JOIN	sys.server_event_session_fields		AS f ON t.[target_id]			= f.[object_id]
		WHERE 1=1
		AND s.[name] = @sessname

	--------------------------------------------------------------------------------

		ALTER EVENT SESSION MyLongQueries
		ON SERVER
		STATE = START
		GO

	--------------------------------------------------------------------------------

		ALTER EVENT SESSION MyLongQueries
		ON SERVER
		STATE = STOP
		GO

