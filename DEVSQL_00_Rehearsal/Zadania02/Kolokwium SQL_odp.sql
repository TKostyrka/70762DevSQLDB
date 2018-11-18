
--	Indeks:...........................................................
--	Imiê i Nazwisko...................................................

--	(1)
----------------------------------------------------------------------------------------------------------------
--	utworzyæ bazê danych o nazwie [Kolokwium_XXXXXX]
--	w miejsce XXXXXX wpisaæ swoj numer indeksu
--	prze³¹czyæ kontekst na t¹ bazê (polecenie USE ...)

	USE [master]
	GO	

	DROP DATABASE IF EXISTS [Kolokwium_123456]
	GO

	CREATE DATABASE [Kolokwium_123456]
	GO

	USE [Kolokwium_123456]
	GO

--	(2)
----------------------------------------------------------------------------------------------------------------
--	utworzyæ dwie tabele:
--		(a) zawieraj¹ca informacje o pracownikach
--		(b) zawieraj¹ca informacje o kosztach poniesionych przez przedsiêbiorstwo

--	na podstawie danych z za³¹czonego pliku zaproponowaæ
--		nazwy tabel
--		nazwy kolumn
--		typy danych
----------------------------------------------------------------------------------------------------------------

	DROP TABLE IF EXISTS [dbo].[Employee]
	DROP TABLE IF EXISTS [dbo].[Cost]
	GO

	CREATE TABLE [dbo].[Employee]
	(
		[EmployeeId]	INT				NOT NULL	PRIMARY KEY
	,	[Name]			VARCHAR(100)	NOT NULL
	,	[ManagerId]		INT 
	)
	GO

	CREATE TABLE [dbo].[Cost]
	(
		[Date]			DATE			NOT NULL
	,	[EmployeeId]	INT				NOT NULL
	,	[Description]	VARCHAR(200)	NOT NULL
	,	[Cost]			INT				NOT NULL
	)
	GO

--	(3)
----------------------------------------------------------------------------------------------------------------
--	w tabeli z danymi pracowniczymi na kolumnie z numerycznym ID, utworzyæ PRIMARY KEY
--	mo¿na to zrobiæ ju¿ w punkcie drugim lub osobno tutaj (jak Pañstwu wygodniej)
----------------------------------------------------------------------------------------------------------------

	--	zrobione w (2)


--	(4)
----------------------------------------------------------------------------------------------------------------
--	napisaæ kod, który za³aduje dane do tabel utworzonych w punkcie (2)
--	u¿yæ kodu przygotowanego w pliku z danymi
--
--	np. ... INSERT INTO/VALUES
----------------------------------------------------------------------------------------------------------------
	
	INSERT INTO [dbo].[Employee]
	(
		[EmployeeId]	
	,	[Name]			
	,	[ManagerId]		
	)
	VALUES 
	(	1,	'Dyrektor'					,	NULL	)	,
	(	2,	'Kierownik Zespo³u A'		,	1		)	,
	(	3,	'Kierownik Zespo³u B'		,	1		)	,
	(	4,	'Koordynator Sekcji A1'		,	2		)	,
	(	5,	'Koordynator Sekcji A2'		,	2		)	,
	(	6,	'Koordynator Sekcji B1'		,	3		)	,
	(	7,	'Pracownik Szeregowy A1_01'	,	4		)	,
	(	8,	'Pracownik Szeregowy A1_02'	,	4		)	,
	(	9,	'Pracownik Szeregowy A1_03'	,	4		)	,
	(	10,	'Pracownik Szeregowy A1_04'	,	4		)	,
	(	11,	'Pracownik Szeregowy A1_05'	,	4		)	,
	(	12,	'Pracownik Szeregowy A2_01'	,	5		)	,
	(	13,	'Pracownik Szeregowy A2_02'	,	5		)	,
	(	14,	'Pracownik Szeregowy A2_03'	,	5		)	,
	(	15,	'Pracownik Szeregowy A2_04'	,	5		)	,
	(	16,	'Pracownik Szeregowy A2_05'	,	5		)	,
	(	17,	'Pracownik Szeregowy B1_01'	,	6		)	,
	(	18,	'Pracownik Szeregowy B1_02'	,	6		)	,
	(	19,	'Pracownik Szeregowy B1_03'	,	6		)
	GO

	INSERT INTO [dbo].[Cost]
	(
		[Date]			
	,	[EmployeeId]	
	,	[Description]	
	,	[Cost]		
	)
	VALUES	
	(	'20170101', 1	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Dyrektor'					,	13000	)	,
	(	'20170101', 2	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Kierownik Zespo³u A'			,	8500	)	,
	(	'20170101', 3	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Kierownik Zespo³u B'			,	8500	)	,
	(	'20170101', 4	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Koordynator A1'				,	5900	)	,
	(	'20170101', 5	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Koordynator A2'				,	6500	)	,
	(	'20170101', 6	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Koordynator B1'				,	6000	)	,
	(	'20170101', 7	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_01'	,	4000	)	,
	(	'20170101', 8	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_02'	,	4200	)	,
	(	'20170101', 9	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_03'	,	4200	)	,
	(	'20170101', 10	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_04'	,	4200	)	,
	(	'20170101', 11	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_05'	,	4200	)	,
	(	'20170101', 12	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_01'	,	4000	)	,
	(	'20170101', 13	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_02'	,	4300	)	,
	(	'20170101', 14	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_03'	,	4300	)	,
	(	'20170101', 15	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_04'	,	4300	)	,
	(	'20170101', 16	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_05'	,	4000	)	,
	(	'20170101', 17	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy B1_01'	,	4000	)	,
	(	'20170101', 18	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy B1_02'	,	4500	)	,
	(	'20170101', 19	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy B1_03'	,	4500	)	,
	(	'20170101', 1	,	'Bonus,Styczeñ2017, Dyrektor'										,	2000	)	,
	(	'20170101', 2	,	'Bonus,Styczeñ2017, Kierownik Zespo³u A'							,	1000	)	,
	(	'20170101', 3	,	'Bonus,Styczeñ2017, Kierownik Zespo³u B'							,	1000	)	,
	(	'20170101', 4	,	'Bonus,Styczeñ2017, Koordynator A1'									,	750		)	,
	(	'20170101', 5	,	'Bonus,Styczeñ2017, Koordynator A2'									,	750		)	,
	(	'20170101', 6	,	'Bonus,Styczeñ2017, Koordynator B1'									,	750		)	,
	(	'20170101', 7	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_01'						,	350		)	,
	(	'20170101', 8	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_02'						,	350		)	,
	(	'20170101', 9	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_03'						,	350		)	,
	(	'20170101', 10	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_04'						,	350		)	,
	(	'20170101', 11	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_05'						,	350		)	,
	(	'20170101', 12	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_01'						,	350		)	,
	(	'20170101', 13	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_02'						,	350		)	,
	(	'20170101', 14	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_03'						,	350		)	,
	(	'20170101', 15	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_04'						,	350		)	,
	(	'20170101', 16	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_05'						,	350		)	,
	(	'20170101', 17	,	'Bonus,Styczeñ2017, Pracownik Szeregowy B1_01'						,	350		)	,
	(	'20170101', 18	,	'Bonus,Styczeñ2017, Pracownik Szeregowy B1_02'						,	350		)	,
	(	'20170101', 19	,	'Bonus,Styczeñ2017, Pracownik Szeregowy B1_03'						,	350		)	
	GO

--	(5)
----------------------------------------------------------------------------------------------------------------
--	utworzyæ widok, 
--	który zwróci pracowników maj¹cych w nazwie ci¹g "Pracownik Szeregowy A"
----------------------------------------------------------------------------------------------------------------
	
	DROP VIEW IF EXISTS [dbo].[View_Exc05]
	GO

	CREATE VIEW [dbo].[View_Exc05]
	AS
	SELECT
		[e].[EmployeeId]
	,	[e].[Name]
	,	[e].[ManagerId]
	FROM
		[dbo].[Employee] AS [e]
	WHERE
		[e].[Name] LIKE '%Pracownik Szeregowy A%';
	GO

	SELECT
		[v].[EmployeeId]
	,	[v].[Name]
	,	[v].[ManagerId]
	FROM
		[dbo].[View_Exc05] AS [v];
	GO


--	(6)
----------------------------------------------------------------------------------------------------------------
--	napisaæ zapytanie, które zwróci listê pracowników (Id oraz nazwa)
--	oraz sumaryczne koszty przypisane do nich

--	... np. JOIN/GROUP BY/SUM()
----------------------------------------------------------------------------------------------------------------

	SELECT
		[e].[EmployeeId]
	,	[e].[Name]
	,	[Cost] = SUM([c].[Cost])
	FROM
		[dbo].[Employee]	AS [e]
	INNER JOIN [dbo].[Cost] AS [c] ON [c].[EmployeeId] = [e].[EmployeeId]
	GROUP BY 
		[e].[EmployeeId]
	,	[e].[Name]
	GO

--	(7)
----------------------------------------------------------------------------------------------------------------
--	napisaæ zapytanie, które zwróci listê dziesiêciu najwiêkszych poniesionych kosztów
--	do zapytania dodaæ kolumnê które numeruje je od najwiêkszego do najmniejszego

--	... np. TOP/ORDER BY/ROW_NUMBER
----------------------------------------------------------------------------------------------------------------
	
	SELECT	TOP 10
			[c].[Date]
	,		[c].[EmployeeId]
	,		[c].[Description]
	,		[c].[Cost]
	,		ROW_NUMBER() OVER ( ORDER BY [c].[Cost] DESC ) AS [row_num]
	FROM
		[dbo].[Cost] AS [c]
	ORDER BY
		[c].[Cost] DESC;
	GO
	 
--	(8)
----------------------------------------------------------------------------------------------------------------
--	skasowaæ z tabeli z pracownikami wszytkich pracowników o nazwie zaczynaj¹cej siê na "Pracownik Szeregowy"
--
--	... DELETE/WHERE/LIKE
----------------------------------------------------------------------------------------------------------------
	
	DELETE FROM
	[dbo].[Employee]
	WHERE
		[Name]	LIKE 'Pracownik Szeregowy%';
	GO

--	(9)
----------------------------------------------------------------------------------------------------------------
--	zrobiæ UPDATE na tabeli z kosztami

--	po skasowaniu pracowników w punkcie 8 w tabeli pozostan¹ wpisy z ID pracowników, którzy ju¿ nie istniej¹ w bazie
--	bo zostali skasowani, we wszystkich takich przypadkach proszê nadpisaæ w tabeli kosztów ID pracownika na (-1)
--
--	UPDATE/JOIN/IS NULL
----------------------------------------------------------------------------------------------------------------
	
	UPDATE	[c]
	SET		[c].[EmployeeId] = -1
	FROM
		[dbo].[Cost]			AS [c]
	LEFT JOIN [dbo].[Employee]	AS [e] ON [e].[EmployeeId] = [c].[EmployeeId]
	WHERE
		[e].[EmployeeId] IS NULL
	GO

	SELECT
		[c].[Date]
	,	[c].[EmployeeId]
	,	[c].[Description]
	,	[c].[Cost]
	FROM
		[dbo].[Cost] AS [c]
	WHERE
		[c].[EmployeeId] = -1;
	GO


--	(10*) - nieobowi¹zkowe, dodatkowe punkty do oceny koñcowej z przedmiotu
-------------------------------------------------------------
--	napisaæ zapytanie które zwraca koszty wygenerowane przez 
--	wszystkich pracowników podlegaj¹cych pod "Kierownik Zespo³u A"
--	u¿yæ rekurencyjnego CTE do wygenerowania listy pracowników

--	zapytanie zapisaæ w postaci funkcji tabelarycznej
--	a nazwê pracownika "Kierownik Zespo³u A" sparametryzowaæ
-------------------------------------------------------------
	
	WITH cte
	AS
	(
		SELECT 
			[e].[EmployeeId]
		,	[e].[Name]
		,	[e].[ManagerId]
		FROM [dbo].[Employee] AS [e]
		WHERE [e].[Name] = 'Kierownik Zespo³u A'

		UNION ALL

		SELECT 
			[e].[EmployeeId]
		,	[e].[Name]
		,	[e].[ManagerId]
		FROM cte AS c
		INNER JOIN [dbo].[Employee] AS [e] ON [e].[ManagerId] = [c].[EmployeeId]
	)
	SELECT *
	FROM [cte]
	GO

	DROP FUNCTION IF EXISTS [dbo].[EmployeeCTE]
	GO

	CREATE FUNCTION [dbo].[EmployeeCTE](@empName VARCHAR(100))
	RETURNS TABLE
	AS
	RETURN
	WITH cte
	AS
	(
		SELECT 
			[e].[EmployeeId]
		,	[e].[Name]
		,	[e].[ManagerId]
		,	[Lvl] = 1
		FROM [dbo].[Employee] AS [e]
		WHERE [e].[Name] = @empName

		UNION ALL

		SELECT 
			[e].[EmployeeId]
		,	[e].[Name]
		,	[e].[ManagerId]
		,	[Lvl] = c.[Lvl] + 1
		FROM cte AS c
		INNER JOIN [dbo].[Employee] AS [e] ON [e].[ManagerId] = [c].[EmployeeId]
	)
	SELECT *
	FROM [cte]
	GO

	SELECT *
	FROM [dbo].[EmployeeCTE]('Kierownik Zespo³u A')
	ORDER BY [Lvl]
	GO

	SELECT *
	FROM [dbo].[EmployeeCTE]('Dyrektor')
	ORDER BY [Lvl]
	GO

