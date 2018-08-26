USE [TestTSQL]
GO

		-------------------------------------------------------------------------

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
			prac_ID			VARCHAR(3)
		)

		ALTER TABLE			tab_klienci
		ADD CONSTRAINT		prac_ID_klienci_pracownicy
		FOREIGN KEY			(prac_ID)
		REFERENCES			tab_pracownicy(prac_ID)

		-------------------------------------------------------------------------

		INSERT INTO [dbo].[tab_pracownicy]
		VALUES	( 	'JKO' ,	'Jan' ,	'Kowalski'  ),
				( 	'ANO' ,	'Adam' ,'Nowak'  )
		
		-- wstawiamy klientów:

		INSERT INTO [dbo].[tab_klienci]
		VALUES	( 	'KL1' ,	'Imiê 1'	,	'Nazwisko 1' , 'JKO'  ),
				( 	'KL2' ,	'Imiê 2'	,	'Nazwisko 2' , 'JKO'  ),
				( 	'KL3' ,	'Imiê 3'	,	'Nazwisko 3' , 'JKO'  ),
				( 	'KL4' ,	'Imiê 4'	,	'Nazwisko 4' , 'ANO'  ),
				( 	'KL5' ,	'Imiê 5'	,	'Nazwisko 5' , 'ANO'  )			

		INSERT INTO [dbo].[tab_klienci]
		VALUES	( 	'KL6' ,	'Imiê 6'	,	'Nazwisko 6' , NULL  ),
				( 	'KL7' ,	'Imiê 7'	,	'Nazwisko 7' , NULL  )

		INSERT INTO [dbo].[tab_klienci]
		VALUES	( 	'KL8' ,	'Imiê 8'	,	'Nazwisko 8' , 'XXX'  ),
				( 	'KL9' ,	'Imiê 9'	,	'Nazwisko 9' , 'YYY'  )