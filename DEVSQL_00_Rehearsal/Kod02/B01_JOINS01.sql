	--	utworzenie bazy
	-------------------------------------------

		USE master
		GO

		IF DB_ID('DBFundJoins') IS NOT NULL DROP DATABASE DBFundJoins
		GO

		CREATE DATABASE DBFundJoins
		GO

		USE DBFundJoins
		GO

	--	utworzenie tabeli + uzupe³nienie danymi
	-------------------------------------------
			
		IF OBJECT_ID('tab_pracownicy')	IS NOT NULL DROP TABLE tab_pracownicy
		IF OBJECT_ID('tab_klienci')		IS NOT NULL DROP TABLE tab_klienci

		CREATE TABLE tab_pracownicy
		(
			prac_ID			VARCHAR(3)		PRIMARY KEY NOT NULL,
			prac_Imie		VARCHAR(100)	NULL,
			prac_Nazwisko	VARCHAR(100)	NULL
		)

		CREATE TABLE tab_klienci
		(
			klient_ID		VARCHAR(3)		PRIMARY KEY NOT NULL,
			klient_Imie		VARCHAR(100)	NULL,
			klient_Nazwisko	VARCHAR(100)	NULL,
			prac_ID			VARCHAR(3)		NULL
		)

		-- wstawiamy pracowników:

		INSERT INTO [dbo].[tab_pracownicy]
		VALUES	( 	'JKO' ,	'Jan' ,	'Kowalski'  )	,
				( 	'ANO' ,	'Adam' ,'Nowak'  )		,
				( 	'TEC' ,	'Tech' ,'Technical'  )		
		
		-- wstawiamy klientów:

		INSERT INTO [dbo].[tab_klienci]
		VALUES	( 	'KL1' ,	'Imiê 1'	,	'Nazwisko 1' , 'JKO'  ),
				( 	'KL2' ,	'Imiê 2'	,	'Nazwisko 2' , 'JKO'  ),
				( 	'KL3' ,	'Imiê 3'	,	'Nazwisko 3' , 'JKO'  ),
				( 	'KL4' ,	'Imiê 4'	,	'Nazwisko 4' , 'ANO'  ),
				( 	'KL5' ,	'Imiê 5'	,	'Nazwisko 5' , 'ANO'  )	
			
		--	wstawiamy klientów z niepoprawnie przypisanym pracownikiem 
		--	lub bez pracownika (nie ma klucza FK wiêc nie posypie b³êdami)
			
		INSERT INTO [dbo].[tab_klienci]
		VALUES	( 	'NP1' ,	'Niepoprawny 1'	,	'Niepop 1' , 'XXX'  ),
				( 	'NP2' ,	'Niepoprawny 2'	,	'Niepop 2' , 'YYY'  ),
				( 	'NP3' ,	'Niepoprawny 3'	,	'Niepop 3' , NULL  )	
			
		SELECT * FROM [dbo].[tab_pracownicy]
		SELECT * FROM [dbo].[tab_klienci]

	--	INNER JOIN 
	---------------------------------------------------------
		
		-- (01)

		SELECT 
			pr.*,
			kl.* 
		FROM 
					[dbo].[tab_pracownicy]	AS pr
		INNER JOIN	[dbo].[tab_klienci]		AS kl ON [kl].[prac_ID] = [pr].[prac_ID]

		-- (02)

		SELECT 
			pr.*,
			kl.* 
		FROM 
					[dbo].[tab_pracownicy]	AS pr
		INNER JOIN	[dbo].[tab_klienci]		AS kl ON 1=0

		-- (03)

		SELECT 
			pr.*,
			kl.* 
		FROM 
					[dbo].[tab_pracownicy]	AS pr
		INNER JOIN	[dbo].[tab_klienci]		AS kl ON 1=1

		-- (04)

		SELECT 
			[kl].[klient_ID] ,
			[kl].[klient_Imie] ,
			[kl].[klient_Nazwisko]
		FROM 
					[dbo].[tab_pracownicy]	AS pr
		INNER JOIN	[dbo].[tab_klienci]		AS kl ON [kl].[prac_ID] = [pr].[prac_ID]
		WHERE 
			pr.[prac_Nazwisko] = 'Kowalski'

		-- (05)

		SELECT 
			[kl].[klient_ID] ,
			[kl].[klient_Imie] ,
			[kl].[klient_Nazwisko]
		FROM 
					[dbo].[tab_pracownicy]	AS pr
		INNER JOIN	[dbo].[tab_klienci]		AS kl	ON	[kl].[prac_ID] = [pr].[prac_ID]
													AND	pr.[prac_Nazwisko] = 'Kowalski'	

	--	LEFT OUTER JOIN
	-----------------------------------------------------

		-- (01)

		SELECT 
			pr.*,
			kl.* 
		FROM 
					[dbo].[tab_pracownicy]	AS pr
		LEFT JOIN	[dbo].[tab_klienci]		AS kl ON [kl].[prac_ID] = [pr].[prac_ID]

		-- (02)
				
		SELECT 
			pr.*,
			kl.* 
		FROM 
					[dbo].[tab_pracownicy]	AS pr
		LEFT JOIN	[dbo].[tab_klienci]		AS kl ON [kl].[prac_ID] = [pr].[prac_ID]
		WHERE
			[kl].[prac_ID] IS NULL

		-- (03)

		SELECT 
			pr.*,
			kl.* 
		FROM 
					[dbo].[tab_klienci]		AS kl
		LEFT JOIN	[dbo].[tab_pracownicy]	AS pr ON [kl].[prac_ID] = [pr].[prac_ID]
		WHERE
			[pr].[prac_ID] IS NULL

	--	RIGHT OUTER JOIN
	-----------------------------------------------------

		-- (01)

		SELECT 
			pr.*,
			kl.* 
		FROM 
					[dbo].[tab_pracownicy]	AS pr
		RIGHT JOIN	[dbo].[tab_klienci]		AS kl ON [kl].[prac_ID] = [pr].[prac_ID]

		-- (02)

		SELECT 
			pr.*,
			kl.* 
		FROM 
					[dbo].[tab_pracownicy]	AS pr
		RIGHT JOIN	[dbo].[tab_klienci]		AS kl ON [kl].[prac_ID] = [pr].[prac_ID]
		WHERE 
			[pr].[prac_ID] IS NULL

	--	FULL OUTER JOIN
	-----------------------------------------------------   

		-- (01)

		SELECT 
			pr.*,
			kl.* 
		FROM 
						[dbo].[tab_pracownicy]	AS pr
		FULL OUTER JOIN	[dbo].[tab_klienci]		AS kl ON [kl].[prac_ID] = [pr].[prac_ID]

		-- (02)

		SELECT 
			pr.*,
			kl.* 
		FROM 
						[dbo].[tab_pracownicy]	AS pr
		FULL OUTER JOIN	[dbo].[tab_klienci]		AS kl ON [kl].[prac_ID] = [pr].[prac_ID]
		WHERE 
			[pr].[prac_ID]	IS NULL
		OR	[kl].[prac_ID]	IS NULL
	
	--	CROSS JOIN 
	--------------------------------------------------------- 

		-- (01)

		SELECT 
			pr.*,
			kl.* 
		FROM 
					[dbo].[tab_pracownicy]	AS pr
		INNER JOIN	[dbo].[tab_klienci]		AS kl ON 1=1

		-- (02)

		SELECT 
			pr.*,
			kl.* 
		FROM 
					[dbo].[tab_pracownicy]	AS pr
		CROSS JOIN	[dbo].[tab_klienci]		AS kl


	--	usuniêcie bazy
	-------------------------------------------

		USE master
		GO

		IF DB_ID('DBFundJoins') IS NOT NULL DROP DATABASE DBFundJoins
		GO