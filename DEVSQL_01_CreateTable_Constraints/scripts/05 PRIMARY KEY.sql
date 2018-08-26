USE [TestTSQL]
GO

		-------------------------------------------------------------------------

			CREATE TABLE Employees
			(
				Employees_ID	VARCHAR(3)		PRIMARY KEY NOT NULL,
				Employees_FName	VARCHAR(100)	NULL,
				Employees_LName	VARCHAR(100)	NULL
			)

				INSERT INTO Employees
				VALUES	( 	'JKO' ,	'Jan' ,	'Kowalski'  )	,
						( 	'ANO' ,	'Adam' ,'Nowak'  )

				INSERT INTO Employees
				VALUES	( 	'JKO' ,	'Jan' ,	'Kowalski'  )

		-------------------------------------------------------------------------

			CREATE TABLE Products
			(
				prod_Key		INT				IDENTITY(1,1) PRIMARY KEY NOT NULL,
				prod_Code		VARCHAR(3)		NOT NULL	,
				prod_Name		VARCHAR(100)	NULL
			)

			INSERT INTO Products
			VALUES	('BK', 'Bike'),
					('CR', 'Car'),
					('BK', 'Tram')

			SELECT *
			FROM Products