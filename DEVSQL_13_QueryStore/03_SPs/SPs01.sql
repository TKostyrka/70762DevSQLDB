USE [QStoreTEST]
GO	

-----------------------------------------------------------
	
	DROP PROC IF EXISTS #QSReport
	GO

	CREATE PROC #QSReport
	AS
	BEGIN 
		SELECT
			q.[query_id]
		,	q.[object_id]
		,	o.[name]
		,	q.[count_compiles]
		,	p.[plan_id]
		,	p.[query_plan]
		,	p.[count_compiles]
		,	[avg_duration]	=	ROUND(r.[avg_duration], 2)
		,	[min_duration]	=	ROUND(r.[min_duration], 2)
		,	[max_duration]	=	ROUND(r.[max_duration], 2)
		FROM	
					sys.[query_store_query]			AS	q
		INNER JOIN	sys.[objects]					AS	o	ON	q.[object_id]		=	o.[object_id]
		LEFT JOIN	sys.[query_store_query_text]	AS	t	ON	q.[query_text_id]	=	t.[query_text_id]
		LEFT JOIN	sys.[query_store_plan]			AS	p	ON	q.[query_id]		=	p.[query_id]
		LEFT JOIN	sys.[query_store_runtime_stats]	AS	r	ON	p.[plan_id]			=	r.[plan_id]
	END
	GO

-----------------------------------------------------------

	EXEC #QSReport

-----------------------------------------------------------
	
	EXEC sp_query_store_reset_exec_stats 15 -- (plan_id)
	EXEC #QSReport

-----------------------------------------------------------
	
	EXEC sp_query_store_remove_plan 16 -- (plan_id)
	EXEC #QSReport

-----------------------------------------------------------
	
	EXEC sp_query_store_remove_query 15 -- (query_id)
	EXEC #QSReport
