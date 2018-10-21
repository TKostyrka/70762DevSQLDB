	--	utworzenie bazy
	-------------------------------------------

		USE [master]
		GO

		IF DB_ID('SetOps') IS NOT NULL DROP DATABASE SetOps
		GO

		CREATE DATABASE SetOps
		GO

		USE SetOps
		GO

	--	utworzenie tabeli + uzupe³nienie danymi
	-------------------------------------------

		IF OBJECT_ID('table_test1') IS NOT NULL DROP TABLE [dbo].[table_test1]
		IF OBJECT_ID('table_test2') IS NOT NULL DROP TABLE [dbo].[table_test2]

		CREATE TABLE [dbo].[table_test1]
		(
		    kol_ID	INT IDENTITY(1,1) PRIMARY KEY	NOT NULL	,
			kol_DT	DATE							NOT NULL	,
			kol_NM	NUMERIC(10,2)					NOT NULL	,
			kol_VC	VARCHAR(100)					NULL
		)

		CREATE TABLE [dbo].[table_test2]
		(
		    kol_ID	INT IDENTITY(1,1) PRIMARY KEY	NOT NULL	,
			kol_DT	DATE							NOT NULL	,
			kol_NM	NUMERIC(10,2)					NOT NULL	,
			kol_NL	INT								NULL
		)

		INSERT INTO [dbo].[table_test1]( [kol_DT], [kol_NM],[kol_VC])
		VALUES
				('2016-01-01',	RAND(),	'Ken'		),
				('2016-02-01',	RAND(),	'Terri'		),
				('2016-03-01',	RAND(),	'Roberto'	),
				('2016-04-01',	RAND(),	'Rob'		),
				('2016-05-01',	RAND(),	'Ray'		),
				('2016-06-01',	RAND(),	'Jossef'	)

		INSERT INTO [dbo].[table_test2]( [kol_DT], [kol_NM],[kol_NL] )
		VALUES
				('2016-01-01',	RAND(),	1),
				('2016-02-01',	RAND(),	1),
				('2016-03-01',	RAND(),	1),
				('2016-04-01',	RAND(),	2),
				('2016-05-01',	RAND(),	2),
				('2016-06-01',	RAND(),	2),
				('2016-07-01',	RAND(),	3)

	--	operatory zbiorów - SET OPERATORS
	-------------------------------------------

		--	https://msdn.microsoft.com/en-us/library/ff848745.aspx
		--	https://msdn.microsoft.com/en-us/library/ms180026.aspx
		--	https://msdn.microsoft.com/en-us/library/ms188055.aspx


		--	UNION / UNION ALL
		
		--	UNION

		--	Combines the results of two or more queries into a single result set that includes all the rows that belong to all queries in the union. 
		--	The UNION operation is different from using joins that combine columns from two tables.
		
		--	The following are basic rules for combining the result sets of two queries by using UNION:
			--	The number and the order of the columns must be the same in all queries.
			--	The data types must be compatible.

		--	UNION ALL
		--	Incorporates all rows into the results. This includes duplicates. If not specified, duplicate rows are removed.

				SELECT * 
				FROM [dbo].[table_test1]

				UNION ALL

				SELECT * 
				FROM [dbo].[table_test2]

			/*
				b³¹d - próbujemy ³¹czyæ kol_VC z jednej z kol_NL z drugiej - inne, niekompatybilne typy danych

				Msg 245, Level 16, State 1, Line 80
				Conversion failed when converting the varchar value 'Ken' to data type int.
			*/

			-- UNION ALL nie usuwa duplikatów !!

				SELECT
					'UNION ALL'	AS [example],	
					[kol_ID] ,
					[kol_DT] ,
					[kol_NM]
				FROM
					[dbo].[table_test1]

				UNION ALL

				SELECT
					'UNION ALL'	AS [example],
					[kol_ID] ,
					[kol_DT] ,
					[kol_NM]
				FROM
					[dbo].[table_test2];

			-- UNION usuwa duplikaty !!

				SELECT
					'UNION'	AS [example],
					[kol_ID] ,
					[kol_DT]
				FROM
					[dbo].[table_test1]

				UNION

				SELECT
					'UNION'	AS [example],
					[kol_ID] ,
					[kol_DT]
				FROM
					[dbo].[table_test2];

		--	EXCEPT

		--	EXCEPT returns distinct rows from the left input query that aren’t output by the right input query.

			-- (A/B)

				SELECT
					'EXCEPT'	AS [example],
					[kol_ID] ,
					[kol_DT]
				FROM
					[dbo].[table_test1]

				EXCEPT

				SELECT
					'EXCEPT'	AS [example],
					[kol_ID] ,
					[kol_DT]
				FROM
					[dbo].[table_test2];

			-- (B/A)

				SELECT
					'EXCEPT'	AS [example],
					[kol_ID] ,
					[kol_DT]
				FROM
					[dbo].[table_test2]

				EXCEPT

				SELECT
					'EXCEPT'	AS [example],
					[kol_ID] ,
					[kol_DT]
				FROM
					[dbo].[table_test1];

		--	INTERSECT
		--	INTERSECT returns distinct rows that are output by both the left and right input queries operator.

			SELECT
				'INTERSECT'	AS [example],
				[kol_ID] ,
				[kol_DT]
			FROM
				[dbo].[table_test1]

			INTERSECT

			SELECT
				'INTERSECT'	AS [example],
				[kol_ID] ,
				[kol_DT]
			FROM
				[dbo].[table_test2];

	--	sprz¹tamy - kasowanie bazy
	-------------------------------------------

		USE [master]
		GO

		IF DB_ID('SetOps') IS NOT NULL DROP DATABASE SetOps
		GO
