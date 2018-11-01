USE [QStoreTEST]
GO	
	
	-------------------------------------------------

	SELECT
		q.[query_id]
	,	q.[object_id]
	,	o.[name]
	,	q.[count_compiles]
	,	t.[query_sql_text]
	FROM	
				sys.[query_store_query]			AS	q
	INNER JOIN	sys.[query_store_query_text]	AS	t	ON q.query_text_id	=	t.query_text_id
	INNER JOIN	sys.[objects]					AS	o	ON q.object_id		=	o.object_id
	
	-------------------------------------------------

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
	INNER JOIN	sys.[query_store_query_text]	AS	t	ON	q.[query_text_id]	=	t.[query_text_id]
	INNER JOIN	sys.[query_store_plan]			AS	p	ON	q.[query_id]		=	p.[query_id]
	INNER JOIN	sys.[query_store_runtime_stats]	AS	r	ON	p.[plan_id]			=	r.[plan_id]
	INNER JOIN	sys.[objects]					AS	o	ON	q.[object_id]		=	o.[object_id]
	 