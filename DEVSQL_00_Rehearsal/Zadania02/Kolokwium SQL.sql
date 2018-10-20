
--	Indeks:...........................................................
--	Imiê i Nazwisko...................................................

--	(1)
----------------------------------------------------------------------------------------------------------------
--	utworzyæ bazê danych o nazwie [Kolokwium_XXXXXX]
--	w miejsce XXXXXX wpisaæ swoj numer indeksu
--	prze³¹czyæ kontekst na t¹ bazê (polecenie USE ...)

	--	<< tu wpisz kod >>

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

	--	<< tu wpisz kod >>

--	(3)
----------------------------------------------------------------------------------------------------------------
--	w tabeli z danymi pracowniczymi na kolumnie z numerycznym ID, utworzyæ PRIMARY KEY
--	mo¿na to zrobiæ ju¿ w punkcie drugim lub osobno tutaj (jak Pañstwu wygodniej)
----------------------------------------------------------------------------------------------------------------

	--	<< tu wpisz kod >>


--	(4)
----------------------------------------------------------------------------------------------------------------
--	napisaæ kod, który za³aduje dane do tabel utworzonych w punkcie (2)
--	u¿yæ kodu przygotowanego w pliku z danymi
--
--	np. ... INSERT INTO/VALUES
----------------------------------------------------------------------------------------------------------------
	
	--	<< tu wpisz kod >>


--	(5)
----------------------------------------------------------------------------------------------------------------
--	utworzyæ widok, 
--	który zwróci pracowników maj¹cych w nazwie ci¹g "Pracownik Szeregowy A"
----------------------------------------------------------------------------------------------------------------
	
	--	<< tu wpisz kod >>


--	(6)
----------------------------------------------------------------------------------------------------------------
--	napisaæ zapytanie, które zwróci listê pracowników (Id oraz nazwa)
--	oraz sumaryczne koszty przypisane do nich

--	... np. JOIN/GROUP BY/SUM()
----------------------------------------------------------------------------------------------------------------
	
	--	<< tu wpisz kod >>


--	(7)
----------------------------------------------------------------------------------------------------------------
--	napisaæ zapytanie, które zwróci listê dziesiêciu najwiêkszych poniesionych kosztów
--	do zapytania dodaæ kolumnê które numeruje je od najwiêkszego do najmniejszego

--	... np. TOP/ORDER BY/ROW_NUMBER
----------------------------------------------------------------------------------------------------------------
	
	--	<< tu wpisz kod >>

--	(8)
----------------------------------------------------------------------------------------------------------------
--	skasowaæ z tabeli z pracownikami wszytkich pracowników o nazwie zaczynaj¹cej siê na "Pracownik Szeregowy"
--
--	... DELETE/WHERE/LIKE
----------------------------------------------------------------------------------------------------------------


--	(9)
----------------------------------------------------------------------------------------------------------------
--	zrobiæ UPDATE na tabeli z kosztami

--	po skasowaniu pracowników w punkcie 8 w tabeli pozostan¹ wpisy z ID pracowników, którzy ju¿ nie istniej¹ w bazie
--	bo zostali skasowani, we wszystkich takich przypadkach proszê nadpisaæ w tabeli kosztów ID pracownika na (-1)
--
--	UPDATE/JOIN/IS NULL
----------------------------------------------------------------------------------------------------------------


--	(10*) - nieobowi¹zkowe, dodatkowe punkty do oceny koñcowej z przedmiotu
-------------------------------------------------------------
--	napisaæ zapytanie które zwraca koszty wygenerowane przez 
--	wszystkich pracowników podlegaj¹cych pod "Kierownik Zespo³u A"
--	u¿yæ rekurencyjnego CTE do wygenerowania listy pracowników

--	zapytanie zapisaæ w postaci funkcji tabelarycznej
--	a nazwê pracownika "Kierownik Zespo³u A" sparametryzowaæ
-------------------------------------------------------------
	
	--	<< tu wpisz kod >>
