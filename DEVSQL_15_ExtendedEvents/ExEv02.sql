USE [ExEvTEST]
GO

	--------------------------------------------------------------------------------

		SELECT	TOP 5 *	FROM sys.dm_xe_packages
		SELECT	TOP 5 *	FROM sys.dm_xe_objects
		SELECT	TOP 5 *	FROM sys.dm_xe_object_columns

	--------------------------------------------------------------------------------

		SELECT 
			p.[name]
		,	o.[object_type]
		,	o.[name]		
		,	o.[description]			
		FROM 
					sys.dm_xe_packages	AS p 
		INNER JOIN	sys.dm_xe_objects	AS o	ON p.[guid]=o.[package_guid]
		WHERE 1=1
		AND o.[object_type]	= 'action'
		ORDER BY  
			p.[name]
		,	o.[object_type]
		,	o.[name]	

	--------------------------------------------------------------------------------

		SELECT 
			p.[name]
		,	o.[object_type]
		,	o.[name]		
		,	o.[description]	
		,	c.[name]			
		,	c.[column_type]	
		,	c.[description]	
		,	c.[type_name]		
		FROM 
					sys.dm_xe_packages			AS p 
		INNER JOIN	sys.dm_xe_objects			AS o	ON	p.[guid]	=	o.[package_guid]
		INNER JOIN	sys.dm_xe_object_columns	AS c	ON	p.[guid]	=	c.[object_package_guid]
														AND o.[name]	=	c.[object_name]
		WHERE 1=1
		AND o.[object_type]	=	'event'
		AND c.[object_name]	=	'lock_acquired'
		ORDER BY  
			p.[name]
		,	o.[object_type]
		,	o.[name]

