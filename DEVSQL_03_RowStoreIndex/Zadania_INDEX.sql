USE [ContosoRetailDW]
GO

--	#1
--	Utworzyæ tabelê z 7 kolumnami dowolnego typu, nazwy kolumna01-kolumna07
--------------------------------------------------------------------
	

--	#2
--	Utworzyæ indeks klastrowany na [kolumna01]
--------------------------------------------------------------------



--	#3
--	Utworzyæ unikalny indeks nieklastrowany klastrowany na [kolumna02]
--------------------------------------------------------------------


--	#4
--	Utworzyæ indeks nieklastrowany na ([kolumna03], [kolumna04])
--------------------------------------------------------------------


--	#5
--	Utworzyæ filtrowany indeks nieklastrowany na ([kolumna05])
--	z warunkiem [kolumna05] IS NOT NULL
--------------------------------------------------------------------



--	#6
--	wykorzystuj¹c widoki systemowe
--	przygotowaæ raport zawieraj¹cy informacjê o wszystkich utworzonych indeksach:

--		nazwa schematu
--		nazwa tabeli
--		ID indeksu
--		nazwa indeksu
--		typ indeksu
--		informacjê czy indeks jest unikalny
--		informacjê czy indeks jest filtrowany

--		dodatkowo:
--		do zapytania dodaæ informacjê o wszystkich kolumnach u¿ytych w indeksie 
--		dla ka¿dego indeksu powinniœmy otrzymaæ tyle wierszy ile zawiera kolumn
--		dla ka¿dej kolumny wyœwietliæ nastêpuj¹ce informacje

--		nazwa kolumny
--		kolejnoœæ kolumny w kluczu sortowania
--		informacjê czy jest to kolumna dodana klauzuj¹ INCLUDE

--------------------------------------------------------------------

	--	[sys].[schemas]			
	--	[sys].[tables]			
	--	[sys].[indexes]			
	--	[sys].[index_columns]	
	--	[sys].[columns]			
