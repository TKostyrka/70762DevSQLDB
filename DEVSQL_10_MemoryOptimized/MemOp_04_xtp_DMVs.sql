
	USE [imoltp]; 
	GO

	SELECT 
		t.name
	,	d.*
	FROM		sys.tables AS t
	INNER JOIN	sys.dm_db_xtp_table_memory_stats AS d ON t.object_id = d.object_id
