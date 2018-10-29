	/*
		
		w systemach bazowych w tabelach s³ownikowych (lista us³ug, produktów, pracowników itp...)
		czêsto implementowany taki komplet kolumn:
			-	klucz techniczny, niewidoczny dla u¿ytkownika z poziomu GUI, nie nios¹cy ¿adnej informacji biznesowej
				IDENTITY, SEQUENCE...
			-	klucz biznesowy, nadawany przez pracownika, unikalny w ramach tabeli, nios¹cy informacjê
				np. HIP01, HIP02 jako kolejne typy kredytów hipotecznych
			-	pe³na nazwa "Kredyt Hipoteczny typu XXX edycja YYY"

		wszystkie mechanizmy wewn¹trz bazy - FK, logika procedur itp. - powinna byæ zawsze pisana przy wykorzystaniu ³¹czeñ
		na kluczach technicznych i powinny byæ one niezmienne. nie nios¹ ¿adnej wartoœci informacyjnej wiêc u¿ytkownika nie powinno 
		interesowaæ czy dana pozycja dostanie numer 7,8 czy 199...

		[wa¿ne]: pisz¹c o mechanizmach wewn¹tz bazy nie mam na myœli hardkodowania kluczy a ³¹czenia, czyli
			robimy: JOIN ... ON z.Key = y.Key
			nie robimy: WHERE z.Key = 1 

		klucze biznesowe mog¹ byæ zmieniane - np. gdy ktoœ siê r¹bnie i wpisze taki klucz niezgodnie z kowencja np.
		w kredycie hipotecznym zrobi id GOT01 jak dla gotówkowych

		w Przypadku hurtownii temat optymalizacji prêdkoœci wchodzi mocniej w grê, dlatego w systemach raportowych
		dodanie takich kluczy to dobra praktyka stosowana prawie zawsze

		cd. pod kodem

	*/

	IF DB_ID('TestSalon') IS NULL CREATE DATABASE TestSalon	
	GO

	USE TestSalon
	GO

	DROP TABLE IF EXISTS Brand
	DROP TABLE IF EXISTS Models
	GO

	CREATE TABLE Brand
	(
		Bra_Id		SMALLINT		NOT NULL	IDENTITY(1,1) PRIMARY KEY	--	techniczny
	,	Bra_Code	VARCHAR(10)		NOT NULL	UNIQUE						--	biznesowy
	,	Bra_Name	VARCHAR(100)	NOT NULL
	)

	CREATE TABLE Models
	(
		Mod_Id		SMALLINT		NOT NULL	IDENTITY(1,1) PRIMARY KEY	--	techniczny
	,	Mod_Code	VARCHAR(10)		NOT NULL	UNIQUE						--	biznesowy
	,	Mod_Name	VARCHAR(100)	NOT NULL
	,	Bra_Id		SMALLINT		NOT NULL								--	FK na techniczny

	,	CONSTRAINT	FK_Bra_Id
		FOREIGN KEY (Bra_Id)
		REFERENCES	Brand(Bra_Id)
	)

	/*
		wstawianie danych - Marki
	*/

	INSERT INTO Brand
	VALUES
		('JEEP',	'JEEP, Fiat Chrysler Automobiles (FCA) US LLC'),
		('FORD',	'Ford Motor Company')

	SELECT *
	FROM Brand

	/*
		wstawianie danych - Modele
		do tabeli modeli chcemy wpisaæ konkretne pozycje w raz z FK do (Bra_Id), gdybyœmy to robili raz, to mo¿na:
			- sprawdziæ odpowienie Bra_Id i sobie spisaæ
			- wstawiæ wiersz u¿ywaj¹c tego Id.

		cd. pod kodem
	*/

	INSERT INTO Models
	VALUES
		('GRCH',	'GRAND CHEROKEE', 1)

	/*
		w aplikacji GUI, której u¿yje pracownik dzia³aæ mo¿e to tak, 
		¿e drop-down modeli zbudowany jest na liœcie klucz-wartoœæ: pracownik wybiera "JEEP" a pod spodem wstawiane jest "1"
	
		zadanie w projekcie polega na tym, ¿eby w ¿adnym miejscu kodu nie u¿ywaæ wbitych na sztywno wartoœci kluczy
		kod ma byæ odporny na zmiany -> gdybym przed insertem JEEP'a w linijce 61 wstawi³ jeden wiersz
		to on dosta³by IDENTITY = 1 i ca³y kod przestaje dzia³aæ.

		mo¿na to zrobiæ np. tak:
	*/

		INSERT INTO Models(Mod_Code, Mod_Name, Bra_Id)
		SELECT
			M.Mod_Code
		,	M.Mod_Name
		,	B.Bra_Id
		FROM 
		(
			SELECT 'COMP',	'COMPASS'	, 'JEEP' UNION ALL
			SELECT 'CHER',	'CHEROKEE'	, 'JEEP' UNION ALL
			SELECT 'RENE',	'RENEGADE'	, 'JEEP' UNION ALL
			SELECT 'WRAN',	'WRANGLER'	, 'JEEP'
		) AS M(Mod_Code, Mod_Name, Bra_Code)
		INNER JOIN Brand AS B  ON M.Bra_Code = B.Bra_Code

		SELECT *
		FROM Models

	/*
		albo
	*/

		INSERT INTO Models(Mod_Code, Mod_Name, Bra_Id)
		SELECT
			M.Mod_Code
		,	M.Mod_Name
		,	B.Bra_Id
		FROM 
		(
			VALUES
				('FIES',	'FIESTA'			, 'FORD')
			,	('TOUR',	'TOURNEO COURIER'	, 'FORD')
			,	('ECOS',	'ECOSPORT'			, 'FORD')
			,	('MUST',	'MUSTANG'			, 'FORD')
		) AS M(Mod_Code, Mod_Name, Bra_Code)
		INNER JOIN Brand AS B  ON M.Bra_Code = B.Bra_Code
